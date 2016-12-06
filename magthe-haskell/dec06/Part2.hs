#! /usr/bin/env runhaskell

module Main
  where

import Data.Function
import Data.List
import Data.MultiSet (fromList, toOccurList)
import System.Environment

readMessages :: FilePath -> IO [String]
readMessages = fmap (transpose . lines) . readFile

main :: IO ()
main = do
  msgs <- fmap head getArgs >>= readMessages
  let msg = map (fst . head . sortBy (compare `on` snd) . toOccurList . fromList) msgs
  putStrLn msg
