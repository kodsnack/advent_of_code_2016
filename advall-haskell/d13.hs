import Numeric (showIntAtBase)
import Data.Char
import Data.Set (Set, member, union, fromList, size)

isOpen :: (Integer, (Integer, Integer)) -> Integer -> Bool
isOpen (_,(x,y)) luckyNumber = ((length ((filter (== '1')(showIntAtBase 2 
    intToDigit (x*x + 3*x + 2*x*y + y + y*y + luckyNumber) "")))) `mod` 2) == 0

myNotMember :: (Integer, (Integer, Integer)) -> Set (Integer, Integer) -> Bool
myNotMember (_,pos) s = not (member pos s)

hasNeg :: (Integer, (Integer, Integer)) -> Bool
hasNeg (_,(x,y)) = (x >= 0) && (y >= 0)

nextStates :: Integer -> (Integer, (Integer, Integer)) -> Set (Integer, Integer) 
    -> ([(Integer, (Integer, Integer))], Set (Integer, Integer))
nextStates luckyN state visited = ((nextStates' luckyN state visited)
    , union visited (fromList (map snd (nextStates' luckyN state visited))))

nextStates' :: Integer -> (Integer, (Integer, Integer)) 
    -> Set (Integer, Integer) -> [(Integer, (Integer, Integer))]
nextStates' luckyN state visited = filter (`myNotMember` visited) 
    (filter (`isOpen` luckyN) (nextStates'' state))

nextStates'' :: (Integer, (Integer, Integer)) -> [(Integer, (Integer, Integer))]
nextStates'' (move, (x,y)) = filter (hasNeg) [((move+1),((x+1),y))
    , ((move+1),(x,(y-1))), ((move+1),((x-1),y)), ((move+1),(x,(y+1)))]

solve :: (Integer, Integer) -> Integer -> [(Integer, (Integer, Integer))] 
    -> Set (Integer, Integer) -> Integer
solve _ _ [] _ = -1
solve goal luckyN ((move, pos):states) visited
    | pos == goal = move
    | otherwise = solve goal luckyN (states ++ 
        (fst (nextStates luckyN (move, pos) visited))) 
        (snd (nextStates luckyN (move, pos) visited))

solve2 :: Integer -> [(Integer, (Integer, Integer))] -> Set (Integer, Integer) 
    -> Int
solve2 _ [] _ = -1
solve2 luckyN ((move, pos):states) visited
    | move == 50 = size visited
    | otherwise = solve2 luckyN 
        (states ++ (fst (nextStates luckyN (move, pos) visited))) 
        (snd (nextStates luckyN (move, pos) visited))

main = do
    input <- readFile "d13_input.txt"
    let luckyNumber = read input :: Integer
    let answer1 = solve (31,39) luckyNumber [(0, (1, 1))] (fromList [(1, 1)])
    let answer2 = solve2 1364 [(0, (1, 1))] (fromList [(1, 1)])
    putStrLn $ "Part one: " ++ show answer1
    putStrLn $ "Part one: " ++ show answer2

