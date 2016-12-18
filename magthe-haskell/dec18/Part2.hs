#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Data.List
import Data.Char
import System.Environment

pad ts = '.' : ts ++ "."

triplets [a, b, c] = [(a, b, c)]
triplets ts@(a:b:c:_) = (a, b, c) : triplets (tail ts)
triplets _ = error "no triplet to be had"

genTile ('^', '^', '.') = '^'
genTile ('.', '^', '^') = '^'
genTile ('^', '.', '.') = '^'
genTile ('.', '.', '^') = '^'
genTile _ = '.'

genRow = map genTile . triplets . pad

countSafeTiles n = length . filter (== '.') . concat . take n . iterate genRow

strip = dropWhile isSpace . dropWhileEnd isSpace

main :: IO ()
main = do
  input <- (head <$> getArgs) >>= readFile
  print $ countSafeTiles 400000 (strip input)
