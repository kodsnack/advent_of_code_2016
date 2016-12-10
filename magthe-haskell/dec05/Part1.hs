#! /usr/bin/env stack
{- stack runghc -}

-- my input: ffykfhsq

module Main
  where

import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy.Char8 as BSC
import           Data.Digest.Pure.MD5
import           Data.Word
import           Numeric
import           System.Environment

main :: IO ()
main = do
  doorId <- fmap head getArgs
  let pw = concatMap getPwChar $ take 8 $ filter isGoodHash $ map bunnyHash $ plainText doorId
  putStrLn pw

plainText id = map ((++) id . show) [0 ..]

bunnyHash :: String -> [Word8]
bunnyHash = BS.unpack . md5DigestBytes . md5 . BSC.pack

isGoodHash :: [Word8] -> Bool
isGoodHash (0:0:c:_) = c < 16
isGoodHash _ = False

getPwChar :: [Word8] -> String
getPwChar (_:_:c:_) = showHex c ""
