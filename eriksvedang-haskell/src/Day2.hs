module Day2 where

pad = [[1, 2, 3]
      ,[4, 5, 6]
      ,[7, 8, 9]]

type Coord = (Int, Int)

step :: Coord -> Char -> Coord
step (x, y) move = let (x', y') = case move of
                                    'L' -> (x - 1, y)
                                    'R' -> (x + 1, y)
                                    'U' -> (x, y - 1)
                                    'D' -> (x, y + 1)
                   in if x' < 0 || x' > 2 || y' < 0 || y' > 2 then
                        (x, y)
                      else
                        (x', y')

oneLine :: Coord -> String -> (Coord, String)
oneLine start line = let (x, y) = foldl step start line
                     in ((x, y), show $ pad !! y !! x)

analyze :: Foldable t => t String -> (Coord, [Char])
analyze lines = foldl f ((1,1), "") lines
  where f (start, code) line = let (newPos, c) = oneLine start line
                               in (newPos, code ++ c)
  
main :: IO ()
main = do
  file <- readFile "./src/Day2.txt"
  let (_, code) = analyze (lines file)
  putStrLn $ "The code is " ++ code ++ "."
