module Day1b where

import Text.ParserCombinators.Parsec as P
import Data.List (foldl', delete)

data Move = L Int
          | R Int
          deriving (Show, Eq)

type Degrees = Int
type Coord = (Int, Int)

data Situation = Situation { rotation :: Int
                           , position :: Coord }
                 deriving (Show, Eq)

parseDirectionsData :: String -> Either ParseError [Move]
parseDirectionsData s = P.parse parseCommaSeparated "error" s
  where parseCommaSeparated = P.sepBy parseDir separator
        separator = do P.spaces
                       P.char ','
                       P.spaces
        parseNum = read <$> P.many1 digit
        parseDir = do sym <- P.oneOf "LR"
                      i <- parseNum
                      return $ case sym of
                                 'L' -> L i
                                 'R' -> R i

turn :: Degrees -> Move -> Degrees
turn angle move = let op = case move of
                             L _ -> (+)
                             R _ -> (-)
                  in op angle 90 `mod` 360

angleToUnitVector :: Degrees -> (Int, Int)
angleToUnitVector angle = case angle of
  0   -> ( 1,  0)
  90  -> ( 0,  1)
  180 -> (-1,  0)
  270 -> ( 0, -1)

getWalkingDistance :: Move -> Int
getWalkingDistance (L d) = d
getWalkingDistance (R d) = d

walk :: Coord -> Degrees -> Int -> Coord
walk (x, y) angle distance = let (dx, dy) = angleToUnitVector angle
                             in (x + dx * distance, y + dy * distance)

applyMove :: Situation -> Move -> Situation
applyMove situation move = let newRot = turn (rotation situation) move
                               newPos = walk (position situation) newRot (getWalkingDistance move)
                           in Situation { position = newPos
                                        , rotation = newRot }

applyMoves :: Situation -> [Move] -> Situation
applyMoves situation moves = foldl' applyMove situation moves

start :: Situation
start = (Situation 90 (0, 0))

manhattanDistanceFromOrigo :: Coord -> Int
manhattanDistanceFromOrigo (x, y) = abs x + abs y

visitedRange (x1, y1) (x2, y2) = let range = [(x, y) | x <- [(min x1 x2) .. (max x1 x2)]
                                                     , y <- [(min y1 y2) .. (max y1 y2)]]
                                 in if x1 > x2 || y1 > y2 then
                                      reverse range
                                    else
                                      range

firstIntersection :: [Coord] -> [Coord] -> Maybe Coord
firstIntersection [] visited = Nothing
firstIntersection (x:xs) visited = if elem x visited then Just x else firstIntersection xs visited

-- Note, this won't work if there are several intersections in one movement...
applyMoveIfNotSame :: (Situation, [Coord], Maybe Coord) -> Move -> (Situation, [Coord], Maybe Coord)
applyMoveIfNotSame (situation, visited, answer) move = 
  case answer of
    Just pos -> (situation, visited, answer)
    Nothing -> let oldPos = position situation
                   newSituation = applyMove situation move
                   newPos = (position newSituation)
                   newVisited = delete oldPos (visitedRange oldPos newPos)
                   answer = firstIntersection newVisited visited 
               in (newSituation, visited ++ newVisited, answer)
                  
applyMovesUntilSameSituation :: Situation -> [Move] -> Maybe Coord
applyMovesUntilSameSituation situation moves = let (_, _, answer) = foldl' applyMoveIfNotSame (situation, [(0,0)], Nothing) moves
                                               in answer

main :: IO ()
main = do
  file <- readFile "./src/Day1.txt"
  let answer = case parseDirectionsData (init file) of
                 Left e -> error (show e)
                 Right moves -> case (applyMovesUntilSameSituation start moves) of
                                  Just stop -> manhattanDistanceFromOrigo stop
                                  Nothing -> error "No intersection"
  putStrLn $ "Answer = " ++ show answer
