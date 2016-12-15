import Data.List.Split
import Data.List

hasABBA :: String -> Bool
hasABBA s
    | (length s) < 4 = False
hasABBA (s:t:u:v:xs)
    | (s == v) && (t == u) && (s /= t) = True
    | otherwise = hasABBA (t:u:v:xs)

lstHasABBA :: [String] -> Bool
lstHasABBA [] = False
lstHasABBA (x:[]) = hasABBA x
lstHasABBA (x:y:xs) = (hasABBA x) || (lstHasABBA xs)

isTLS :: [String] -> Bool
isTLS s = (lstHasABBA s) && (not (lstHasABBA (tail s)))

splitInputLine :: String -> [String]
splitInputLine s = splitWhen isSqrBracket s

isSqrBracket :: Char -> Bool
isSqrBracket c = (c == '[') || (c == ']') 

solve1 :: [String] -> Int
solve1 xs = length (filter isTLS (map splitInputLine xs))

getABAs :: String -> [String]
getABAs s
    | (length s) < 3 = []
getABAs (x:y:z:xs)
    | (x == z) && (x /= y) = [[x] ++ [y] ++ [z]] ++ getABAs (y:z:xs)
    | otherwise = getABAs (y:z:xs)

lstGetABAs :: [String] -> [String]
lstGetABAs [] = []
lstGetABAs (x:[]) = getABAs x
lstGetABAs (x:y:xs) = (getABAs x) ++ (lstGetABAs xs)

lstGetBABs  :: [String] -> [String]
lstGetBABs (x:xs) = map makeBAB (lstGetABAs xs)

makeBAB :: String -> String
makeBAB (a:b:aa) = [b, a, b]

isSSL :: [String] -> Bool
isSSL s = (length ((lstGetABAs s) `intersect` (lstGetBABs s))) > 0

solve2 :: [String] -> Int
solve2 xs = length (filter isSSL (map splitInputLine xs))


main = do
    input <- readFile "d7_input.txt"
    let answer1 = solve1 (lines input)
    let answer2 = solve2 (lines input)
    putStrLn $ "Part one: " ++ show answer1
    putStrLn $ "Part two: " ++ show answer2