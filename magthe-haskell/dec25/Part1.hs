#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import Control.Monad.Writer
import Data.List
import System.Environment
import Text.Parsec
import Text.Parsec.String

readProgram :: FilePath -> IO [Instruction]
readProgram fn = either (const $ error "parse failure") id <$> parseFromFile (many1 parseInstr) fn

parseInstr :: Parsec String () Instruction
parseInstr = choice [try parseCpy, try parseInc, try parseDec, try parseJnz , try parseOut] <* optional newline
  where
    parseCpy = Cpy <$>
      (string "cpy " *> choice [Left <$> parseReg, Right <$> parseInt]) <*>
      (char ' ' *> parseReg)

    parseInc = Inc <$> (string "inc " *> parseReg)

    parseDec = Dec <$> (string "dec " *> parseReg)

    parseJnz = Jnz <$>
      (string "jnz " *> choice [Left <$> parseReg, Right <$> parseInt]) <*>
      (char ' ' *> parseInt)

    parseOut = Out <$>
      (string "out " *> choice [Left <$> parseReg, Right <$> parseInt])

    parseReg = choice [char 'a', char 'b', char 'c', char 'd']

    parseInt = (*) <$>
      option 1 (char '-' >> return (-1)) <*>
      (read <$> many1 digit)

type Machine = (Int, Int, Int, Int, Int)

data Instruction = Cpy (Either Char Int) Char
                 | Inc Char
                 | Dec Char
                 | Jnz (Either Char Int) Int
                 | Out (Either Char Int)
                 deriving (Eq, Show)

startMachine :: Machine
startMachine = (0, 0, 0, 0, 0)

machineWithA :: Int -> Machine
machineWithA a = (0, a, 0, 0, 0)

getRegValue (pc, rA, rB, rC, rD) r =
  case r of
    'p' -> pc
    'a' -> rA
    'b' -> rB
    'c' -> rC
    'd' -> rD

setRegValue (pc, rA, rB, rC, rD) r v =
  case r of
    'p' -> (v, rA, rB, rC, rD)
    'a' -> (pc, v, rB, rC, rD)
    'b' -> (pc, rA, v, rC, rD)
    'c' -> (pc, rA, rB, v, rD)
    'd' -> (pc, rA, rB, rC, v)

withReg f m r =
  let v = getRegValue m r
      m' = setRegValue m r (f v)
  in m'

evalOne :: Machine -> Instruction -> Writer [Int] Machine
evalOne m (Cpy (Left s) r) =
  let s' = getRegValue m s
      m' = setRegValue m r s'
  in return $ withReg succ m' 'p'
evalOne m (Cpy (Right i) r) = return $ withReg succ (setRegValue m r i) 'p'
evalOne m (Inc r) = return $ withReg succ (withReg succ m r) 'p'
evalOne m (Dec r) = return $ withReg succ (withReg pred m r) 'p'
evalOne m (Jnz (Left r) c) =
  let tv = getRegValue m r
  in if 0 /= tv
     then return $ withReg (+ c) m 'p'
     else return $ withReg succ m 'p'
evalOne m (Jnz (Right v) c) =
  if 0 /= v
  then return $ withReg (+ c) m 'p'
  else return $ withReg succ m 'p'
evalOne m (Out (Left r)) =
  let v = getRegValue m r
  in evalOne m (Out $ Right v)
evalOne m (Out (Right v)) = tell [v] >> return (withReg succ m 'p')

eval :: [Instruction] -> Machine -> Writer [Int] Machine
eval prog mach = do
  let progLen = length prog
      pc = getRegValue mach 'p'
      instr = prog !! pc
  if pc >= progLen
    then return mach
    else evalOne mach instr >>= eval prog

wantedSignal :: [Int]
wantedSignal = take 20 $ cycle [0, 1]

main :: IO ()
main = do
  program <- (head <$> getArgs) >>= readProgram
  let ss = map (take 20 . snd . runWriter . eval program . machineWithA) [0 ..]
      (Just i) = elemIndex wantedSignal ss
  print i
