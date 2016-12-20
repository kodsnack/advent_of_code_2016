#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import System.Environment
import Data.List

readPairs :: String -> IO [(Int, Int)]
readPairs fn = do
  l <- lines <$> readFile fn
  return $ map parsePair l

parsePair l = (read b, read e)
  where
    (b, '-':e) = break (== '-') l

mergeRanges [] = []
mergeRanges [r] = [r]
mergeRanges ((b0, e0):(b1, e1):rs)
  | e0 >= e1 = mergeRanges ((b0, e0):rs)
  | e0 + 1 >= b1 = mergeRanges ((b0, e1):rs)
  | otherwise = (b0, e0):mergeRanges ((b1, e1):rs)

pad = ((-2, -1):)

main :: IO ()
main = do
  ps <- head <$> getArgs >>= readPairs
  print $ (succ . snd . head . mergeRanges . pad . sort) ps
