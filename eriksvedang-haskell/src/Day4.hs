module Day4 where

import Data.MultiSet (fromList, toOccurList)
import Data.List
import Text.Regex

sorter :: (Char, Int) -> (Char, Int) -> Ordering
sorter (charA, freqA) (charB, freqB) =
  if freqA == freqB
  then case compare charA charB of
    EQ -> EQ
    LT -> GT
    GT -> LT
  else compare freqA freqB

freqs :: String -> [(Char, Int)]
freqs = reverse . sortBy sorter . toOccurList . fromList . filter (/= '-')

checksum :: String -> String
checksum = fmap fst . take 5 . freqs

parse line = let r = mkRegex "([a-z-]+)([0-9]+)\\[([a-z]+)\\]"
                 Just [str, num, check] = matchRegex r line
             in if checksum str == check then read num else 0

main = do
  input <- readFile "./src/Day4.txt"
  let answer = (sum . fmap parse . lines) input
  putStrLn ("Answer: " ++ show answer)
