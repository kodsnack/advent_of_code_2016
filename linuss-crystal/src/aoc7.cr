require "string_scanner"

class AoC7
  def self.count_tls(fname)
    ips = File.read(fname).lines.map { |l| new l }
    ips.select(&.supports_tls?).size
  end

  def self.count_ssl(fname)
    ips = File.read(fname).lines.map { |l| new l }
    ips.select(&.supports_ssl?).size
  end

  alias Aba = NamedTuple(aba: String, inverted: String)

  property input : String
  property supernets : Array(String)
  property hypernets : Array(String)

  def initialize(@input)
    @supernets, @hypernets = partition
  end

  def supports_tls?
    supernets.any? { |s| abba?(s) } && hypernets.none? { |s| abba?(s) }
  end

  def supports_ssl?
    super_abas = supernets.flat_map { |s| abas(s) }.map { |a| a[:aba] }
    hyper_babs = hypernets.flat_map { |s| abas(s) }.map { |a| a[:inverted] }
    (super_abas & hyper_babs).any?
  end

  def abas(string)
    abas = [] of Aba
    x1 = x2 = '\0'
    string.chars.each do |c|
      if x1 == c && x2 != c
        abas << {aba: {x1, x2, x1}.join, inverted: {x2, x1, x2}.join}
      end
      x1, x2 = x2, c
    end
    abas
  end

  def abba?(string)
    x1 = x2 = x3 = '\0'
    string.chars.each do |c|
      if x1 == c && x2 == x3 && x2 != c
        return true
      else
        x1, x2, x3 = x2, x3, c
      end
    end
    false
  end

  def partition
    supernets = [] of String
    hypernets = [] of String
    s = StringScanner.new(input)
    until s.eos?
      supernets << (s.scan(/[^\[]*/) || "")
      next if s.eos?
      hypernets << (s.scan(/[^\]]*/) || "")
    end
    {supernets, hypernets}
  end
end
