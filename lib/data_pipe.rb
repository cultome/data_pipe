require 'ostruct'
require "active_support/inflector"
require "data_pipe/version"
require 'data_pipe/error'
require 'data_pipe/null_step'
require 'data_pipe/loggable'

module DataPipe
  def self.create(&blk)
    instance = Pipe.new
    instance.instance_exec(&blk)
    instance
  end

  def self.included(clazz)
    Dir.children("lib/data_pipe/step")
      .select{|filename| filename.end_with?(".rb") }
      .map{|filename| filename.chomp ".rb" }
      .each{|name| require "data_pipe/step/#{name}" }
      .map{|name| "DataPipe::Step::#{name.camelize}".constantize }
=begin
      .each do |step|
        cmd_name = step.pipe_command
        puts "=================> #{cmd_name} <==================="
        Pipe.define_method cmd_name do
          "ESO!!!"
        end
      end
=end
  end

  class Pipe
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
      pipe << Step::ErrorHandler.new(&blk)
    end

    def filter_properties(*fields)
      pipe << Step::Map.new(fields)
    end

    def map(&blk)
      pipe << Step::Process.new(&blk)
    end

    def filter_records(&blk)
      pipe << Step::Filter.new(&blk)
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
      when :csv then Step::CsvLoader.new(resource_path, params)
      when :json then Step::JsonLoader.new(resource_path, params)
      end
    end

    def get_writer(type, output, params)
      case type
      when :csv then Step::CsvWriter.new(output, params)
      when :json then Step::JsonWriter.new(output, params)
      end
    end

    def prepare_steps
      pipe.reduce(NullStep.new) do |upstream, current|
        current.set_input upstream
      end
    end
  end
end
