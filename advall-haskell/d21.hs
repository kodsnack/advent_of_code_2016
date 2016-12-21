import Data.List

parseInput :: String -> [(String, String, String)]
parseInput s = map parseInput' (map words (lines s))

parseInput' :: [String] -> (String, String, String)
parseInput' ("swap":"position":xs) = ("swap", head xs, last xs)
parseInput' ("swap":"letter":xs) = ("swapLet", head xs, last xs)
parseInput' ("rotate":"based":xs) = ("rotatePos", last xs, "")
parseInput' ("rotate":dir:xs) = ("rotate", dir, head xs)
parseInput' ("reverse":_:xs) = ("reverse", head xs, last xs)
parseInput' ("move":_:xs) = ("move", head xs, last xs)

scramble :: String -> [(String, String, String)] -> String
scramble s [] = s
scramble s ((i,p1,p2):is)
    | i == "swap" = scramble (swap s pi1 pi2) is
    | i == "swapLet" = scramble (swap s (head (findIndices (==(head p1)) s)) (head (findIndices (==(head p2)) s))) is
    | i == "rotatePos" = scramble (rotateB s (head p1)) is
    | i == "rotate" = scramble (rotate s p1 pi2) is
    | i == "reverse" = scramble (revT s pi1 pi2) is
    | i == "move" = scramble (mv s pi1 pi2) is
{-    | i == "swap" = scramble (swap s pi1 pi2) is
    | i == "swapLet" = scramble s is
    | i == "rotatePos" = scramble (rotateB s (head p1)) is
    | i == "rotate" = scramble (rotate s p1 pi2) is
    | i == "reverse" = scramble (revT s pi1 pi2) is
    | i == "move" = scramble (mv s pi1 pi2) is-}
    where
        pi1 = read p1 :: Int
        pi2 = read p2 :: Int

swap :: String -> Int -> Int -> String
swap s x y
    | x == y = s
    | x > y = swap s y x
    | otherwise = (take x s) ++ [s!!y] ++ (drop (x+1) (take y s)) ++ [s!!x] ++ (drop (y+1) s)

rotate :: String -> String -> Int -> String
rotate s dir x
    | x == 0 = s
    | dir == "right" = rotate ([last s] ++ (init s)) dir (x-1)
    | dir == "left" = rotate ((tail s) ++ [head s]) dir (x-1)

rotateB :: String -> Char -> String
rotateB s x 
    | (head (findIndices (==x) s)) > 3 = rotate s "right" (2 + (head (findIndices (==x) s)))
    | otherwise = rotate s "right" (1 + (head (findIndices (==x) s)))

revT :: String -> Int -> Int -> String
revT s x y = (take x s) ++ (reverse (drop x (take (y+1) s))) ++ (drop (y+1) s)

mv :: String -> Int -> Int -> String
mv s x y
    | x <= y = (take x s) ++ (drop (x+1) (take (y+1) s)) ++ [s!!x] ++ (drop (y+1) s)
    | x > y = (take y s) ++ [s!!x] ++ (drop (y) (take x s)) ++ (drop (x+1) s)

unscramble :: String -> [(String, String, String)] -> [String] -> String
unscramble scrambled is (c:cs)
    | (scramble c is) == scrambled = c
    | otherwise = unscramble scrambled is cs

main = do
    input <- readFile "d21_input.txt"
    let answer1 = scramble "abcdefgh" (parseInput input)
    putStrLn $ "Part one: " ++ answer1
    let answer2 = unscramble "fbgdceah" (parseInput input) (permutations "fbgdceah")
    putStrLn $ "Part two: " ++ answer2