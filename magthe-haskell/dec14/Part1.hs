#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import           Crypto.Hash.MD5
import qualified Data.ByteString.Builder as BSB
import qualified Data.ByteString.Char8 as BSC
import qualified Data.ByteString.Lazy as BSL
import           System.Environment

-- my input:  yjdafjpo

santaHash salt = md5' . (salt `BSC.append`) . BSC.pack . show
  where
    md5' = BSL.toStrict. BSB.toLazyByteString . BSB.byteStringHex . hash

hasN n h = any (>= n) $ BSC.length <$> BSC.group h
has3 = hasN 3
has5 = hasN 5

whatN n = fmap BSC.head . filter ((>= n) . BSC.length) . BSC.group
what3 = whatN 3
what5 = whatN 5

has5s fives (idx, h) = c `elem` c5s
  where
    c = head $ what3 h
    h5s = takeWhile ((< idx + 1000) . fst) $ dropWhile ((<= idx) . fst) fives
    c5s = concatMap (what5 . snd) h5s

santaKeys salt = filter (has5s all5s) all3s
  where
    all3s = filter (has3 . snd) (zip [0 ..] (map (santaHash salt) [0 ..]))
    all5s = filter (has5 . snd) (zip [0 ..] (map (santaHash salt) [0 ..]))

main :: IO ()
main = do
  salt <- BSC.pack . head <$> getArgs
  let hashes = take 64 $ santaKeys salt
  print . fst $ hashes !! 63
