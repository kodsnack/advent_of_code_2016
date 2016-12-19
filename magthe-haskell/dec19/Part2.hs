#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Control.Arrow
import Data.List
import Data.Maybe
import System.Environment

-- my input: 3012210

runRound ring = rotateList (len - length keepers) keepers
  where
    len = length ring
    c = if odd len then [False, True, False] else [False, False, True]
    keepers = map snd $ filter fst $ zip (replicate (len `div` 2) True ++ cycle c) ring
    rotateList n l = take (length l) $ drop n $ cycle l

getWinner = find ((== 1) . length) . iterate runRound

main :: IO ()
main = do
  numElfs <- (read . head) <$> getArgs
  print $ head $ fromJust $ getWinner [1 .. numElfs]
