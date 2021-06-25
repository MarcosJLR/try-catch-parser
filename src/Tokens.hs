module Tokens (Token(..), maybeReadToken) where

import Data.Char (isAlphaNum)

data Token
    = Try
    | Catch
    | Finally
    | Semicolon
    | Instr String
    | End
    deriving (Eq)

maybeReadToken :: String -> Maybe Token
maybeReadToken "try" = Just Try
maybeReadToken "catch" = Just Catch
maybeReadToken "finally" = Just Finally
maybeReadToken ";" = Just Semicolon
maybeReadToken str
    | valid = Just $ Instr suf
    | otherwise = Nothing
  where
    pref = take 6 str
    suf = drop 6 str
    valid = pref == "instr_" && suf /= "" && all isAlphaNum suf


