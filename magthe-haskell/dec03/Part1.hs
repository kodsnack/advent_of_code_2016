#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Data.List
import System.Environment

readTriangles :: FilePath -> IO [[Int]]
readTriangles fn = do
  lines <- fmap lines $ readFile fn
  return $ fmap (sort . fmap read . words) lines

possibleTriangle :: [Int] -> Bool
possibleTriangle [a, b, c] = a + b > c

main :: IO ()
main = do
  ts <- fmap head getArgs >>= readTriangles
  print $ length $ filter possibleTriangle ts
