#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Control.Arrow
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

supportsTLS :: ([String], [String]) -> Bool
supportsTLS = uncurry (&&) . (any isABBA *** all (not . isABBA))
  where
    isABBA l@(a:b:c:d:_) = (a == d && b == c && a /= b) || isABBA (tail l)
    isABBA _ = False

main :: IO ()
main = do
  ips <- head <$> getArgs >>= readIpList
  print $ length $ filter supportsTLS ips
