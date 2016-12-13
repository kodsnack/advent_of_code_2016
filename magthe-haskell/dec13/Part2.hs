#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Data.Bits
import Control.Monad.State
import qualified Data.Set as Set
import System.Environment

neighbors :: (Int, Int) -> [(Int, Int)]
neighbors (0, 0) = [(1, 0), (0, 1)]
neighbors (0, y) = [(0, y - 1), (1, y), (0, y + 1)]
neighbors (x, 0) = [(x + 1, 0), (x, 1), (x - 1, 0)]
neighbors (x, y) = [(x, y - 1), (x + 1, y), (x, y + 1), (x - 1, y)]

isOpen n (x, y) =
  let a = x * x + 3 * x + 2 * x * y + y + y * y
      b = n + a
      c = popCount b
  in even c

shortestRoute n start dest = go 0 [start]
  where
    go :: Int -> [(Int, Int)] -> State (Set.Set (Int, Int)) Int
    go _ [] = error "unreachable destination"
    go d xs
      | d == 50 = return d
      | otherwise = do
          seen <- get
          let cs = filter (isOpen n) $ concatMap neighbors xs
              unseen = Set.fromList cs `Set.difference` seen
          modify (`Set.union` unseen)
          go (d + 1) (Set.toList unseen)

main :: IO ()
main = do
  favNum <- read <$> (head <$> getArgs)
  print $ length $ execState (shortestRoute favNum (1, 1) (31, 39)) Set.empty
