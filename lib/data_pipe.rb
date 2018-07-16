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
      .each do |step|
        instance = step.new
        cmd_name = instance.pipe_command

        Pipe.define_method cmd_name do |args={}, &blk|
          params = OpenStruct.new(args)
          pipe << instance.prepare(params, &blk)
        end
      end
  end

  class Pipe
    include Loggable

    attr_reader :pipe

    def initialize
      @pipe = []
    end

    def process!
      last_step = prepare_steps

      last_step.each do |record|
        record
      end
    end

    def date_field(opts={})
      params = OpenStruct.new(opts)
      Step::SchemaHelper::DateFieldSchema.new(params)
    end

    def string_field(opts={})
      params = OpenStruct.new(opts)
      Step::SchemaHelper::StringFieldSchema.new(params)
    end

    def int_field(opts={})
      params = OpenStruct.new(opts)
      Step::SchemaHelper::IntFieldSchema.new(params)
    end

    def float_field(opts={})
      params = OpenStruct.new(opts)
      Step::SchemaHelper::FloatFieldSchema.new(params)
    end

    private

    def guess_resource_type(resource_path)
      ext = File.extname(resource_path)
      ext.slice(1, ext.size).to_sym
    end

    def prepare_steps
      pipe.reduce(NullStep.new) do |upstream, current|
        current.set_input upstream
      end
    end
  end
end
