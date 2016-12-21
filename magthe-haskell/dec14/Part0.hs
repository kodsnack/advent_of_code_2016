#! /usr/bin/env stack
{- stack runghc -}

-- This solution is usable for the first part, but is too slow for the second
-- part.

module Main
  where

import Data.Digest.Pure.MD5
import qualified Data.ByteString.Lazy.Char8 as BSC
import qualified Data.ByteString.Builder as BSB
import System.Environment

-- my input:  yjdafjpo

santaHash salt = md5' . (salt `BSC.append`) . BSC.pack . show
  where
    md5' = BSB.toLazyByteString . BSB.byteStringHex . md5DigestBytes . md5

hasN n h = any (>= n) $ BSC.length <$> BSC.group h
has3 = hasN 3
has5 = hasN 5

whatN n = fmap BSC.head . filter ((>= n) . BSC.length) . BSC.group
what3 = whatN 3
what5 = whatN 5

isSantaKey salt (idx, h) = c `elem` c5s
  where
    c = head $ what3 h
    h5s = filter has5 (map (santaHash salt) [idx + 1 .. idx + 1000])
    c5s = concatMap what5 h5s

main :: IO ()
main = do
  salt <- BSC.pack . head <$> getArgs
  let hashes = take 64 $ filter (isSantaKey salt) $ filter (has3 . snd) (zip [0 ..] (map (santaHash salt) [0 ..]))
  print . fst $ hashes !! 63
