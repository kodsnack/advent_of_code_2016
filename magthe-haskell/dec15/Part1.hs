#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Data.List
import System.Environment

readInstructions fn = do
  ls <- lines <$> readFile fn
  return $ map parseInstruction ls

parseInstruction :: String -> (Int, Int)
parseInstruction l = (read (ws !! 11), read (ws !! 3))
  where
    ws = words (delete '.' l)

findTime ds = findIndex (all (== 0)) $ map (map (uncurry calcPos) . uncurry zip) $ zip (tails [1..]) (repeat ds)

calcPos t (p, ps) = (t + p) `mod` ps

main :: IO ()
main = do
  discs <- head <$> getArgs >>= readInstructions
  let (Just t) = findTime discs
  print t
