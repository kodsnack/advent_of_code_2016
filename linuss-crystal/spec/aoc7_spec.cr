require "./spec_helper"

describe AoC7 do
  it "passes the tls examples" do
    AoC7.new("abba[mnop]qrst").supports_tls?.should be_true
    AoC7.new("abcd[bddb]xyyx").supports_tls?.should be_false
    AoC7.new("aaaa[qwer]tyui").supports_tls?.should be_false
    AoC7.new("ioxxoj[asdfgh]zxcvbn").supports_tls?.should be_true
  end

  it "passes the ssl examples" do
    AoC7.new("aba[bab]xyz").supports_ssl?.should be_true
    AoC7.new("xyx[xyx]xyx").supports_ssl?.should be_false
    AoC7.new("aaa[kek]eke").supports_ssl?.should be_true
    AoC7.new("zazbz[bzb]cdb").supports_ssl?.should be_true
  end
end
