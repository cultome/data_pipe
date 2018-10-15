require "shared_specs"

RSpec.describe DataPipe::Loader do
  subject{ DataPipe::Loader.new }

  it_behaves_like "step protocol"
end
