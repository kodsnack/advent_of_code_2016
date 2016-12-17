#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import           Crypto.Hash.MD5
import qualified Data.ByteString.Builder as BSB
import qualified Data.ByteString.Char8 as BSC
import qualified Data.ByteString.Lazy as BSL
import           Data.List
import           Data.Tree
import           System.Environment

data Pos = Wall
         | Vault
         | Room Pos Pos Pos Pos -- up down left right
         deriving (Eq, Show)

startPosition = po11
  where
    po11 = Room Wall po21 Wall po12
    po12 = Room Wall po22 po11 po13
    po13 = Room Wall po23 po12 po14
    po14 = Room Wall po24 po13 Wall

    po21 = Room po11 po31 Wall po22
    po22 = Room po12 po32 po21 po23
    po23 = Room po13 po33 po22 po24
    po24 = Room po14 po34 po23 Wall

    po31 = Room po21 po41 Wall po32
    po32 = Room po22 po42 po31 po33
    po33 = Room po23 po43 po32 po34
    po34 = Room po24 po44 po33 Wall

    po41 = Room po31 Wall Wall po42
    po42 = Room po32 Wall po41 po43
    po43 = Room po33 Wall po42 po44
    po44 = Vault

isWall = (== Wall)
isVault = (== Vault)

step (Room d _ _ _) 'U' = d
step (Room _ d _ _) 'D' = d
step (Room _ _ d _) 'L' = d
step (Room _ _ _ d) 'R' = d
step r _ = r

openDoors _ _ Vault = ""
openDoors passcode path room = map fst $ filter (\ (d, o) -> o && not (isWall $ step room d)) open
  where
    open = zip "UDLR" $ map (`elem` "bcdef") (BSC.unpack md5hash)
    md5hash = BSC.take 4 . md5' $ passcode `BSC.append` path
    md5' = BSL.toStrict . BSB.toLazyByteString . BSB.byteStringHex . hash

possibleMoves passcode v@(path, pos) = (v, cs)
  where
    cs = map (\ d -> (path `BSC.append` BSC.pack [d], step pos d)) $ openDoors passcode path pos

allPaths passcode = concat $ levels $ unfoldTree (possibleMoves passcode) (BSC.empty, startPosition)

main :: IO ()
main = do
  input <- (BSC.pack . head) <$> getArgs
  print $ last $ map (BSC.length . fst) $ filter (isVault . snd) $ allPaths input
