module Day1 where

import Text.ParserCombinators.Parsec as P
import Data.List (foldl', intersect, delete)

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

main = do
  file <- readFile "./src/Day1.txt"
  let answer = case parseDirectionsData (init file) of
            Left e -> error (show e)
            Right moves -> manhattanDistanceFromOrigo (position (applyMoves start moves))
  putStrLn $ "Answer = " ++ show answer


