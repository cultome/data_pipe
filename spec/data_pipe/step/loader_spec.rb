require "shared_specs"

RSpec.describe DataPipe::Step::Loader do
  context "csv" do
    subject{ DataPipe::Step::Loader::Csv.new }
    it_behaves_like "step protocol", :load_from_csv

    it "raise exception when no more elements to process" do
      subject.on_init path: "spec/data/empty.csv"

      expect{subject.next}.to raise_exception DataPipe::NoMoreElements
    end
  end
end
