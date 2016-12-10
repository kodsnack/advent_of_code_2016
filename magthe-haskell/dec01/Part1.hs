#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import System.Environment
import Data.List

data Step = R Int | L Int
  deriving (Eq, Show)

data Direction = North | East | South | West
  deriving (Eq, Show)

type Pos = (Int, Int, Direction)

startPos :: Pos
startPos = (0, 0, North)

turn d (R _) =
  case d of
    North -> East
    East -> South
    South -> West
    West -> North
turn d (L _) =
  case d of
    North -> West
    West -> South
    South -> East
    East -> North

blocks (R i) = i
blocks (L i) = i

step :: Pos -> Step -> Pos
step (x, y, d) s =
  let nd = turn d s
      b = blocks s
  in case nd of
       North -> (x, y - b, nd)
       East -> (x + b, y, nd)
       South -> (x, y + b, nd)
       West -> (x - b, y, nd)

distance :: Pos -> Int
distance (x, y, _) = (abs x) + (abs y)

readInstructions :: FilePath -> IO [Step]
readInstructions fn =
  let parseOne (d:b) = case d of
                         'R' -> R (read (delete ',' b))
                         'L' -> L (read (delete ',' b))
                         otherwise -> error "Badly formed instruction"
  in do
    i <- fmap words $ readFile fn
    return $ fmap parseOne i

main :: IO ()
main = do
  instructions <- fmap head getArgs >>= readInstructions
  print $ distance $ foldl step startPos instructions
