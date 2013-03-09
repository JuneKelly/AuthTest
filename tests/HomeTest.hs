{-# LANGUAGE OverloadedStrings #-}
module HomeTest
    ( homeSpecs
    , dataSetup
    , dataTearDown
    , authSpecs
    ) where

import TestImport
import TestTools
import qualified Data.List as L
import Model
import Database.Persist
import Yesod.Auth.HashDB (setPassword)

      
homeSpecs :: Specs
homeSpecs =
  describe "These are some example tests" $ do

    it "loads the index and checks it looks right" $ do
      get_ "/"
      statusIs 200
      htmlAllContain "h1" "Hello"
      htmlAnyContain "a" "First Link"
      
      htmlAnyContain "h2" "One"
      htmlAnyContain "h2" "Two"

    -- This is a simple example of using a database access in a test.  The
    -- test will succeed for a fresh scaffolded site with an empty database,
    -- but will fail on an existing database with a non-empty user table.
{-    it "leaves the user table empty" $ do
      get_ "/"
      statusIs 200
      users <- runDB $ selectList ([] :: [Filter User]) []
      assertEqual "user table empty" 0 $ L.length users
-}

authSpecs :: Specs
authSpecs =
  describe "test authentication" $ do
    
    it "should block access to profile page" $ do
      needsLogin GET "/profile"

    it "should show profile for logged in user" $ do
      doLogin "testuser" "password"
      get_ "/profile"
      statusIs 200
      bodyContains "testuser"
      

dataSetup :: Specs
dataSetup =
  describe "setup" $ do
    it "something" $ do
      testUser <- setPassword "password" $
                    User { userUsername = "testuser",
                           userPassword = "",
                           userSalt = ""
                         }
      _ <- runDB $ insert testUser
      return ()
      
dataTearDown :: Specs
dataTearDown =
  describe "teardown" $ do
    it "something" $ do
      _ <- runDB $ deleteWhere ([] :: [Filter User])
      return ()