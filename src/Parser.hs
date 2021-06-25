module Parser (parse) where

import Prelude hiding (Either)
import Data.Functor (fmap)

import Tokens


data Type
    = Type String
    | Either Type Type
    deriving (Eq, Show)

parse :: [Token] -> Maybe Type
parse tks = parseS (tks ++ [End])

parseS :: [Token] -> Maybe Type
parseS tks@(Try:_) = fst <$> parseL tks
parseS tks@((Instr _):_) = fst <$> parseL tks
parseS _ = Nothing

parseL :: [Token] -> Maybe (Type, [Token])
parseL tks@(Try:_) = do
    (iType, tks') <- parseI tks
    parseR tks' iType
parseL tks@((Instr _):_) = do
    (iType, tks') <- parseI tks
    parseR tks' iType
parseL _ = Nothing

parseR :: [Token] -> Type -> Maybe (Type, [Token])
parseR (Semicolon:tks) _ = do
    (iType, tks') <- parseI tks
    parseR tks' iType
parseR tks@(tk:_) iType
    | tk == Catch || tk == Finally || tk == End = Just (iType, tks)
    | otherwise = Nothing

parseI :: [Token] -> Maybe (Type, [Token])
parseI tks@(Try:_) = do
    (tType, tks') <- parseT tks
    parseF tks' tType
parseI ((Instr tp):tks) = Just (Type tp, tks)
parseI _ = Nothing

parseT :: [Token] -> Maybe (Type, [Token])
parseT (Try:tks) = do
    (tType, tks') <- parseL tks
    case tks' of
        (Catch:tks'') -> do
            (cType, rest) <- parseL tks''
            return (Either tType cType, rest)
        _ -> Nothing
parseT _ = Nothing

parseF :: [Token] -> Type -> Maybe (Type, [Token])
parseF (Finally:tks) _ = parseI tks
parseF tks@(tk:_) tcType
    | tk == Catch || tk == Finally || tk == End = Just (tcType, tks)
    | otherwise = Nothing

