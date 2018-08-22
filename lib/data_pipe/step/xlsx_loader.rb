require "ostruct"
require "rubyXL"
require "data_pipe/record"
require "data_pipe/steppable"

module DataPipe::Step
  class XlsxLoader
    include DataPipe::Steppable

    def prepare(params=EMPTY_PARAMS, &blk)
      @params = params
      @fnc = blk

      params.sheet = 0 unless params.respond_to? :sheet
      params.first_data_row = 1 unless params.respond_to? :first_data_row
      params.headers = params.respond_to? :header_row

      self
    end

    def step_command
      :load_from_xlsx
    end

    def iter
      Enumerator.new do |rsp|
        workbook = RubyXL::Parser.parse(params.stream)
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