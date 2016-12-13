

isTriangle :: [Integer] -> Bool
isTriangle [s1, s2, s3] = (s1 + s2 > s3) && (s1 + s3 > s2) && (s2 + s3 > s1)

countTriangles :: [[Integer]] -> Integer
countTriangles [] = 0
countTriangles (x:xs)
    | isTriangle x = 1 + countTriangles xs
    | otherwise = countTriangles xs

parseInput :: String -> [[Integer]]
parseInput s = map (map read) (map words (lines s))

parseInput' :: [[Integer]] -> [[Integer]]
parseInput' [] = []
parseInput' (x:y:z:xs) = [[x!!0] ++ [y!!0] ++ [z!!0]] ++ [[x!!1] ++ [y!!1] 
                ++ [z!!1]] ++ [[x!!2] ++ [y!!2] ++ [z!!2]] ++ parseInput' xs


main = do
    input <- readFile "d3_input.txt"
    let answer1 = countTriangles (parseInput input)
    let answer2 = countTriangles (parseInput' (parseInput input))
    putStrLn $ "Part one: " ++ show answer1
    putStrLn $ "Part two: " ++ show answer2