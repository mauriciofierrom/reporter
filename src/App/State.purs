module App.State where

import App.Config (config)
import App.Routes (Route(..), match)
import Data.Newtype (class Newtype)

{-- data LoginForm = LoginForm --}
{--   { username :: String --}
{--   , password :: String --}
{--   } --}

newtype State = State
  {
    route     :: Route
  {-- , loginForm :: LoginForm --}
  , report    :: String
  , company   :: String
  , username  :: String
  , password  :: String
  , downloaded :: Boolean
  , downloadError :: Boolean
  , downloadLink :: String
  , loggedIn  :: Boolean
  , month :: Int
  , year :: Int
  }

derive instance newtypeState :: Newtype State _

init :: State
init = State
  {
    route: Login
  {-- , loginForm: LoginForm { username: "", password: "" } --}
  , report: ""
  , company: "No Co"
  , username: ""
  , password: ""
  , downloaded: false
  , downloadError: false
  , downloadLink: ""
  , loggedIn: false
  , month: 1
  , year: 2017
  }
