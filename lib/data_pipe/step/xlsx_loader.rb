require "rubyXL"
require "data_pipe/record"
require "data_pipe/stepable"

module DataPipe::Step
  class XlsxLoader
    include DataPipe::Stepable

    def step_command
      :load_from_xlsx
    end

    def iter
      Enumerator.new do |rsp|
        workbook = RubyXL::Parser.parse(params.file)
        worksheet = workbook[params.sheet]
        headers = []

        worksheet.each do |row|
          next unless row

          if params.headers && params.header_row == row.r
            headers = get_headers(row.cells)
            next
          elsif params.first_data_row <= row.r
            data = get_data(row.cells, headers)
            record = Record.new(data, params)
          else
            next
          end

          rsp << record unless record.data.empty?
        end
      end
    end

    def default_params
      {
        sheet: 0,
        first_data_row: 2,
        header_row: 1,
        headers: true,
      }
    end

    private

    def get_headers(cells)
      data = []

      cells.each do |cell|
        val = cell && cell.value
        data << val
      end

      data
    end

    def get_data(cells, headers)
      data = {}

      if headers.empty?
        cells.each do |cell|
          val = cell && cell.value
          data[cell.column] = val
        end
      else
        cells.zip(headers).each do |(cell, header)|
          next if header.nil?

          val = cell && cell.value
          data[header] = val
        end
      end

      data
    end
  end
end
