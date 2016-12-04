module Day3 where

legal (a, b, c) = a + b > c && a + c > b && b + c > a

parse :: String -> [(Int, Int, Int)]
parse input = map (\line -> let [a,b,c] = words line
                            in (read a, read b, read c))
                  (lines input)

main = do
  answer <- fmap (show . length . filter legal . parse) (readFile "./src/Day3.txt")
  putStrLn $ "Answer = " ++ answer
