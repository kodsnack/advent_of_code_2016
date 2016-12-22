#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Control.Monad
import System.Environment
import Text.Parsec
import Text.Parsec.String

readInput fn = either (const $ error "parse failure") id <$>
               parseFromFile (count 2 skipLine >> sepEndBy1 parseNode newline) fn
  where
    skipLine = void $ manyTill anyChar newline

    parseNode = Node <$>
      parsePos <* (skipMany1 space >> parseSize >> skipMany1 space) <*>
      parseSize <* skipMany1 space <*>
      parseSize <* (skipMany1 space >> many1 digit >> char '%')

    parsePos = (,) <$>
      (string "/dev/grid/node-x" *> (read <$> many1 digit)) <*>
      (string "-y" *> (read <$> many1 digit))

    parseSize = (read <$> many1 digit) <* char 'T'

data Node = Node { nodePos::(Int, Int), nodeUsed::Int, nodeAvail::Int }
  deriving (Eq, Show)

nodeEmpty = (== 0) . nodeUsed

viablePair (a, b) = not (nodeEmpty a) && (a /= b) && (nodeUsed a <= nodeAvail b)

main :: IO ()
main = do
  ns <- (head <$> getArgs) >>= readInput
  print $ length [(a, b) | a <- ns, b <- ns, viablePair (a, b)]
