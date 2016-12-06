module Day6b where

import Data.List
import Data.MultiSet (fromList, toOccurList)

commonest :: String -> Char
commonest = fst . head . sortOn snd . toOccurList . fromList

decrypt :: String -> String
decrypt = map commonest . transpose . lines

main = do
  answer <- fmap decrypt (readFile "./src/Day6.txt")
  putStrLn answer
