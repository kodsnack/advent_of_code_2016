#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import           Control.Arrow
import           Control.Monad.State as MS
import           Data.Function
import           Data.List
import qualified Data.Matrix as M
import           Data.Maybe
import qualified Data.Set as S
import qualified Data.Vector as V
import           System.Environment
import           Text.Parsec
import           Text.Parsec.String

readInput fn = either (const $ error "parse failure") id <$>
               parseFromFile (count 2 skipLine >> sepEndBy1 parseNode newline) fn
  where
    skipLine = void $ manyTill anyChar newline

    parseNode = Node <$>
      parsePos <* skipMany1 space <*>
      parseSize <* skipMany1 space <*>
      parseSize <* skipMany1 space <*>
      parseSize <* (skipMany1 space >> many1 digit >> char '%')

    parsePos = (,) <$>
      (string "/dev/grid/node-x" *> (read <$> many1 digit)) <*>
      (string "-y" *> (read <$> many1 digit))

    parseSize = (read <$> many1 digit) <* char 'T'

data Node = Node { nodeXY::(Int, Int), nodeSize::Int, nodeUsed::Int, nodeAvail::Int }
  deriving (Eq, Show)

makeMatrix ns = M.transpose $ M.fromList cols rows $ map (toChar smallest size) ns
  where
    toChar s (xs, ys) n@(Node (x, y) _ _ _)
      | x == xs && y == 0 = 'G'
      | nodeEmpty n = '_'
      | viablePair (n, s) = '.'
      | otherwise = '#'

    nodeEmpty = (== 0) . nodeUsed
    viablePair (a, b) = nodeUsed a <= nodeSize b

    smallest = minimumBy (compare `on` nodeSize) ns
    size = maximum $ map nodeXY ns
    (cols, rows) = (succ *** succ) size

mFindIndex p m = ((succ *** succ) . flip quotRem (M.ncols m)) <$> V.findIndex p (M.getMatrixAsVector m)
findHole = fromJust . mFindIndex (== '_')
findGoal = fromJust . mFindIndex (== 'G')

possibles m = map (swapHole m hole) neighbors2
  where
    hole = findHole m
    neighbors = map ($ hole) [second pred, second succ, first pred, first succ]
    neighbors1 = filter (\ (r, c) -> isJust $ M.safeGet r c m) neighbors
    neighbors2 = filter ((/= '#') . (m M.!)) neighbors1

swapHole m' h p = M.setElem c h $ M.setElem '_' p m'
  where
    c = m' M.! p

unseen seen m = not $ hng `S.member` seen
  where
    hng = (findHole &&& findGoal) m

isDone m = 'G' == (m M.! (1, 1))

weight m = (rg + cg) + (abs (rg - rh) + abs (cg - ch))
  where
    (rg, cg) = findGoal m
    (rh, ch) = findHole m

solve :: Int -> Int -> [M.Matrix Char] -> MS.State (S.Set ((Int, Int), (Int, Int))) Int
solve _ _ [] = error "ran out of states, cutOff is probably too low"
solve cutOff r states = do
  seen <- get
  let done = any isDone states
      nextRoundStates = take cutOff $ sortBy (compare `on` weight) $ nub $ filter (unseen seen) $ concatMap possibles states
  if done
    then return r
    else do
    modify (`S.union` (S.fromList $ map (findHole &&& findGoal) nextRoundStates))
    solve cutOff (r + 1) nextRoundStates

main :: IO ()
main = do
  ns <- (head <$> getArgs) >>= readInput
  print $ evalState (solve 10 0 [makeMatrix ns]) S.empty
