{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Colog (Message, WithLog, cmap, logTextStderr, logTextStdout, usingLoggerT)
import Colog.Message
import Control.Concurrent (threadDelay)
import Control.Monad
import UnliftIO

import Cli
import Options.Applicative

main :: IO ()
main = main3 =<< execParser opts
  where
    opts =
        info
            (parser <**> helper)
            ( fullDesc
                <> progDesc "Print a greeting for TARGET"
                <> header "hello - a test for optparse-applicative"
            )

main3 :: Command -> IO ()
main3 = undefined

main2 :: (WithLog env Message m, MonadIO m) => m ()
main2 = do
    logInfo "hello"

doWork :: (WithLog env Message m, MonadIO m) => m ()
doWork = do
    logInfo "doing work"
    liftIO $ threadDelay 300000
    logInfo "done"
