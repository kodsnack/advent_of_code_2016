module Day3b where

import Data.List.Split

legal (a, b, c) = a + b > c && a + c > b && b + c > a

parse :: String -> [(Int, Int, Int)]
parse input = concatMap (\[line1, line2, line3] -> let [a,b,c] = words line1
                                                       [d,e,f] = words line2
                                                       [g,h,i] = words line3
                                                   in [(read a, read d, read g)
                                                      ,(read b, read e, read h)
                                                      ,(read c, read f, read i)])
                        (chunksOf 3 (lines input))

main = do
  answer <- fmap (show . length . filter legal . parse) (readFile "./src/Day3.txt")
  putStrLn $ "Answer = " ++ answer

