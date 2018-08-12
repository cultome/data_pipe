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
      params.has_header = params.respond_to? :header_row

      self
    end

    def step_command
      :load_from_xlsx
    end

    def iter
      Enumerator.new do |rsp|
        workbook = RubyXL::Parser.parse(params.stream)
        worksheet = workbook[params.sheet]

        worksheet.each do |row|
          next unless row

          if params.has_header && params.header_row == row.r
            headers = get_headers(row.cells)
            record = Record.new(headers, params)
          elsif params.first_data_row <= row.r
            data = get_data(row.cells)
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
      data = {}

      cells.each do |cell|
        val = cell && cell.value
        data[cell.column] = val
      end

      data
    end

    def get_data(cells)
      data = {}

      cells.each do |cell|
        val = cell && cell.value
        data[cell.column] = val
      end

      data
    end
  end
end
