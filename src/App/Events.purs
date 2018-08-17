module App.Events where

import Prelude (discard, (==), otherwise, (&&))
import Data.Foreign (toForeign)
import Data.Function (($))
import Data.Functor ((<$>))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Either (Either(Left, Right), either)
import Data.Int (fromString)
import Data.Show (show)
import DOM.Event.Event (preventDefault)
import DOM (DOM)
import DOM.HTML.Types(HISTORY)
import DOM.HTML.History (DocumentTitle(..), URL(..), pushState)
import DOM.HTML (window)
import DOM.HTML.Window (history)
import Pux.DOM.Events (DOMEvent, targetValue)
import Signal.Channel (CHANNEL)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Aff (attempt, launchAff)
import Control.Monad.Aff.Class (liftAff)
import Control.Bind((=<<), bind)
import Control.Applicative (pure, (*>))
import App.Routes (Route, match)
import App.State (State(..))
import Data.Function (($))
import Network.HTTP.Affjax (AJAX, get, post_)
import Pux (EffModel, noEffects, onlyEffects)
import Data.Argonaut (class EncodeJson
                    , encodeJson
                    , (:=), (~>)
                    , jsonEmptyObject)
import Control.Monad.Eff.Console (CONSOLE, log)

data Event = PageView Route
           | Navigate String DOMEvent
           | SignIn DOMEvent
           | Authenticate String
           | UsernameChange DOMEvent
           | PasswordChange DOMEvent
           | ReportChange DOMEvent
           | YearChange DOMEvent
           | MonthChange DOMEvent
           | Generate DOMEvent

data User = User {
    username :: String
  , password :: String
  }

instance encodeJsonPost :: EncodeJson User where
  encodeJson (User user)
    = "username" := user.username
    ~> "password" := user.password
    ~> jsonEmptyObject

type AppEffects fx = (dom :: DOM, history :: HISTORY, ajax :: AJAX, console :: CONSOLE | fx)

foldp :: ∀ fx. Event -> State -> EffModel State Event (AppEffects fx)
foldp (PageView r) (State st) = noEffects $ State st { route = r }
foldp (Navigate url ev) st =
  { state: st
  , effects: [ liftEff do
                   preventDefault ev
                   h <- history =<< window
                   pushState (toForeign {}) (DocumentTitle "") (URL url) h
                   pure $ Just $ PageView (match url)
             ]
  }

foldp (UsernameChange ev) (State st) =
  noEffects $ State st { username = (targetValue ev) }

foldp (PasswordChange ev) (State st) =
  noEffects $ State st { password = (targetValue ev) }

foldp (SignIn ev) (State st) =
    { state: (State st)
    , effects: [ do
        let params = encodeJson user
        res <- attempt $ post_ "http://localhost:9292/login" params
        liftEff $ log (show params)
        pure $ Just $ Authenticate "la"
      ]
    }
  where
        user :: User
        user = User { username: st.username, password: st.password }

foldp (Authenticate r) (State st) =
  case r of
       "error" -> noEffects $ (State st)
       _       -> { state: (State st { loggedIn = true, company = r })
                  , effects: [ liftEff do
                      log "authentication triggered"
                      pure $ Just $ PageView (match "/reports")
                    ]
                  }

foldp (ReportChange ev) (State st) =
  noEffects $ State st { report = (targetValue ev) }

foldp (YearChange ev) (State st) =
  noEffects $ State st { year = fromMaybe 0 $ fromString (targetValue ev) }

foldp (MonthChange ev) (State st) =
  noEffects $ State st { month = fromMaybe 0 $ fromString (targetValue ev) }

foldp (Generate ev) (State st) = noEffects $ State st { downloaded = true }
