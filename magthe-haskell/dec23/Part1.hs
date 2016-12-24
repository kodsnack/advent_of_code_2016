#! /usr/bin/env stack
{- stack runghc -}

module Main
  where

import qualified Data.Sequence as S
import           System.Environment
import           Text.Parsec
import           Text.Parsec.String

safeIndex s i = if i >= S.length s
                then Nothing
                else Just $ s `S.index` i

readProgram :: FilePath -> IO [Instruction]
readProgram fn = either (const $ error "parse failure") id <$> parseFromFile (many1 parseInstr) fn

parseInstr :: Parsec String () Instruction
parseInstr = choice [try parseCpy, try parseInc, try parseDec, try parseJnz, try parseTgl] <* optional newline
  where
    parseCpy = Cpy <$>
      (string "cpy " *> parseRegOrInt) <*>
      (char ' ' *> parseReg)

    parseInc = Inc <$> (string "inc " *> parseReg)

    parseDec = Dec <$> (string "dec " *> parseReg)

    parseJnz = Jnz <$>
      (string "jnz " *> parseRegOrInt) <*>
      (char ' ' *> parseRegOrInt)

    parseTgl = Tgl <$>
      (string "tgl " *> parseRegOrInt)

    parseReg = choice [char 'a', char 'b', char 'c', char 'd']

    parseInt = (*) <$>
      option 1 (char '-' >> return (-1)) <*>
      (read <$> many1 digit)

    parseRegOrInt = (Left <$> parseReg) <|> (Right <$> parseInt)

data Instruction = Cpy (Either Char Int) Char
                 | Inc Char
                 | Dec Char
                 | Jnz (Either Char Int) (Either Char Int)
                 | JnzT (Either Char Int) Int
                 | Tgl (Either Char Int)
                 | TglT Int
                 deriving (Eq, Show)

type Machine = (Int, Int, Int, Int, Int)

startMachine :: Machine
startMachine = (0, 7, 0, 0, 0)

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

constOrReg _ (Right v) = v
constOrReg m (Left r) = getRegValue m r

type EvalCtx = (S.Seq Instruction, Machine)

evalOne (ins, m) (Cpy (Left s) r) =
  let s' = getRegValue m s
      m' = setRegValue m r s'
  in (ins, withReg succ m' 'p')
evalOne (ins, m) (Cpy (Right i) r) = (ins, withReg succ (setRegValue m r i) 'p')

evalOne (ins, m) (Inc r) = (ins, withReg succ (withReg succ m r) 'p')
evalOne (ins, m) (Dec r) = (ins, withReg succ (withReg pred m r) 'p')

evalOne (ins, m) (Jnz p j) =
  let v = constOrReg m p
      c = constOrReg m j
  in if 0 /= v
     then (ins, withReg (+ c) m 'p')
     else (ins, withReg succ m 'p')
evalOne (ins, m) (JnzT _ _) = (ins, withReg succ m 'p')

evalOne im@(_, m) (Tgl (Left r)) = evalOne im (Tgl (Right $ getRegValue m r))
evalOne (ins, m) (Tgl (Right v)) =
  let idx = v + getRegValue m 'p'
      i = ins `safeIndex` idx
  in flip (maybe (ins, withReg succ m 'p')) i $ \ i' ->
    case i' of
    (Inc r) -> (S.update idx (Dec r) ins, withReg succ m 'p')
    (Dec r) -> (S.update idx (Inc r) ins, withReg succ m 'p')
    (Tgl (Left c)) -> (S.update idx (Inc c) ins, withReg succ m 'p')
    (Tgl (Right w)) -> (S.update idx (TglT w) ins, withReg succ m 'p')
    (TglT _) -> (ins, withReg succ m 'p')
    (Jnz p (Left c)) -> (S.update idx (Cpy p c) ins, withReg succ m 'p')
    (Jnz p (Right w)) -> (S.update idx (JnzT p w) ins, withReg succ m 'p')
    (JnzT p w) -> (S.update idx (Jnz p (Right w)) ins, withReg succ m 'p')
    (Cpy w c) -> (S.update idx (Jnz w (Left c)) ins, withReg succ m 'p')
evalOne im (TglT _) = im

eval ins m =
  let pl = S.length ins
      pc = getRegValue m 'p'
      i = ins `S.index` pc
      (ins', m') = evalOne (ins, m) i
  in if pc >= pl
     then m
     else eval ins' m'

main :: IO ()
main = do
  program <- (head <$> getArgs) >>= readProgram
  let (_, a, _, _, _) = eval (S.fromList program) startMachine
  print a
