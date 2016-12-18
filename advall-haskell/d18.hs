rows :: [Bool] -> [Int]
rows fstRow = [length (filter (== True) fstRow)] ++ rows (nextRow fstRow)

nextRow :: [Bool] -> [Bool]
nextRow r = nextRow' ([True] ++ r ++ [True])

nextRow' :: [Bool] -> [Bool]
nextRow' (_:_:[]) = []
nextRow' (x:y:z:xs) = [x == z] ++ nextRow' (y:z:xs)

toBools :: String -> [Bool]
toBools s = map (== '.') s

main = do
    input <- readFile "d18_input.txt"
    let answer1 = sum (take 40 (rows (toBools input)))
    putStrLn $ "Part one: " ++ show answer1
    let answer2 = sum (take 400000 (rows (toBools input)))
    putStrLn $ "Part two: " ++ show answer2