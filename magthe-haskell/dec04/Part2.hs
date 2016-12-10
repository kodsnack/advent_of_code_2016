#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Data.List
import Text.Parsec as P
import Text.Parsec.String
import Control.Applicative hiding ( (<|>) )
import System.Environment
import Control.Arrow

readRoomList :: FilePath -> IO [(String, Int, String)]
readRoomList fn = fmap (either (const $ error "parse failure") id) $ parseFromFile (many1 parseLine) fn
  where
    parseLine = (,,) <$>
      parseRoomName <*>
      parseNumber <*>
      parseChecksum <* P.optional newline
    parseRoomName = many1 $ letter <|> (char '-')
    parseNumber = fmap read $ many1 digit
    parseChecksum = between (char '[') (char ']') (many1 letter)

realRooms :: [(String, Int, String)] -> [(String, Int, String)]
realRooms = filter checkChecksum
  where
    checkChecksum (room, _, cs) = cs == calcChecksum (filter (/= '-') room)
    calcChecksum = take 5 . map snd . sortBy occAlph . map (length &&& head) . group . sort
    occAlph (n0, c0) (n1, c1)
      | n1 < n0 = LT
      | n1 > n0 = GT
      | c0 < c1 = LT
      | c0 > c1 = GT
      | otherwise = EQ

decryptRoom (room, n, cs) = (stringRotN n room, n, cs)
  where
    stringRotN n s= map (charRotN n) s

    charRotN _ '-' = ' '
    charRotN n c =
      let chars = take 26 $ drop (n `mod` 26) $ cycle ['a' .. 'z']
      in chars !! (fromEnum c - fromEnum 'a')

main :: IO ()
main = do
  rooms <- fmap head getArgs >>= readRoomList
  let ((r, sid, _):_) = filter (\ (r, _, _) -> r == "northpole object storage ") $ map decryptRoom $ realRooms rooms
  print sid
