import Data.List.Split

parseInstrs :: String -> [String]
parseInstrs s = splitOn "\n" s

move1 :: (Integer, Integer) -> String -> (Integer, Integer)
move1 (x,y) dir = case dir of
    "U" -> case y of
        0 -> (x,y)
        _ -> (x,(y-1))
    "D" -> case y of
        2 -> (x,y)
        _ -> (x,(y+1))
    "L" -> case x of
        0 -> (x,y)
        _ -> ((x-1),y)
    "R" -> case x of
        2 -> (x,y)
        _ -> ((x+1),y)

moves1 :: (Integer, Integer) -> String -> (Integer, Integer)
moves1 start [] = start
moves1 start (dir:dirs) = moves1 (move1 start [dir]) dirs 

solve1 :: [String] -> (Integer, Integer) -> [Integer]
solve1 [] _= []
solve1 (s:ss) start = (positionToInt1 (moves1 start s)) : solve1 ss (moves1 start s)

positionToInt1 :: (Integer, Integer) -> Integer
positionToInt1 (x,y) = (x+1) + y*3

validPositions2 = [(2,0),(1,1),(2,1),(3,1),(0,2),(1,2),(2,2),(3,2),(4,2),(1,3),(2,3),(3,3),(2,4)]

move2 :: (Integer, Integer) -> String -> (Integer, Integer)
move2 (x,y) dir
    | (dir == "U") && (elem (x,(y-1)) validPositions2) = (x,(y-1))
    | (dir == "D") && (elem (x,(y+1)) validPositions2) = (x,(y+1))
    | (dir == "L") && (elem ((x-1),y) validPositions2) = ((x-1),y)
    | (dir == "R") && (elem ((x+1),y) validPositions2) = ((x+1),y)
    | otherwise = (x,y)

moves2 :: (Integer, Integer) -> String -> (Integer, Integer)
moves2 start [] = start
moves2 start (dir:dirs) = moves2 (move2 start [dir]) dirs

solve2 :: [String] -> (Integer, Integer) -> [Char]
solve2 [] _= []
solve2 (s:ss) start = (positionToInt2 (moves2 start s)) : solve2 ss (moves2 start s)

positionToInt2 :: (Integer, Integer) -> Char
positionToInt2 (x,y) = (["00100","02340","56789","0ABC0","00D00"]!!(fromIntegral y))!!(fromIntegral x)

main = do
    input <- readFile "d2_input.txt"
    let answer1 = concat (map show (solve1 (parseInstrs input) (1,1)))
    let answer2 = solve2 (parseInstrs input) (0,2)
    putStrLn $ "Part one: " ++ answer1
    putStrLn $ "Part two: " ++ answer2