require "ostruct"

RSpec.describe DataPipe::Schema do
  let(:output){ StringIO.new }

  context "iterates using a block" do
    it "writer/json" do
      step = prepare_step(JSONWriter.new(output))
      check_iterator step
    end

    it "writer/csv" do
      step = prepare_step(CSVWriter.new(output))
      check_iterator step
    end

    it "schema" do
      step = prepare_step(Schema.new({
        "a" => StringFieldSchema.new,
      }))
      check_iterator step
    end

    it "loader/csv" do
      step = CSVLoader.new("spec/sample/4.csv", OpenStruct.new(headers: true))
      check_iterator step
    end

    it "transformation/filter" do
      step = prepare_step(RecordFilter.new{|r| true })
      check_iterator step
    end

    it "transformation/process" do
      step = prepare_step(RecordProcess.new{|r| r })
      check_iterator step
    end

    it "transformation/map" do
      step = prepare_step(RecordMap.new(["a", "b"]))
      check_iterator step
    end
  end

  context "returns an iterator" do
    it "writer/json" do
      step = prepare_step(JSONWriter.new(output))
      check_iterator step.each
    end

    it "writer/csv" do
      step = prepare_step(CSVWriter.new(output))
      check_iterator step.each
    end

    it "schema" do
      step = prepare_step(Schema.new({
        "a" => StringFieldSchema.new,
      }))
      check_iterator step.each
    end

    it "loader/csv" do
      step = CSVLoader.new("spec/sample/4.csv", OpenStruct.new(headers: true))
      check_iterator step.each
    end

    it "transformation/filter" do
      step = prepare_step(RecordFilter.new{|r| true })
      check_iterator step.each
    end

    it "transformation/process" do
      step = prepare_step(RecordProcess.new{|r| r })
      check_iterator step.each
    end

    it "transformation/map" do
      step = prepare_step(RecordMap.new(["a", "b"]))
      check_iterator step.each
    end
  end

  def prepare_step(step)
    step.set_input [Record.new({"a" => "test a", "b" => "test b"})]
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
