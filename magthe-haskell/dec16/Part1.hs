#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Data.List
import Data.Maybe
import System.Environment

-- my input: 00101000101111010

calcDiskData n input = fromJust $ take n <$> find ((>= n) . length) (iterate extend input)
  where
    extend bs = bs ++ "0" ++ invert (reverse bs)

    invert [] = []
    invert ('0':bs) = '1' : invert bs
    invert ('1':bs) = '0' : invert bs

calcChecksum = fromJust . find (odd . length) . iterate checksum
  where
    checksum [] = []
    checksum [_] = error "checksum of odd length data undefined"
    checksum (a:b:bs)
      | a == b = '1' : checksum bs
      | otherwise = '0' : checksum bs

main :: IO ()
main = do
  input <- head <$> getArgs
  putStrLn $ calcChecksum $ calcDiskData 272 input
