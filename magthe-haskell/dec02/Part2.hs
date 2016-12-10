#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Control.Arrow
import Data.List
import System.Environment

data Instruction = U | D | L | R
  deriving (Eq, Read, Show)

readInstructions :: FilePath -> IO [[Instruction]]
readInstructions fn = fmap (map parseLine) $ fmap lines $ readFile fn
  where
    parseLine = map (read . (:[]))

-- up - down - right - left
data Key = Nil | Key Char Key Key Key Key

keypadStart =
  let key1 = Key '1' Nil key3 Nil Nil
      key2 = Key '2' Nil key6 key3 Nil
      key3 = Key '3' key1 key7 key4 key2
      key4 = Key '4' Nil key8 Nil key3
      key5 = Key '5' Nil Nil key6 Nil
      key6 = Key '6' key2 keyA key7 key5
      key7 = Key '7' key3 keyB key8 key6
      key8 = Key '8' key4 keyC key9 key7
      key9 = Key '9' Nil Nil Nil key8
      keyA = Key 'A' key6 Nil keyB Nil
      keyB = Key 'B' key7 keyD keyC keyA
      keyC = Key 'C' key8 Nil Nil keyB
      keyD = Key 'D' keyB Nil Nil Nil
  in key5

step :: Key -> Instruction -> Key
step k@(Key _ Nil _ _ _) U = k
step (Key _ nk _ _ _) U = nk
step k@(Key _ _ Nil _ _) D = k
step (Key _ _ nk _ _) D = nk
step k@(Key _ _ _ Nil _) R = k
step (Key _ _ _ nk _) R = nk
step k@(Key _ _ _ _ Nil) L = k
step (Key _ _ _ _ nk) L = nk

keyChar :: Key -> Char
keyChar (Key s _ _ _ _) = s

getCode :: [[Instruction]] -> String
getCode = snd . mapAccumL getDigit keypadStart
  where
    getDigit kp = (id &&& keyChar) . foldl step kp

main :: IO ()
main = fmap head getArgs >>= readInstructions >>= putStrLn . getCode
