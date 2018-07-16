require 'ostruct'
require "data_pipe/version"
require 'data_pipe/steppable'
require 'data_pipe/step/map'
require 'data_pipe/step/process'
require 'data_pipe/step/filter'
require 'data_pipe/step/csv_writer'
require 'data_pipe/step/json_writer'
require 'data_pipe/step/csv_loader'
require 'data_pipe/step/json_loader'
require 'data_pipe/step/schema'
require 'data_pipe/step/error_handler'

require 'data_pipe/error'
require 'data_pipe/null_step'
require 'data_pipe/loggable'

module DataPipe
  def self.create(&blk)
    instance = DataPipe.new
    instance.instance_exec(&blk)
    instance
  end

  class DataPipe
    include Loggable

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
      pipe << Step::RecordMap.new(fields)
    end

    def map(&blk)
      pipe << Step::RecordProcess.new(&blk)
    end

    def filter_records(&blk)
      pipe << Step::RecordFilter.new(&blk)
    end

    def apply_schema(schema)
      pipe << Step::Schema::Schema.new(schema)
    end

    def date_field(opts={})
      params = OpenStruct.new(opts)
      Step::Schema::DateFieldSchema.new(params)
    end

    def string_field(opts={})
      params = OpenStruct.new(opts)
      Step::Schema::StringFieldSchema.new(params)
    end

    def int_field(opts={})
      params = OpenStruct.new(opts)
      Step::Schema::IntFieldSchema.new(params)
    end

    def float_field(opts={})
      params = OpenStruct.new(opts)
      Step::Schema::FloatFieldSchema.new(params)
    end

    private

    def guess_resource_type(resource_path)
      ext = File.extname(resource_path)
      ext.slice(1, ext.size).to_sym
    end

    def get_loader(res_type, resource_path, params)
      case res_type
      when :csv then Step::CSVLoader.new(resource_path, params)
      when :json then Step::JSONLoader.new(resource_path, params)
      end
    end

    def get_writer(type, output, params)
      case type
      when :csv then Step::CSVWriter.new(output, params)
      when :json then Step::JSONWriter.new(output, params)
      end
    end

    def prepare_steps
      pipe.reduce(NullStep.new) do |upstream, current|
        current.set_input upstream
      end
    end
  end
end
