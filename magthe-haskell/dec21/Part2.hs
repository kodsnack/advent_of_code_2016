#! /usr/bin/env stack
{- stack runghc -}

{-# LANGUAGE OverloadedLists #-}

module Main where

import           Control.Arrow
import           Data.List as L
import           Data.Sequence as S
import qualified GHC.Exts as GE
import           System.Environment
import           Text.Parsec
import           Text.Parsec.String

scrambledPwd = fromList "fbgdceah"

readOperations fn = either (const $ error "parse failure") id <$> parseFromFile (many1 parseOperation) fn
  where
    parseOperation = choice (map try [ parseSwapPos, parseSwapLetter, parseRotLeft
                                     , parseRotRight, parseRotLetter, parseReversePos
                                     , parseMovePos]) <* optional newline

    parseSwapPos = SwapPos <$>
      (string "swap position " *> (read <$> many1 digit)) <*>
      (string " with position " *> (read <$> many1 digit))

    parseSwapLetter = SwapLetter <$>
      (string "swap letter " *> anyChar) <*>
      (string " with letter " *> anyChar)

    parseRotLeft = RotLeft <$>
      (string "rotate left " *> (read <$> many1 digit)) <* (string " step" <* optional (char 's'))

    parseRotRight = RotRight <$>
      (string "rotate right " *> (read <$> many1 digit)) <* string " steps"

    parseRotLetter = RotLetter <$>
      (string "rotate based on position of letter " *> anyChar)

    parseReversePos = ReversePos <$>
      (string "reverse positions " *> (read <$> many1 digit)) <*>
      (string " through " *> (read <$> many1 digit))

    parseMovePos = MovePos <$>
      (string "move position " *> (read <$> many1 digit)) <*>
      (string " to position " *> (read <$> many1 digit))

data Operation = SwapPos Int Int
               | SwapLetter Char Char
               | RotLeft Int
               | RotRight Int
               | RotLetter Char
               | ReversePos Int Int
               | MovePos Int Int
               deriving (Eq, Show)

invOp _ (SwapPos x y) = SwapPos y x
invOp _ (SwapLetter a b) = SwapLetter b a
invOp _ (RotLeft n) = RotRight n
invOp _ (RotRight n) = RotLeft n
invOp s (RotLetter a) = RotLeft (lRot !! idx)
  where
    (Just idx) = elemIndexL a s
    lRot = [1, 1, 6, 2, 7, 3, 0, 4]
invOp _ (ReversePos x y) = ReversePos x y
invOp _ (MovePos x y) = MovePos y x

runInvOp s op = runOp s (invOp s op)

runOp s (SwapPos x y) = update x cy $ update y cx s
  where
    cx = s `index` x
    cy = s `index` y

runOp s (SwapLetter a b) = fmap swap s
  where
    swap c
      | a == c = b
      | b == c = a
      | otherwise = c

runOp s (RotRight n) = runOp s (RotLeft (S.length s - n))
runOp s (RotLeft n) = mapWithIndex f s
  where
    f i _ = s `index` ((n + i) `mod` S.length s)

runOp s (RotLetter c) = runOp s (RotRight steps)
  where
    steps = 1 + idx + d
    (Just idx) = elemIndexL c s
    d = if idx >= 4 then 1 else 0

runOp s (ReversePos x y) = pre >< rev >< post
  where
    (pre, rest) = S.splitAt x s
    (f, post) = S.splitAt (y - x + 1) rest
    rev = S.reverse f

runOp s (MovePos x y) = (pre |> a) >< post
  where
    dropped = uncurry (><) $ second (S.drop 1) $ S.splitAt x s
    a = s `index` x
    (pre, post) = S.splitAt y dropped

main :: IO ()
main = do
  ops <- head <$> getArgs >>= readOperations
  putStrLn $ GE.toList $ foldl runInvOp scrambledPwd (L.reverse ops)
