module App.Events where

import Prelude (discard, (==), otherwise, (&&), (#), (<<<))
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
import App.State (State(..), LoginForm(..), username, password, loginForm)
import Data.Function (($))
import Network.HTTP.Affjax (AJAX, get, post_)
import Pux (EffModel, noEffects, onlyEffects)
import Data.Argonaut (class EncodeJson
                    , encodeJson
                    , (:=), (~>)
                    , jsonEmptyObject)
import Control.Monad.Eff.Console (CONSOLE, log)
import Network.HTTP.StatusCode (StatusCode(..))
import Data.Lens ((.~), (^.))

data Event = PageView Route
           | Navigate String DOMEvent
           | SignIn DOMEvent
           | Authenticate StatusCode
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

foldp (UsernameChange ev) st =
  noEffects $ st # loginForm <<< username .~ targetValue ev

foldp (PasswordChange ev) st =
  noEffects $ st # loginForm <<< password .~ targetValue ev

foldp (SignIn ev) st =
    { state: st
    , effects: [ do
        let params = encodeJson user
        res <- attempt $ post_ "http://localhost:9292/login" params
        let code = case res of
                           Left _ -> StatusCode 0
                           Right rec -> rec.status
        liftEff $ log (show code)
        pure $ Just $ Authenticate code
      ]
    }
  where
        user :: User
        user = User { username: st ^. loginForm ^. username
                    , password: st ^. loginForm ^. password }

foldp (Authenticate (StatusCode code)) (State st) =
  case code of
       200 -> { state: (State st { loggedIn = true} )
                , effects: [ liftEff do
                    log "authentication triggered"
                    pure $ Just $ PageView (match "/reports")
                  ]
                }
       _ -> noEffects $ (State st)

foldp (ReportChange ev) (State st) =
  noEffects $ State st { report = (targetValue ev) }

foldp (YearChange ev) (State st) =
  noEffects $ State st { year = fromMaybe 0 $ fromString (targetValue ev) }

foldp (MonthChange ev) (State st) =
  noEffects $ State st { month = fromMaybe 0 $ fromString (targetValue ev) }

foldp (Generate ev) (State st) = noEffects $ State st { downloaded = true }
