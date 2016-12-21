require "./spec_helper"

describe AoC18 do
  it "generates new lines" do
    AoC18.new.generate_line("..^^.".chars).should eq ".^^^^".chars
    AoC18.new.generate_line(".^^^^".chars).should eq "^^..^".chars
  end
end
