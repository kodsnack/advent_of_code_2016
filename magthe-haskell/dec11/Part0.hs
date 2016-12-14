#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import           Control.Monad.State
import           Data.Function
import           Data.List
import qualified Data.Sequence as Seq
import qualified Data.Set as Set

exStart :: RtgState
exStart = (0, Seq.fromList [ [M Hydrogen, M Lithium]
                           , [G Hydrogen]
                           , [G Lithium]
                           , []
                           ])

type RtgState = (Int, Seq.Seq [Comp])

data Comp = G Isotope | M Isotope
  deriving (Eq, Ord, Show)

data Isotope = Curium | Dilithium | Elerium | Hydrogen | Lithium | Plutonium | Ruthenium | Strontium | Thulium
  deriving (Eq, Ord, Show)

data Move = Up [Comp] | Down [Comp]
  deriving (Eq, Show)

possibleMoves (liftFloor, components) =
  let comps = components `Seq.index` liftFloor
      combos = onesAndTwos comps
      ups = map Up combos
      downs = map Down combos

      onesAndTwos l = map (:[]) l ++ twos l
        where
          twos [] = []
          twos (i:is) = map ((i:) . (:[])) is ++ twos is

  in case liftFloor of
    0 -> ups
    1 -> ups ++ downs
    2 -> ups ++ downs
    3 -> downs


applyMove :: RtgState -> Move -> RtgState
applyMove (liftFloor, components) move =
  let floorCs = components `Seq.index` liftFloor
      (newLF, movingCs) = case move of
                                   (Up cs) -> (liftFloor + 1, cs)
                                   (Down cs) -> (liftFloor - 1, cs)
      adjustMany = foldl (\ s (idx, f) -> Seq.adjust f idx s)
  in (newLF, adjustMany components [(liftFloor, sort . (\\ movingCs)), (newLF, sort . (`union` movingCs))])

notFried :: RtgState -> Bool
notFried (_, components) = all notFloorFried components

notFloorFried :: [Comp] -> Bool
notFloorFried cs = null ms || null gs || all matched ms
  where
    (gs, ms) = partition isG cs
    isG (G _) = True
    isG (M _) = False
    matched (M i) = G i `elem` gs

step :: RtgState -> [RtgState]
step s = filter notFried $ map (applyMove s) (possibleMoves s)

isDone :: RtgState -> Bool
isDone (_, floors) = all null (Seq.take 3 floors)

weight :: RtgState -> Int
weight (_, floors) = Seq.foldlWithIndex (\ sum idx floor -> sum + (idx + 1) * length floor)  0 floors

-- The most simplistic of solutions. It's still performant enough to use on the
-- example from the instructions.
{-
solve :: Int -> [RtgState] -> Int
solve round states =
  let done = any isDone states
      nextRoundStates = concatMap step states
  in if done
     then round
     else solve (round + 1) nextRoundStates

main :: IO ()
main = print $ solve 0 [exStart]
-}

-- This is a slightly more performant solution.
{-
solve :: Int -> [RtgState] -> State (Set.Set RtgState) Int
solve round states = do
  seenStates <- get
  let done = any isDone states
      nextRoundStates = Set.fromList (concatMap step states) `Set.difference` seenStates
  if done
    then return round
    else do
    modify (`Set.union` nextRoundStates)
    solve (round + 1) (Set.toList nextRoundStates)

main :: IO ()
main = print $ evalState (solve 0 [exStart]) (Set.fromList [exStart])
-}

solve :: Int -> Int -> [RtgState] -> State (Set.Set RtgState) Int
solve cutOff round states = do
  seenStates <- get
  let done = any isDone states
      nextRoundStates0 = Set.fromList (concatMap step states) `Set.difference` seenStates
      nextRoundStates = take cutOff $ sortBy (flip compare `on` weight) (Set.toList nextRoundStates0)
  if done
    then return round
    else do
    modify (`Set.union` Set.fromList nextRoundStates)
    solve cutOff (round + 1) nextRoundStates

main:: IO ()
main = print $ evalState (solve 10 0 [exStart]) (Set.fromList [exStart])
