using DataPipe::StringUtils

RSpec.describe "Refinements" do
  it "strip spaces in a string" do
    expect(" uno ".strip_spaces).to eq "uno"
  end

  it "titlecase a phrase" do
    expect("uno dos".titlecase).to eq "Uno Dos"
    expect("uno de dos".titlecase).to eq "Uno de Dos"
    expect("de dos uno".titlecase).to eq "De Dos Uno"
  end

  it "is available inside pipeline" do
      pipe = DataPipe.create do
        load_from_csv file: "spec/sample/1.csv", headers: true

        map do |record|
          (" uno ".strip_spaces.titlecase)
        end
      end

      expect{ pipe.process! }.not_to raise_error
  end
end

