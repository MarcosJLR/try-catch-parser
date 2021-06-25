module Main where


import Data.Maybe (isNothing, fromJust)

import Parser
import Tokens

main :: IO ()
main = do
    str <- getContents
    let mTokens = map maybeReadToken $ words str
    if any isNothing mTokens
        then putStrLn "Expression contains illegal tokens."
        else do
            let tokens = map fromJust mTokens
            case parse tokens of
                Nothing -> putStrLn "The phrase does not belong to the language"
                Just tp -> do
                    putStrLn "The expression evaluates to type:"
                    print tp
