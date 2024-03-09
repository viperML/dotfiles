module Cli where

import Options.Applicative

data Command = Matrix | Genflake
    deriving (Show)

-- data DotciMatrix = DotciMatrix {}
--     deriving (Show)

-- data DotciGenflake = DotciGenflake {}
--     deriving (Show)

parser :: Parser Command
parser =
    subparser
        ( command "matrix" (info (pure Matrix) (progDesc "matrix"))
            <> command "genflake" (info (pure Genflake) (progDesc "genflake"))
        )
