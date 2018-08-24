module App.State where

import App.Config (config)
import App.Routes (Route(..), match)
import Data.Newtype (class Newtype)
import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Symbol (SProxy(..))
import Prelude ((<<<))

newtype LoginForm = LoginForm
  { username :: String
  , password :: String
  }

derive instance newtypeLoginForm :: Newtype LoginForm _

username :: Lens' LoginForm String
username = _Newtype <<< prop (SProxy :: SProxy "username")

password :: Lens' LoginForm String
password = _Newtype <<< prop (SProxy :: SProxy "password")


newtype State = State
  {
    route     :: Route
  , loginForm :: LoginForm
  , report    :: String
  , company   :: String
  , downloaded :: Boolean
  , downloadError :: Boolean
  , downloadLink :: String
  , loggedIn  :: Boolean
  , month :: Int
  , year :: Int
  }

derive instance newtypeState :: Newtype State _

loginForm :: Lens' State LoginForm
loginForm = _Newtype <<< prop (SProxy :: SProxy "loginForm")

init :: State
init = State
  {
    route: Login
  , loginForm: LoginForm { username: "", password: "" }
  , report: ""
  , company: "No Co"
  , downloaded: false
  , downloadError: false
  , downloadLink: ""
  , loggedIn: false
  , month: 1
  , year: 2017
  }
