alias Advent.Ipv7, as: Advent07
[path] = System.argv
input = File.read!(path)

tls_count = input |> String.split |> Enum.count(&Advent07.support_tls?/1)
IO.puts "Part 1: There are #{tls_count} ipv7 addresses that support TLS."

ssl_count = input |> String.split |> Enum.count(&Advent07.support_ssl?/1)
IO.puts "Part 1: There are #{ssl_count} ipv7 addresses that support SSL."
