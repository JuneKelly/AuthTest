module Handler.Profile
       ( getProfileR
       ) where

import Import

getProfileR :: Handler RepHtml
getProfileR = do
  Entity _ u <- requireAuth
  defaultLayout $ do
    setTitle $ toHtml $ userUsername u
    $(widgetFile "profile")
      
      