import Data.List

mostCommon :: String -> Char
mostCommon s = head (last (sortOn length (group (sort s))))

leastCommon :: String -> Char
leastCommon s = head (head (sortOn length (group (sort s))))

toColumns :: [String] -> [String]
toColumns ([]:_) = []
toColumns ss = [(map head ss)] ++ (toColumns (map tail ss))

solve1 :: [String] -> String
solve1 [] = []
solve1 (s:ss) = [(mostCommon s)] ++ solve1 ss

solve2 :: [String] -> String
solve2 [] = []
solve2 (s:ss) = [(leastCommon s)] ++ solve2 ss

main = do
    input <- readFile "d6_input.txt"
    let answer1 = solve1 (toColumns (lines input))
    let answer2 = solve2 (toColumns (lines input))
    putStrLn $ "Part one: " ++ show answer1
    putStrLn $ "Part two: " ++ show answer2