import Data.List
import Data.Ord
import Data.Hash.MD5

type State = (Integer, Integer, String)

solve :: String -> (String, Int)
solve pw = ((minimumBy (comparing length) gPs), (maximum (map length gPs)))
    where gPs = solve' pw [(0,0,"")] []

solve' :: String -> [State] -> [String] -> [String]
solve' _ [] [] = ["IMPOSSIBLE TO GET TO GOAL (disregard answer to Part two)"]
solve' _ [] goalPaths = goalPaths
solve' pw ((x,y,path):states) goalPaths
    | (x == 3) && (y == 3) = solve' pw states (goalPaths ++ [path])
    | otherwise = solve' pw (states ++ (nStates pw x y path)) goalPaths

nStates :: String -> Integer -> Integer -> String -> [State]
nStates pw x y path = filter (isOpen pw) [(x, (y - 1), (path ++ "U"))
                                        , (x, (y + 1), (path ++ "D"))
                                        , ((x - 1), y, (path ++ "L"))
                                        , ((x + 1), y, (path ++ "R"))]

isOpen :: String -> State -> Bool
isOpen pw (x,y,path)
    | (x < 0) || (x > 3) || (y < 0) || (y > 3) = False
    | (last path) == 'U' = elem (h!!0) "bcdef"
    | (last path) == 'D' = elem (h!!1) "bcdef"
    | (last path) == 'L' = elem (h!!2) "bcdef"
    | (last path) == 'R' = elem (h!!3) "bcdef"
    where h = getHash (pw ++ (take ((length path) - 1) path))

getHash :: String -> String
getHash s = take 4 (md5s (Str s))

main = do
    input <- readFile "d17_input.txt"
    let shortLong = solve input
    let answer1 = fst shortLong
    let answer2 = snd shortLong
    putStrLn $ "Part one: " ++ answer1
    putStrLn $ "Part two: " ++ show answer2