require "data_pipe/version"
require "data_pipe/step"
require "data_pipe/error"
require "data_pipe/refinements"

using DataPipe::Refinements

module DataPipe

  def define_pipe(&block)
    Pipe.new.instance_exec(&block)
  end

  class Pipe
    attr_reader :pipe

    def initialize
      @pipe = []
    end
  end
end

->() {
  steps_base = "#{__dir__}/data_pipe/step"

  def get_dir_files_rec(dirname)
    Dir.entries(dirname)
      .select{|filename| filename !~ /^\.\.?$/}
      .reduce([]) do |acc,child|
      acc << File.join(dirname, child)
      acc
    end
  end

  Dir.entries(steps_base)
    .select{|filename| filename !~ /^\.\.?$/}
    .flat_map {|filename|
    relative_filename = File.join(steps_base, filename)
    if File.directory?(relative_filename)
      get_dir_files_rec(relative_filename)
    else
      [relative_filename]
    end
  }
  .select{|filename| filename.end_with?(".rb") }
  .map{|filename| filename.delete_suffix(".rb").delete_prefix(steps_base + "/") }
  .each{|name| require "data_pipe/step/#{name}" }
  .map{|name| name.gsub("/", "::_") }
  .map{|name| Object.const_get "DataPipe::Step::#{name.pascalcase}" }
  .select{|step| step.respond_to? :new }
  .each {|step|
    instance = step.new
    next unless instance.respond_to? :step_name

    cmd_name = instance.step_name
    DataPipe::Pipe.define_method cmd_name do |args={}, &blk|
      local_instance = step.new
      pipe << local_instance.on_init(args, &blk)
    end
  }
}.call()
