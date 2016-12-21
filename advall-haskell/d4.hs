import Data.List
import Data.List.Split
import Data.Char

computeChecksum :: String -> String
computeChecksum s = take 5 (map head (sortBy sortLetter (group (sort s))))

sortLetter :: String -> String -> Ordering
sortLetter s1 s2
    | (length s1) < (length s2) = GT
    | (length s1) > (length s2) = LT
    | (length s1) == (length s2) = compare (head s1) (head s2)

parseInput :: String -> [(Integer, String, String)]
parseInput s = map parseInputLine (lines s)

parseInputLine :: String -> (Integer, String, String)
parseInputLine s = (read (head (splitOn "[" (last (splitOn "-" s)))),
                 init (last (splitOn "[" (last (splitOn "-" s)))),
                 concat (init (splitOn "-" s)))

sumValidRoomIDs :: [(Integer, String, String)] -> Integer
sumValidRoomIDs [] = 0
sumValidRoomIDs ((id, chksm, encName):xs)
    | (computeChecksum encName) == chksm = id + (sumValidRoomIDs xs)
    | otherwise = sumValidRoomIDs xs

decWord :: String -> Integer -> String
decWord [] _ = []
decWord (c:cs) id = [chr (((((ord c) - 97) + (fromIntegral id)) `mod` 26) + 97)] 
                    ++ (decWord cs id)

decName :: ([String], Integer) -> String
decName ([],_) = []
decName ((s:ss),id) = init ((decWord s id) ++ " " ++ decName (ss,id))

findRoomID :: [([String], Integer)] -> String -> Integer
findRoomID [] _ = -1
findRoomID ((name,id):xs) str
    | str `isInfixOf` (decName (name, id)) = id
    | otherwise = findRoomID xs str

parseInput2 :: String -> [([String], Integer)]
parseInput2 s = map parseInputLine2 (lines s)

parseInputLine2 :: String -> ([String], Integer)
parseInputLine2 s = (init (splitOn "-" s) , 
                    read (head (splitOn "[" (last (splitOn "-" s)))))

main = do
    input <- readFile "d4_input.txt"
    let answer1 = sumValidRoomIDs (parseInput input)
    let answer2 = findRoomID (parseInput2 input) "northpole object"
    putStrLn $ "Part one: " ++ show answer1
    putStrLn $ "Part two: " ++ show answer2