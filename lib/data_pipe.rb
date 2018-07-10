require "data_pipe/version"
require "data_pipe/step_wrapper"
require 'data_pipe/loader'
require 'data_pipe/writer'
require 'data_pipe/schema'
require 'data_pipe/transformation'
require 'data_pipe/error_handler'
require 'data_pipe/error'
require 'data_pipe/null_step'
require 'ostruct'

module DataPipe
  def self.create(&blk)
    instance = DataPipe.new
    instance.instance_exec(&blk)
    instance
  end

  class DataPipe
    attr_reader :pipe

    def initialize
      @pipe = []
    end

    def load_from(resource_path, opts={})
      params = OpenStruct.new(opts)
      res_type = guess_resource_type(resource_path)
      pipe << get_loader(res_type, resource_path, params)
    end

    def write_to(type, output, opts={})
      params = OpenStruct.new(opts)
      pipe << get_writer(type, output, params)
    end

    def process!
      last_step = prepare_steps

      last_step.each do |record|
        record
      end
    end

    def handle_error(&blk)
      pipe << ErrorHandler.new(&blk)
    end

    def filter_properties(*fields)
      pipe << RecordMap.new(fields)
    end

    def map(&blk)
      pipe << RecordProcess.new(&blk)
    end

    def filter_records(&blk)
      pipe << RecordFilter.new(&blk)
    end

    def apply_schema(schema)
      pipe << Schema.new(schema)
    end

    def date_field(opts={})
      params = OpenStruct.new(opts)
      DateFieldSchema.new(params)
    end

    def string_field(opts={})
      params = OpenStruct.new(opts)
      StringFieldSchema.new(params)
    end

    def int_field(opts={})
      params = OpenStruct.new(opts)
      IntFieldSchema.new(params)
    end

    def float_field(opts={})
      params = OpenStruct.new(opts)
      FloatFieldSchema.new(params)
    end

    private

    def guess_resource_type(resource_path)
      ext = File.extname(resource_path)
      ext.slice(1, ext.size).to_sym
    end

    def get_loader(res_type, resource_path, params)
      case res_type
      when :csv
        CSVLoader.new(resource_path, params)
      end
    end

    def get_writer(type, output, params)
      case type
      when :csv then CSVWriter.new(output, params)
      when :json then JSONWriter.new(output, params)
      end
    end

    def prepare_steps
      pipe.reduce(NullStep.new) do |prev,nxt|
        nxt.set_input StepWrapper.new(prev, nxt)
      end
    end
  end
end
