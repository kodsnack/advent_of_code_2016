import qualified Data.Set as Set
import Data.List

getStartState :: String -> (Integer, Integer, [(Integer, Integer)])
getStartState src = (0, 0, [(0,0), (1,2), (1,2), (1,2), (1,2)])

validState :: [(Integer, Integer)] -> Bool
validState state = (not (or(map (`fried` state) state)))
                    && (allInRange state)

fried :: (Integer, Integer) -> [(Integer, Integer)] -> Bool
fried (g,m) state
    | g == m = False
    | otherwise = elem m (map fst state)

allInRange :: [(Integer, Integer)] -> Bool
allInRange state = (maximum (map fst state) < 4) 
                    && (maximum (map snd state) < 4) 
                    && (minimum (map fst state) >= 0) 
                    && (minimum (map snd state) >= 0)

allNextStates :: [(Integer, Integer)] -> [[(Integer, Integer)]]
allNextStates state = 

moves :: Integer -> [(Integer, Integer)] -> [[(Integer, Integer)]]
moves dir state = (map (moveOne dir state) state) ++ (map (moveTwo dir state) state)

moveOne :: Integer -> [(Integer, Integer)] -> (Integer, Integer)
moveOne dir state (g,m) = take n xs ++ [newElement] ++ drop (n + 1) xs