import Data.List

parseInput :: String -> [(Integer, Integer)]
parseInput s = map wordsToSlots (map words (lines s))

wordsToSlots :: [String] -> (Integer, Integer)
wordsToSlots s = (read (s!!3), read (init (s!!11)))

allOpen :: [(Integer, Integer)] -> Integer -> Bool
allOpen slots timeOfPush = and (map (openWhenReached timeOfPush) (zip [1..] slots))

openWhenReached :: Integer -> (Integer, (Integer, Integer)) -> Bool
openWhenReached timeOfPush (offset, (noOfPos, startPos)) = ((startPos + offset + timeOfPush) `mod` noOfPos) == 0

solve :: [(Integer, Integer)] -> Integer -> Integer
solve slots t
    | allOpen slots t = t
    | otherwise = solve slots (t+1)


main = do
    input <- readFile "d15_input.txt"
    let slots = parseInput input
    let answer1 = solve slots 0
    putStrLn $ "Part one: " ++ show answer1
    let slots2 = slots ++ [(11,0)]
    let answer2 = solve slots2 0
    putStrLn $ "Part two: " ++ show answer2

