module Day4b where

import Data.MultiSet (fromList, toOccurList)
import Data.List
import Text.Regex
import Data.Char

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

shift :: Int -> Char -> Char
shift n c = if c == '-' then ' ' else chr (97 + ((ord c) - 97 + n) `mod` 26)

parse line = let r = mkRegex "([a-z-]+)([0-9]+)\\[([a-z]+)\\]"
                 Just [str, num, check] = matchRegex r line
                 decrypted = fmap (shift (read num)) str
             in if checksum str == check then Just (decrypted, num) else Nothing

f (Just (s, _)) = case matchRegex (mkRegex "north") s of
                    Just _ -> True
                    Nothing -> False
f Nothing = False

main = do
  input <- readFile "./src/Day4.txt"
  let answer = (filter f . fmap parse . lines) input                 
  putStrLn ("Answer: " ++ show answer)
