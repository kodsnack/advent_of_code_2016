#! /usr/bin/env stack
{- stack runghc -}

module Main
   where

import Control.Applicative
import Data.Matrix
import System.Environment
import Text.Parsec as P
import Text.Parsec.String

-- The instructions given as input uses zero-based indexing of rows and colums
-- while the Matrix module uses one-based indexing, hence the extra math in the
-- rotation functions.

data Instruction = InsRect Int Int -- cols X rows
                 | InsRotCol Int Int
                 | InsRotRow Int Int
                 deriving (Eq, Show)

readInstructions :: FilePath -> IO [Instruction]
readInstructions fn = (either (const $ error "parse failure") id) <$> parseFromFile (many1 parseInstruction) fn

parseInstruction :: Parsec String () Instruction
parseInstruction = choice [try parseRect, try parseRotCol, try parseRotRow] <* P.optional newline
  where
    parseRect = InsRect <$>
      (string "rect " *> (read <$> many1 digit)) <* char 'x' <*>
      (read <$> many1 digit)

    parseRotCol = InsRotCol <$>
      (string "rotate column x=" *> (read <$> many1 digit)) <* string " by " <*>
      (read <$> many1 digit)

    parseRotRow = InsRotRow <$>
      (string "rotate row y=" *> (read <$> many1 digit)) <* string " by " <*>
      (read <$> many1 digit)

defaultScreen = matrix 6 50 (const ' ')

runInstruction :: Matrix Char -> Instruction -> Matrix Char
runInstruction m (InsRect cols rows) = rect rows cols m
runInstruction m (InsRotCol col steps) = rotateCol col steps m
runInstruction m (InsRotRow row steps) = rotateRow row steps m

rect :: Int -> Int -> Matrix Char -> Matrix Char
rect rows cols mat = foldl (\ n p -> setElem '#' p n) mat [(r, c) | r <- [1 .. rows], c <- [1 .. cols]]

rotateRow :: Int -> Int -> Matrix Char -> Matrix Char
rotateRow row steps mat = mapRow (\ c _ -> mat ! (mRow, mCol (c - 1))) mRow mat
  where
    mRow = row + 1
    mCol c = (c - steps) `mod` (ncols mat) + 1

rotateCol :: Int -> Int -> Matrix Char -> Matrix Char
rotateCol col steps mat = mapCol (\ r _ -> mat ! (mRow (r - 1), mCol)) mCol mat
  where
    mCol = col + 1
    mRow r = (r - steps) `mod` (nrows mat) + 1

main :: IO ()
main = do
  instructions <- (head <$> getArgs) >>= readInstructions
  let s = foldl runInstruction defaultScreen instructions
  mapM_ putStrLn $ toLists s
