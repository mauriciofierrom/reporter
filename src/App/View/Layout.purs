module App.View.Layout where

import App.View.Homepage as Homepage
import App.View.NotFound as NotFound
import App.View.Report as Report
import App.View.Login as Login
import App.View.Logout as Logout
import App.View.Reports as Reports

import App.Routes (Route(NotFound, Home, Report, Login, Logout, Reports))
import App.State (State(..))
import App.Events (Event(..))
import CSS (CSS, fromString, (?), fontSize, display, inlineBlock, marginTop, marginRight, marginLeft, px, value, key, color, backgroundColor, padding, borderRadius)
import CSS.Border (border, solid)
import CSS.TextAlign (center, textAlign)
import CSS.Text (textDecoration, noneTextDecoration, letterSpacing)
import CSS.Text.Transform (textTransform, uppercase)
import Color (rgb)
import Control.Bind (discard)
import Control.Error.Util (bool)
import Data.Function (($), (#))
import Pux.DOM.HTML (HTML, style)
import Pux.DOM.Events (onClick)
import Text.Smolder.HTML (div, body, nav, a, h1)
import Text.Smolder.HTML.Attributes (className, href)
import Text.Smolder.Markup ((!), (#!), text)

view :: State -> HTML Event
view (State st) =
  case st.route of
    (Home) -> do
       Homepage.view (State st)
    (Report string) -> do
       mainLayout (State st)
       Report.view (State st)
    (Reports) -> do
       mainLayout (State st)
       Reports.view (State st)
    (Login) -> Login.view (State st)
    (Logout) -> Logout.view (State st)
    (NotFound url) -> NotFound.view (State st)

mainLayout :: State -> HTML Event
mainLayout (State st) = do
  nav ! className "navbar navbar-dark bg-dark fixed-top" $ do
    a ! className "navbar-brand" ! href "#" $ text st.company
    a ! className "float-right" ! href url #! onClick (Navigate url) $
      text desc
  where
    url = bool  "/login" "/logout" st.loggedIn
    desc = bool  "Login" "Logout" st.loggedIn
