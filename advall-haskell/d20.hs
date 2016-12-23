import Data.List.Split
import Data.List

solve1 :: Integer -> [(Integer, Integer)] -> Integer
solve1 floor ((h,t):xs)
    | floor >= h = solve1 ((max floor t) + 1) xs
    | otherwise = floor

solve2 :: Integer -> Integer -> [(Integer, Integer)] -> Integer
solve2 floor roof [] = roof - floor + 1
solve2 floor roof ((h,t):xs)
    | floor < h = (h - floor) + solve2 h roof ((h,t):xs)
    | (floor >= h) && (floor <= t) = solve2 (t + 1) roof xs
    | otherwise = solve2 floor roof xs

parseInput :: String -> [(Integer, Integer)]
parseInput s = sort (map parseInput' (map (splitOn "-") (lines s)))

parseInput' :: [String] -> (Integer, Integer)
parseInput' [x,y] = (read x, read y)

main = do
    input <- readFile "d20_input.txt"
    let answer1 = solve1 0 (parseInput input)
    putStrLn $ "Part one: " ++ show answer1
    let answer2 = solve2 0 4294967295 (parseInput input)
    putStrLn $ "Part two: " ++ show answer2