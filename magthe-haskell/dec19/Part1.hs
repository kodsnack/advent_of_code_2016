#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Control.Arrow
import Data.List
import Data.Maybe
import System.Environment

-- my input: 3012210

runRound (yn, ring) = (drop (length ring) yn, keepers ring)
  where
    keepers = map snd . filter fst . zip yn

getWinner = find ((== 1) . length) . map snd . iterate runRound . (,) (cycle [True, False])

main :: IO ()
main = do
  numElfs <- (read . head) <$> getArgs
  print $ head $ fromJust $ getWinner [1 .. numElfs]
