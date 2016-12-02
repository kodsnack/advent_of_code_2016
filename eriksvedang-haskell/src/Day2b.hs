module Day2b where

pad = ["       "
      ,"   1   "
      ,"  234  "
      ," 56789 "
      ,"  ABC  "
      ,"   D   "
      ,"       "]

type Coord = (Int, Int)

step :: Coord -> Char -> Coord
step (x, y) move = let (x', y') = case move of
                                    'L' -> (x - 1, y)
                                    'R' -> (x + 1, y)
                                    'U' -> (x, y - 1)
                                    'D' -> (x, y + 1)
                       c = pad !! y' !! x'
                   in if c == ' ' then
                        (x, y)
                      else
                        (x', y')

oneLine :: Coord -> String -> (Coord, Char)
oneLine start line = let (x, y) = foldl step start line
                     in ((x, y), pad !! y !! x)

analyze :: Foldable t => t String -> (Coord, [Char])
analyze lines = foldl f ((1,3), "") lines
  where f (start, code) line = let (newPos, c) = oneLine start line
                               in (newPos, code ++ [c])
  
main :: IO ()
main = do
  file <- readFile "./src/Day2.txt"
  let (_, code) = analyze (lines file)
  putStrLn $ "The code is " ++ code ++ "."
