require "./spec_helper"

describe AoC14 do
  it "recognizes threes" do
    iterator = AoC14::KeyIterator.new("abc", AoC14::MD5Iterator)
    iterator.three?("abcde").should be_nil
    iterator.three?("abbe").should be_nil
    iterator.three?("abbbde").should eq 'b'
  end

  it "recognizes fives" do
    iterator = AoC14::KeyIterator.new("abc", AoC14::MD5Iterator)
    iterator.five?("abcde").should be_nil
    iterator.five?("abbbbe").should be_nil
    iterator.five?("abbbbbde").should eq 'b'
  end

  it "first value has index 39" do
    iterator = AoC14::KeyIterator.new("abc", AoC14::MD5Iterator)
    i, s = iterator.next
    i.should eq 39
    62.times { iterator.next }
    i, s = iterator.next
    i.should eq 22728
  end

  it "can get the value at an arbitrary index" do
    AoC14.new("abc", AoC14::MD5Iterator).at(64).should eq 22728
  end

  it "generates stretched hashes" do
    iterator = AoC14::StretchedMD5Iterator.new("abc")
    iterator.first.last.should match(/^a107/)
  end

  it "generates keys for stretched hashes" do
    iterator = AoC14::KeyIterator.new("abc", AoC14::StretchedMD5Iterator)
    i, s = iterator.next
    i.should eq 10
    62.times { iterator.next }
    i, s = iterator.next
    i.should eq 22551
  end
end
