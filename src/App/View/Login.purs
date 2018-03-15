module App.View.Login where

import App.Events (Event(SignIn, UsernameChange, PasswordChange))
import App.State (State)
import Control.Bind (discard)
import Data.Function (($))
import Pux.DOM.HTML (HTML)
import Pux.DOM.Events (onSubmit, onChange)
import Text.Smolder.HTML (br, button, a, div, h1, form, img, p, input, label, link)
import Text.Smolder.HTML.Attributes (type', href, className, placeholder, width,
height, id, for, src, rel)
import Text.Smolder.Markup ((!), (#!), text)

view :: State -> HTML Event
view s = do
  link ! rel "stylesheet"
       ! href "https://getbootstrap.com/docs/4.0/examples/floating-labels/floating-labels.css"
  form ! className "form-signin" #! onSubmit SignIn $ do
     div ! className "text-center mb-4" $ do
        img ! className "mb-4" ! src "http://aux.iconpedia.net/uploads/16785340971943571304.png" ! width "72" ! height "72"
        h1 ! className "h3 mb-3 font-weight-normal" $ text "Reports"
        p $ text "Reports"

     div ! className "form-label-group" $ do
        input ! id "username"
              ! className "form-control"
              ! placeholder "Username"
              #! onChange UsernameChange
        label ! for "username" $ text "Username"

     div ! className "form-label-group" $ do
        input ! type' "password"
              ! id "password"
              ! className "form-control"
              ! placeholder "Password"
              #! onChange PasswordChange
        label ! for "password" $ text "Password"
        br
        button ! className "btn btn-lg btn-primary btn-block" ! type' "submit" $ text "Login"
