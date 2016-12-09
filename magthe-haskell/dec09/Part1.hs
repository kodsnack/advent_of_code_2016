#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Text.Parsec
import Text.Parsec.String
import Control.Applicative
import Data.List
import System.Environment

data Seq = Unc String | Com Int String
  deriving (Eq, Show)

parseInput :: String -> [Seq]
parseInput s = (either (const $ error "parseFailure") id) $ runParser parseSeq () "sequence parser" s

parseSeq :: Parsec String () [Seq]
parseSeq = many1 $ choice [try parseCompressed, try parseUncompressed]
  where
    parseUncompressed = Unc <$> many1 upper

    parseCompressed = do
      (c, r) <- between (char '(') (char ')') $ (,) <$>
                (read <$> many1 digit) <* char 'x' <*>
                (read <$> many1 digit)
      s <- count c anyChar
      return $ Com r s

seqs2String :: [Seq] -> String
seqs2String = concatMap f
  where
    f (Unc s) = s
    f (Com r s) = concat $ replicate r s

main :: IO ()
main = (head <$> getArgs) >>=
       (fmap (length . seqs2String . parseInput . filter (/= ' ') . head . lines) . readFile) >>=
       print
