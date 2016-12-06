module Day5 where

import Data.Hash.MD5
import qualified Data.Text as T

input = "uqwqemis"

fiveZeroes = T.pack "00000"

startsWithZeroes t = T.take 5 t == fiveZeroes

answer = map (\x -> (T.unpack x) !! 5) $ take 8 $ filter startsWithZeroes $ map (\i -> T.pack $ md5s (Str $ input ++ show i)) [0..]

-- 1a3099aa
