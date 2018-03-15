module App.Routes where

import Control.Alt ((<|>))
import Control.Apply ((<*), (*>))
import Data.Semigroup((<>))
import Data.Function (($))
import Data.Functor ((<$), (<$>))
import Data.Maybe (fromMaybe)
import Pux.Router (end, router, lit, str)

data Route = Home | Reports | Report String | Login | Logout | NotFound String

match :: String -> Route
match url = fromMaybe (NotFound url) $ router url $
  Report <$> (lit "reports" *> str) <* end
  <|>
  Reports <$ (lit "reports") <* end
  <|>
  Login <$ (lit "login") <* end
  <|>
  Logout <$ (lit "logout") <* end
  <|>
  Home <$ end

toURL :: Route -> String
toURL Home = "/"
toURL (Report url) = "reports" <> url
toURL Login = "/login"
toURL Logout = "/logout"
toURL (NotFound url) = url
toURL Reports = "/reports"
