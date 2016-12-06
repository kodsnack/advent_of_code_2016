require "./spec_helper"

describe AoC3 do
  describe "#by_row" do
    it "handles empty lists" do
      AoC3.new.by_row("").count_valid_triangles.should eq 0
    end

    it "handles one entry" do
      AoC3.new.by_row("  1   2   4").count_valid_triangles.should eq 0
      AoC3.new.by_row("  1   2   2").count_valid_triangles.should eq 1
    end

    it "handles multiple entries" do
      string = <<-EOS
      810  679   10
      783  255  616
      545  626  626
      EOS
      AoC3.new.by_row(string).count_valid_triangles.should eq 2
    end
  end

  describe "#by_column" do
    it "handles empty lists" do
      AoC3.new.by_column("").count_valid_triangles.should eq 0
    end

    it "handles set of three triangles" do
      string = <<-EOS
      810  679   10
      783  255  616
      545  626  626
      EOS
      AoC3.new.by_column(string).count_valid_triangles.should eq 2
    end

    it "handles multiple sets" do
      string = <<-EOS
      101 301 501
      102 302 502
      103 303 503
      201 401 601
      202 402 602
      203 403 603
      EOS
      AoC3.new.by_column(string).count_valid_triangles.should eq 6
    end
  end
end
