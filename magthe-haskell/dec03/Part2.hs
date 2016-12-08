#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Data.List
import System.Environment

readTriangles :: FilePath -> IO [[Int]]
readTriangles fn = do
  lines <- fmap lines $ readFile fn
  return $ map sort $ concat $ map transpose $ unfoldr take3 $ fmap (fmap read . words) lines

take3 (a:b:c:r) = Just ([a, b, c], r)
take3 _ = Nothing

possibleTriangle :: [Int] -> Bool
possibleTriangle [a, b, c] = a + b > c

main :: IO ()
main = do
  ts <- fmap head getArgs >>= readTriangles
  print $ length $ filter possibleTriangle ts
