#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Data.List
import Text.Parsec as P
import Text.Parsec.String
import Control.Applicative
import System.Environment
import Control.Arrow

readRoomList :: FilePath -> IO [(String, Int, String)]
readRoomList fn = fmap (either (const $ error "parse failure") id) $ parseFromFile (many1 parseLine) fn
  where
    parseLine = (,,) <$>
      parseRoomName <*>
      parseNumber <*>
      parseChecksum <* P.optional newline
    parseRoomName = fmap concat $ sepEndBy1 (many1 letter) (char '-')
    parseNumber = fmap read $ many1 digit
    parseChecksum = between (char '[') (char ']') (many1 letter)

sumOfSectorIDsOfRealRooms = sum. map (\ (_, id, _) -> id) . filter checkChecksum
  where
    checkChecksum (room, _, cs) = cs == calcChecksum room
    calcChecksum = take 5 . map snd . sortBy occAlph . map (length &&& head) . group . sort
    occAlph (n0, c0) (n1, c1)
      | n1 < n0 = LT
      | n1 > n0 = GT
      | c0 < c1 = LT
      | c0 > c1 = GT
      | otherwise = EQ

main :: IO ()
main = do
  rooms <- fmap head getArgs >>= readRoomList
  print $ sumOfSectorIDsOfRealRooms rooms
