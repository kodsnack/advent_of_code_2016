import Data.List.Split

turn :: Integer -> Char -> Integer
turn facing turnDir
    | turnDir == 'R' = (facing + 1) `mod` 4
    | turnDir == 'L' = (facing - 1) `mod` 4
    | turnDir == 'S' = facing

travel :: (Integer, Integer) -> Integer -> Integer -> (Integer, Integer)
travel (x,y) facing distance
    | facing == 0 = (x , y + distance)
    | facing == 1 = (x + distance , y)
    | facing == 2 = (x , y - distance)
    | facing == 3 = (x - distance , y)

move :: ((Integer, Integer), Integer) -> (Char, Integer) -> ((Integer, Integer), Integer)
move (position, facing) (turnDir, distance) = (travel position (turn facing turnDir) distance, turn facing turnDir)

moves :: [(Char, Integer)] -> (Integer, Integer)
moves instrs = fst (moves' instrs ((0, 0), 0))

moves' :: [(Char, Integer)] -> ((Integer, Integer), Integer) -> ((Integer, Integer), Integer)
moves' [] state = state
moves' (instr:instrs) state = moves' instrs (move state instr)

movesWithMemory :: [(Char, Integer)] -> (Integer, Integer)
movesWithMemory instrs = fst (movesWithMemory' [] instrs ((0, 0), 0))

movesWithMemory' :: [(Integer, Integer)] -> [(Char, Integer)] -> ((Integer, Integer), Integer) -> ((Integer, Integer), Integer)
movesWithMemory' visited ((turnDir,distance):instrs) state 
    | elem (fst state) visited = state
    | distance < 1 = movesWithMemory' visited instrs state
    | otherwise = movesWithMemory' ((fst state) : visited) (('S', (distance - 1)):instrs) (move state (turnDir, 1))

parseInstrs :: String -> [(Char, Integer)]
parseInstrs s = parseInstrs' (splitOn ", " s)

parseInstrs' :: [String] -> [(Char, Integer)]
parseInstrs' [] = []
parseInstrs' (x:xs) = stringToInstr x : parseInstrs' xs

stringToInstr :: String -> (Char, Integer)
stringToInstr (x:xs) = (x, (read xs :: Integer))

manhattanDistFromOrigo :: (Integer, Integer) -> Integer
manhattanDistFromOrigo (dx, dy) = (abs dx) + (abs dy)

solve1 :: String -> Integer
solve1 instrs = manhattanDistFromOrigo (moves (parseInstrs instrs))

solve2 :: String -> Integer
solve2 instrs = manhattanDistFromOrigo (movesWithMemory (parseInstrs instrs))

main = do
    input <- readFile "d1_input.txt"
    let answer1 = solve1 input
    let answer2 = solve2 input
    putStrLn $ "Part one: " ++ show answer1
    putStrLn $ "Part two: " ++ show answer2