require "data_pipe/version"
require 'data_pipe/loader'
require 'data_pipe/writer'
require 'data_pipe/transformation/schema'
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
      last_step = pipe.reduce(nil) do |acc,step|
        step.set_input acc
        step
      end

      last_step.process!
    end

    def apply_schema(schema)
      pipe << SchemaTransformation.new(schema)
    end

    def date_field(opts={})
      DateFieldSchema.new(opts)
    end

    def string_field(opts={})
      StringFieldSchema.new(opts)
    end

    def int_field(opts={})
      IntFieldSchema.new(opts)
    end

    def float_field(opts={})
      FloatFieldSchema.new(opts)
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
  end
end
