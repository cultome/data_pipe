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
    steps_base = "#{__dir__}/data_pipe/step"

    def get_dir_files_rec(dirname)
      Dir.entries(dirname)
        .select{|filename| filename !~ /^\.\.?$/}
        .reduce([]) do |acc,child|
          if File.directory?(child)
            acc.concat get_dir_files_rec(child)
          else
            acc << File.join(dirname, child)
          end

          acc
        end
    end

    Dir.entries(steps_base)
      .select{|filename| filename !~ /^\.\.?$/}
      .flat_map do |filename|
        relative_filename = File.join(steps_base, filename)
        if File.directory?(relative_filename)
          get_dir_files_rec(relative_filename)
        else
          [relative_filename]
        end
      end
      .select{|filename| filename.end_with?(".rb") }
      .map{|filename| filename.delete_suffix(".rb").delete_prefix(steps_base + "/") }
      .each{|name| require "data_pipe/step/#{name}" }
      .map{|name| "DataPipe::Step::#{name.camelize}".constantize }
      .each do |step|
        instance = step.new
        next unless instance.respond_to? :step_command

        cmd_name = instance.step_command
        Pipe.define_method cmd_name do |args={}, &blk|
          local_instance = step.new
          params = OpenStruct.new(args)
          pipe << local_instance.prepare(params, &blk)
        end
      end
      .each do |step|
        instance = step.new
        next unless instance.respond_to? :helper_command

        cmd_name = instance.helper_command
        Pipe.define_method cmd_name do |args={}, &blk|
          local_instance = step.new
          params = OpenStruct.new(args)
          local_instance.prepare(params, &blk).send(cmd_name)
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
