#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import           Control.Arrow
import           Control.Monad.State
import qualified Data.Matrix as M
import qualified Data.Set as S
import qualified Data.Vector as V
import           System.Environment

readMatrix :: FilePath -> IO (M.Matrix Char)
readMatrix fn = (M.fromLists . lines) <$> readFile fn

type Pos = (Int, Int)
findPos :: (a -> Bool) -> M.Matrix a -> [Pos]
findPos p m = V.toList $ ((succ *** succ) . flip quotRem (M.ncols m)) <$> V.findIndices p (M.getMatrixAsVector m)

possibleSteps :: M.Matrix Char -> Pos -> [Pos]
possibleSteps m p = neighbors'
  where
    neighbors = map ($ p) [second pred, second succ, first pred, first succ]
    neighbors' = filter ((/= '#') . (m M.!)) neighbors

step :: M.Matrix Char -> (Pos, [Pos]) -> [(Pos, [Pos])]
step m (pos, toSee) =
  let nToSee = filter (/= pos) toSee
      steps = possibleSteps m pos
  in map (flip (,) nToSee) steps

solve :: M.Matrix Char -> Int -> [(Pos, [Pos])] -> State (S.Set (Pos, [Pos])) Int
solve m r states = do
  seen <- get
  let done = any ((== startPos) . fst) $ filter (null . snd) states
      nextSteps = S.fromList (concatMap (step m) states) `S.difference` seen
      nextSteps' = S.toList nextSteps
      startPos = head $ findPos (== '0') m
  modify (`S.union` nextSteps)
  if done
    then return r
    else solve m (r + 1) nextSteps'

main :: IO ()
main = do
  m <- (head <$> getArgs) >>= readMatrix
  let toSee = findPos (`notElem` "#.") m
      start = head $ findPos (== '0') m
  print $ evalState (solve m 0 [(start, toSee)]) S.empty
