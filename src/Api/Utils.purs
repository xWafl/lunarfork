module Lunarbox.Api.Utils
  ( authenticate
  , mkRequest
  , withBaseUrl
  , logErrors
  ) where

import Prelude
import Control.Monad.Reader (class MonadAsk, asks)
import Data.Argonaut (class DecodeJson, decodeJson)
import Data.Either (Either(..))
import Data.Lens (view)
import Data.Maybe (Maybe(..))
import Effect.Aff.Bus as Bus
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Ref as Ref
import Lunarbox.Api.Request (BaseUrl, RequestOptions, requestJson)
import Lunarbox.Config (Config, _baseUrl, _user)
import Lunarbox.Control.Monad.Effect (print, printString)
import Lunarbox.Data.Profile (Profile)

-- Log the error from an Either
logErrors :: forall b r m. MonadEffect m => Either String b -> (b -> m r) -> m r -> m r
logErrors input binder default = case input of
  Right result -> binder result
  Left error -> printString error *> default

-- Helper to make a request with the baseUrl from the reader monad
mkRequest ::
  forall m b.
  DecodeJson b =>
  MonadAff m =>
  MonadAsk Config m =>
  RequestOptions ->
  m (Maybe b)
mkRequest options = do
  baseUrl <- asks $ view _baseUrl
  response <- requestJson baseUrl options
  logErrors (response >>= decodeJson) (pure <<< Just) $ pure Nothing

-- Perform a function with the current url from the global config
withBaseUrl ::
  forall m b.
  DecodeJson b =>
  MonadAff m =>
  MonadAsk Config m =>
  (BaseUrl -> m (Either String b)) ->
  m (Maybe b)
withBaseUrl req = do
  baseUrl <- asks $ view _baseUrl
  response <- req baseUrl
  logErrors response (pure <<< Just) $ pure Nothing

-- Helper to creating functions which request something which return a profile
authenticate ::
  forall m a.
  MonadAff m =>
  MonadAsk Config m =>
  (BaseUrl -> a -> m (Either String Profile)) ->
  a ->
  m (Either String Profile)
authenticate req fields = do
  { currentUser, userBus } <- asks $ view _user
  baseUrl <- asks $ view _baseUrl
  req baseUrl fields
    >>= case _ of
        Left error -> printString error *> pure (Left error)
        Right profile -> do
          print profile
          liftEffect $ Ref.write (Just profile) currentUser
          --   any time we write to the current user ref, we should also broadcast the change
          liftAff $ Bus.write (Just profile) userBus
          pure (Right profile)
