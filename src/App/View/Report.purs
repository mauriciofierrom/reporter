module App.View.Report where

import App.Events (Event)
import App.State (State)
import Control.Bind (discard)
import Data.Function (($))
import Pux.DOM.HTML (HTML)
import Text.Smolder.HTML (a, div, h1)
import Text.Smolder.HTML.Attributes (href, className)
import Text.Smolder.Markup ((!), text)

view :: State -> HTML Event
view s =
  div ! className "container" $ do
     h1 $ text "Report"
