require "ostruct"

RSpec.describe "Iterator behavior" do
  let(:output){ StringIO.new }

  context "iterates using a block" do
    it "writer/json" do
      step = prepare_step(DataPipe::Step::JsonWriter.new, stream: output)
      check_iterator step
    end

    it "writer/csv" do
      step = prepare_step(DataPipe::Step::CsvWriter.new, stream: output)
      check_iterator step
    end

    it "schema" do
      step = prepare_step(DataPipe::Step::Schema.new, definition: {
        "a" => DataPipe::Step::SchemaHelper::String.new.prepare,
      })
      check_iterator step
    end

    it "loader/csv" do
      step = DataPipe::Step::CsvLoader.new.prepare(OpenStruct.new(stream: "spec/sample/4.csv", headers: true))
      check_iterator step
    end

    it "transformation/filter" do
      step = prepare_step(DataPipe::Step::Filter.new){|r| true }
      check_iterator step
    end

    it "transformation/process" do
      step = prepare_step(DataPipe::Step::Process.new){|r| r }
      check_iterator step
    end

    it "transformation/map" do
      step = prepare_step(DataPipe::Step::Map.new, keys: ["a", "b"])
      check_iterator step
    end
  end

  context "returns an iterator" do
    it "writer/json" do
      step = prepare_step(DataPipe::Step::JsonWriter.new, stream: output)
      check_iterator step.each
    end

    it "writer/csv" do
      step = prepare_step(DataPipe::Step::CsvWriter.new, stream: output)
      check_iterator step.each
    end

    it "schema" do
      step = prepare_step(DataPipe::Step::Schema.new, definition: {
        "a" => DataPipe::Step::SchemaHelper::String.new.prepare,
      })
      check_iterator step.each
    end

    it "loader/csv" do
      step = DataPipe::Step::CsvLoader.new.prepare(OpenStruct.new(stream: "spec/sample/4.csv", headers: true))
      check_iterator step.each
    end

    it "transformation/filter" do
      step = prepare_step(DataPipe::Step::Filter.new){|r| true }
      check_iterator step.each
    end

    it "transformation/process" do
      step = prepare_step(DataPipe::Step::Process.new){|r| r }
      check_iterator step.each
    end

    it "transformation/map" do
      step = prepare_step(DataPipe::Step::Map.new, keys: ["a", "b"])
      check_iterator step.each
    end
  end

  def prepare_step(step, args={}, &blk)
    step
      .prepare(OpenStruct.new(args), &blk)
      .set_input [DataPipe::Record.new("a" => "test a", "b" => "test b")]
  end

  def check_iterator(it)
    has_elements = false

    it.each do |record|
      has_elements = true

      expect(record.data["a"]).to eq "test a"
      expect(record.data["b"]).to eq "test b"
    end

    expect(has_elements).to be true
  end
end
