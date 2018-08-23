using DataPipe::StringUtils

RSpec.describe "Refinements" do
  it "strip spaces in a string" do
    expect(" uno ".strip).to eq "uno"
  end

  it "titlecase a phrase" do
    expect("uno dos".titlecase).to eq "Uno Dos"
    expect("uno de dos".titlecase).to eq "Uno de Dos"
    expect("de dos uno".titlecase).to eq "De Dos Uno"
  end
end

