module App.View.Homepage where

import App.Events (Event(..))
import App.State (State)
import Control.Bind (discard)
import Data.Function (($))
import Pux.DOM.HTML (HTML)
import Pux.DOM.Events (onClick)
import Text.Smolder.HTML (img, form, h3, br, p, a, div, h1, li, nav, ul, link)
import Text.Smolder.HTML.Attributes (src, href, className, style, rel, width, height)
import Text.Smolder.Markup ((!), (#!), text)

view :: State -> HTML Event
view s = do
  link ! rel "stylesheet"
       ! href "https://getbootstrap.com/docs/4.0/examples/floating-labels/floating-labels.css"
  form ! className "form-signin" $ do
     div ! className "text-center mb-4" $ do
        img ! className "mb-4" ! src "http://aux.iconpedia.net/uploads/16785340971943571304.png" ! width "72" ! height "72"
        h1 ! className "h3 mb-3 font-weight-normal" $ text "Reports"
        p $ text "Reports"
        a ! className "btn btn-primary" ! href "#" #! onClick (Navigate "/login") $ text "Login"

description :: HTML Event
description = do
  h3 $ text "Report app"

navigation :: HTML Event
navigation =
   nav do
      ul do
        li $ a ! href "/" #! onClick (Navigate "/") $ text "Home"
        li $ a ! href "/reports/report1" #! onClick (Navigate "/reports/report1") $
          text "Report 1"
        li $ a ! href "/reports/report2" #! onClick (Navigate "/reports/report2") $
          text "Report 2"
        li $ a ! href "/login" #! onClick (Navigate "/login") $ text "Login"
        li $ a ! href "/logout" #! onClick (Navigate "/logout") $ text "Logout"
