#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Data.List as L (and, find, map, maximum, sort, unfoldr)
import Data.Vector as V (Vector, (//), (!), findIndex, fromList, map, replicate, toList)
import qualified Text.Parsec as P
import Text.Parsec.String
import Data.Either
import System.Environment
import Control.Arrow
import Control.Applicative

data Rule = Rule Int (Either Int Int) (Either Int Int)
  deriving (Eq, Show)

readInstructions :: FilePath -> IO (Vector [Int], [Rule])
readInstructions fn = do
  is <- (either (const $ error "parse failure") id) <$> parseFromFile (P.many1 parseInstruction) fn
  let (rules, values) = (rights &&& lefts) is
      numBots = 1 + (maximum $ L.map fst values ++ L.map rBot rules)
      initialState = foldr (\ (i, c) v -> v // [(i, c:(v!i))]) (V.replicate numBots []) values
  return (initialState, rules)

parseInstruction :: P.Parsec String () (Either (Int, Int) Rule)
parseInstruction = P.choice [P.try $ Left <$> parseValue, P.try $ Right <$> parseRule] <* P.optional P.newline
  where
    parseValue = flip (,) <$>
      (P.string "value " *> (read <$> P.many1 P.digit)) <*>
      (P.string " goes to bot " *> (read <$> P.many1 P.digit))

    parseRule = Rule <$>
      (P.string "bot " *> (read <$> P.many1 P.digit)) <*>
      (P.string " gives low to " *> parseDest) <*>
      (P.string " and high to " *> parseDest)

    parseDest = P.choice [P.try $ Left <$> parseOutput, P.try $ Right <$> parseBot]
    parseBot = P.string "bot " *> (read <$> P.many1 P.digit)
    parseOutput = P.string "output " *> (read <$> P.many1 P.digit)

rBot (Rule id _ _) = id

ruleByBot :: [Rule] -> Int -> Maybe Rule
ruleByBot rs id = find ((== id) . rBot) rs

findBotWith2 :: Vector [Int] -> Maybe Int
findBotWith2 = findIndex ((== 2) . length)

updateState (Rule id (Left _) (Left _)) s = s // [(id, [])]
updateState (Rule id (Right low) (Left _)) s = s // [(id, []), (low, nL)]
  where
    [l, _] = sort $ s ! id
    nL = l:(s ! low)
updateState (Rule id (Left _) (Right high)) s = s // [(id, []), (high, nH)]
  where
    [_, h] = sort $ s ! id
    nH = h:(s ! high)
updateState (Rule id (Right low) (Right high)) s = s // [(id, []), (low, nL), (high, nH)]
  where
    [l, h] = sort $ s ! id
    nL = l:(s ! low)
    nH = h:(s ! high)

isFinalState :: Vector [a] -> Bool
isFinalState = and . toList . V.map null

step :: [Rule] -> Vector [Int] -> Maybe ((Rule, [Int]), Vector [Int])
step rs s
  | isFinalState s = Nothing
  | otherwise = do
      bot <- findBotWith2 s
      rule <- ruleByBot rs bot
      return ((rule, sort $ s ! bot), updateState rule s)

whatBotCompares :: [Rule] -> Vector [Int] -> Int -> Int -> Int
whatBotCompares rs s c0 c1 = maybe 0 (\ ((Rule id _ _), _) -> id) $ find ((== cs) . snd) rncs
  where
    cs :: [Int]
    cs = sort [c0, c1]
    rncs :: [(Rule, [Int])]
    rncs = unfoldr (step rs) s

main :: IO ()
main = do
  (state, rules) <- (head <$> getArgs) >>= readInstructions
  print $ whatBotCompares rules state 61 17
