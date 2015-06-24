{-# LANGUAGE OverloadedStrings #-}

module Euphoria.Types where

import qualified Data.Aeson                 as J
import           Control.Monad

type MessageID = String

data UserData = UserData { userID     :: String,
                           name       :: String,
                           serverID   :: String,
                           serverEra  :: String,
                           sessionID  :: String }
      deriving (Eq,Show)

data MessageData = MessageData { timeRecieved :: Integer,
                                 msgID        :: MessageID,
                                 parentMsg    :: String,
                                 sender       :: UserData,
                                 contentMsg   :: String,
                                 edited       :: Bool,
                                 deleted      :: Bool }
      deriving (Show)

instance J.FromJSON MessageData where
  parseJSON (J.Object v) = 
      MessageData <$> (v J..: "time")
                  <*> (v J..: "id")
                  <*> (v J..: "parent")
                  <*> (v J..: "sender")
                  <*> (v J..: "content")
                  <*> (v J..:? "edited" J..!=False)
                  <*> (v J..:? "deleted" J..!=False)

  parseJSON _ = mzero

instance J.FromJSON UserData where
  parseJSON (J.Object v) = 
      UserData <$> (v J..: "id")
               <*> (v J..: "name")
               <*> (v J..:? "server_id" J..!= "")
               <*> (v J..:? "server_era" J..!= "")
               <*> (v J..: "session_id")
  parseJSON _ = mzero