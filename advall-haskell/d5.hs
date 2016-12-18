--NOT DONE!!
import Data.Hash.MD5
import Data.List.Split
import Data.List

getKeyChar :: String -> String
getKeyChar s
    | take 5 s == "00000" = [head (drop 5 s)]
    | otherwise = ""

makeKey :: String -> Int -> String
makeKey doorID l = makeKey' getKeyChar doorID 0 "" l

makeKey' :: (String -> String) -> String -> Integer -> String -> Int -> String
makeKey' f doorID i key l
    | (length key) == l = key
    | otherwise = makeKey' f doorID (i+1) 
        (key ++ (getKeyChar (md5s (Str (doorID ++ (show i)))))) l

getKeyCharWithIndex :: String -> String
getKeyCharWithIndex s
    | (take 5 s == "00000") && ((read [head (drop 5 s)]) < 9) = take 2 (drop 5 s)
    | otherwise = ""

makeKey2 :: String -> Int -> [String]
--makeKey2 doorID l = map last (sort (chunksOf 2 (makeKey' getKeyCharWithIndex doorID 0 "" l)))
makeKey2 doorID l = (chunksOf 2 (makeKey' getKeyCharWithIndex doorID 0 "" l))

main = do
    input <- readFile "d5_input.txt"
--    let answer1 = makeKey input 8
 --   putStrLn $ "Part one: " ++ show answer1
    let answer2 = makeKey2 input 16
    putStrLn $ "Part two: " ++ show answer2