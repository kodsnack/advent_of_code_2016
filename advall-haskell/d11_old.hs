import Data.Map
import Data.List

parseInput :: String -> Map String Integer
parseInput s = fromList [("HyM", 0), ("LiM", 0), ("HyG", 1), ("LiG", 2), ("E", 0)]

moveOne :: String -> Integer -> Map String Integer -> Map String Integer
moveOne obj direction state = adjust (+direction) "E" (adjust (+direction) obj state)

moveTwo :: String -> String -> Integer -> Map String Integer -> Map String Integer
moveTwo obj1 obj2 direction state = adjust (+direction) obj2 (moveOne obj1 direction state)

validState :: [Map String Integer] -> Map String Integer -> Bool
validState allVisitedStates state
    | isInfixOf [state] allVisitedStates = False
    | (groupBy onSameFloor (toList state))

onSameFloor :: (String, Integer) -> (String, Integer) -> Bool
onSameFloor (a, af) (b, bf) = af == bf