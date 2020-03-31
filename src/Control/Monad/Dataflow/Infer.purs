module Lunarbox.Control.Monad.Dataflow.Infer
  ( InferState(..)
  , InferEnv(..)
  , Infer(..)
  , _count
  , _location
  , _typeEnv
  , runInfer
  , withLocation
  ) where

import Prelude
import Control.Monad.Error.Class (class MonadThrow)
import Control.Monad.Except (Except, runExcept)
import Control.Monad.RWS (RWST, evalRWST, local)
import Control.Monad.Reader (class MonadAsk, class MonadReader)
import Control.Monad.State (class MonadState)
import Control.Monad.Writer (class MonadTell, class MonadWriter)
import Data.Either (Either)
import Data.Lens (Lens', iso, set)
import Data.Lens.Record (prop)
import Data.Newtype (class Newtype, unwrap, wrap)
import Data.Symbol (SProxy(..))
import Data.Tuple (Tuple)
import Lunarbox.Data.Dataflow.Constraint (ConstraintSet)
import Lunarbox.Data.Dataflow.TypeError (TypeError)
import Lunarbox.Data.Dataflow.TypeEnv (TypeEnv)

newtype InferState
  = InferState
  { count :: Int
  }

derive instance newtypeInferState :: Newtype InferState _

instance semigruopInferState :: Semigroup InferState where
  append (InferState { count }) (InferState { count: count' }) = InferState { count: count + count' }

instance monoidInferState :: Monoid InferState where
  mempty = InferState { count: 0 }

_count :: Lens' InferState Int
_count = iso unwrap wrap <<< prop (SProxy :: _ "count")

newtype InferEnv l
  = InferEnv
  { typeEnv :: TypeEnv
  , location :: l
  }

derive instance newtypeInferEnv :: Newtype (InferEnv l) _

_typeEnv :: forall l. Lens' (InferEnv l) TypeEnv
_typeEnv = iso unwrap wrap <<< prop (SProxy :: _ "typeEnv")

_location :: forall l. Lens' (InferEnv l) l
_location = iso unwrap wrap <<< prop (SProxy :: _ "location")

newtype Infer l a
  = Infer (RWST (InferEnv l) (ConstraintSet l) InferState (Except (TypeError l)) a)

runInfer :: forall l a. InferEnv l -> Infer l a -> Either (TypeError l) (Tuple a (ConstraintSet l))
runInfer env (Infer m) = result
  where
  result = runExcept $ evalRWST m env mempty

-- run a monad in a specific location
withLocation :: forall a l. l -> Infer l a -> Infer l a
withLocation = local <<< set _location

derive newtype instance functorInfer :: Functor (Infer l)

derive newtype instance applyInfer :: Apply (Infer l)

derive newtype instance applicativeInfer :: Applicative (Infer l)

derive newtype instance bindInfer :: Bind (Infer l)

derive newtype instance monadInfer :: Monad (Infer l)

derive newtype instance monadAskInfer :: MonadAsk (InferEnv l) (Infer l)

derive newtype instance monadReaderInfer :: MonadReader (InferEnv l) (Infer l)

derive newtype instance monadTellInfer :: MonadTell (ConstraintSet l) (Infer l)

derive newtype instance monadWriterInfer :: MonadWriter (ConstraintSet l) (Infer l)

derive newtype instance monadStateInfer :: MonadState InferState (Infer l)

derive newtype instance monadThrowInfer :: MonadThrow (TypeError l) (Infer l)
