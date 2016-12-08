#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Control.Arrow
import Data.List
import System.Environment
import Text.Parsec as P
import Text.Parsec.String

readIpList :: FilePath -> IO [([String], [String])]
readIpList fn = either (const $ error "parse failure") id <$> parseFromFile (many1 parseLine) fn

parseLine :: Parsec String () ([String], [String])
parseLine = do
  fs <- parseSupernetSeq
  ps <- many1 ((,) <$> parseHypernetSeq <*> parseSupernetSeq)
  optional newline
  return (fs : map snd ps, map fst ps)

parseHypernetSeq, parseSupernetSeq :: Parsec String () String
parseHypernetSeq = between (char '[') (char ']') (many1 letter)
parseSupernetSeq = many1 letter

supportsSSL :: ([String], [String]) -> Bool
supportsSSL = not . null . uncurry intersect . (nub . concatMap collectABA *** nub . concatMap collectBAB)
  where
    collectABA s@(a:b:c:_) = if a == c && a /= b
                             then (a,b):collectABA (tail s)
                             else collectABA (tail s)
    collectABA _ = []

    collectBAB s@(a:b:c:_) = if a == c && a /= b
                             then (b,a):collectBAB (tail s)
                             else collectBAB (tail s)
    collectBAB _ = []

main :: IO ()
main = do
  ips <- head <$> getArgs >>= readIpList
  print $ length $ filter supportsSSL ips
