#! /usr/bin/env stack
{- stack runghc -}

-- my input: ffykfhsq

module Main
  where

import           Data.Bits
import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy as BSL
import qualified Data.ByteString.Lazy.Char8 as BSC
import           Data.Digest.Pure.MD5
import           Data.Function
import           Data.List
import           Data.Word
import           Numeric
import           System.Environment

main :: IO ()
main = do
  doorId <- fmap head getArgs
  let pw = concatMap snd $ sort $ take 8 $ nubBy ((==) `on` fst) $ map getPwPosNChar $ filter isGoodHash $ map bunnyHash $ plainText doorId
  putStrLn pw

plainText id = map ((++) id . show) [0 ..]

bunnyHash :: String -> [Word8]
bunnyHash = BS.unpack . md5DigestBytes . md5 . BSC.pack

isGoodHash :: [Word8] -> Bool
isGoodHash (0:0:p:c_:_) = p < 8 && c < 16
  where
    c = shiftR c_ 4 .&. 0xf
isGoodHash _ = False

getPwPosNChar :: [Word8] -> (Word8, String)
getPwPosNChar (_:_:p:c_:_) = (p, showHex c "")
  where
    c = shiftR c_ 4 .&. 0xf
