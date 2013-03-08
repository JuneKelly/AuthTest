module Model where

import Prelude
import Yesod
import Data.Text (Text)
import Database.Persist.Quasi
import Yesod.Auth.HashDB (HashDBUser,
                          userPasswordHash,
                          userPasswordSalt,
                          setUserHashAndSalt)


-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")

instance HashDBUser (UserGeneric backend) where
    userPasswordHash = Just . userPassword
    userPasswordSalt = Just . userSalt
    setUserHashAndSalt s h p = p { userSalt     = s
                                 , userPassword = h
                                 }