module App.View.Reports where

import App.Events (Event(..))
import App.State (State(..))
import Control.Bind (discard)
import Data.Semigroup ((<>))
import Data.Show (show)
import Control.Error.Util (bool)
import Data.Function (($))
import Pux.DOM.HTML (HTML)
import Pux.DOM.Events (onClick)
import Text.Smolder.HTML (button
                        , h2
                        , h5
                        , p
                        , a
                        , div
                        , h1
                        , br
                        , label
                        , input
                        , select
                        , option)
import Text.Smolder.HTML.Attributes (for, style, href, className, id, name, autocomplete, type', value, selected)
import Text.Smolder.Markup ((!), (#!), text, attribute)

view :: State -> HTML Event
view (State st) =
  div ! className "container" ! attribute "style" "margin-top: 3.5rem;" $ do
     h1 $ text "Reports"
     div ! className "row h-100" $ do
        div ! className "col-sm my-auto" $ do
          h2 $ text "Options"
          div ! className "form-group" $ do
            label ! for "report" $ text "Report"
            select ! className "form-control" ! name "report" ! id "report" $ do
               option ! value "report1" $ text "Report 1"
               option ! value "report2" $ text "Report 2"
          div ! className "form-group" $ do
            label ! for "year" $ text "Year"
            select ! className "form-control" ! name "year" ! id "year" $ do
               option ! value "2014" $ text "2014"
               option ! value "2015" $ text "2015"
               option ! value "2016" $ text "2016"
               option ! value "2017" $ text "2017"
               option ! value "2018" ! selected "selected" $ text "2018"
          div ! className "form-group" $ do
            label ! for "month" $ text "Month"
            select ! className "form-control" ! name "mes" ! id "mes" $ do
               option ! value "1" $ text "January"
               option ! value "2" $ text "February"
               option ! value "3" $ text "March"
               option ! value "4" $ text "April"
               option ! value "5" $ text "May"
               option ! value "6" $ text "June"
               option ! value "7" $ text "July"
               option ! value "8" $ text "August"
               option ! value "9" $ text "September"
               option ! value "10" $ text "October"
               option ! value "11" $ text "November"
               option ! value "12" $ text "December"
          div ! className "form-group" $ do
             button ! className "btn btn-primary" #! onClick Generate $ text "Generate"
        div ! className "col-sm" $ do
           h2 $ text "Download"
           div ! className downloadErrorClass ! attribute "role" "alert" $ do
             text "Download error. Try again later."
           div ! className ("card " <> (bool "d-none" "" st.downloaded)) ! attribute "style" "width: 18rem;" $ do
              div ! className "card-body" $ do
                 h5 $ text st.report
                 p ! className "card-text" $ text (show st.month <> "/" <> show st.year)
                 a ! href "#"
                   ! className "card-link"
                   ! attribute "download" ""$ text "Download"
  where
    downloadErrorClass = "alert alert " <> (bool "d-none" "" st.downloadError)
