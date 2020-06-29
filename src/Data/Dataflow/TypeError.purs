module Lunarbox.Data.Dataflow.TypeError
  ( TypeError(..)
  , getLocation
  , printError
  ) where

import Prelude
import Data.List (List)
import Data.String (joinWith)
import Lunarbox.Data.Dataflow.Expression (VarName)
import Lunarbox.Data.Dataflow.Type (TVarName, Type)
import Lunarbox.Data.String (indent)

-- Type for all type errors
-- At the moment there are 4 possible type errors:
-- 1) Trying to use a type t1 when a type t2 is expected => TypeMissmatch
-- 2) Trying to use a function where a type is expected => DifferentLength
-- 3) Using a type which contains itself => RecursiveType
-- 4) Trying to access a variable which isn't in scope => UnboundVariable
-- All the errors hold a "l" argument which represents the location where the error occured
data TypeError l
  = TypeMissmatch Type Type l
  | DifferentLength (List Type) (List Type) l
  | RecursiveType TVarName Type l
  | UnboundVariable VarName l
  | Stacked (TypeError l) l

-- | Get the location an error occured at
getLocation :: forall l. TypeError l -> l
getLocation (TypeMissmatch _ _ l) = l

getLocation (DifferentLength _ _ l) = l

getLocation (RecursiveType _ _ l) = l

getLocation (UnboundVariable _ l) = l

getLocation (Stacked _ l) = l

-- -- | Print an error with a custom function for printing the locations.
-- printError :: forall l. (l -> String) -> TypeError l -> String
-- printError showLocation err = printError' showLocaion err
-- | Internal version of printError which also takes an ar
printError :: forall l. (l -> String) -> TypeError l -> String
printError showLocation err =
  joinWith "\n"
    [ showLocation (getLocation err) <> ":"
    , indent 4 $ go err
    ]
  where
  go (TypeMissmatch t1 t2 _) = "Could not match type " <> show t1 <> " with type " <> show t2

  go (DifferentLength t1 t2 _) = "Could not match types " <> show t1 <> " with types " <> show t2 <> " because the lengths are different"

  go (RecursiveType v t _) = "Type " <> show t <> " contains a reference to itself"

  go (UnboundVariable v _) = "Variable " <> show v <> " is not in scope"

  go (Stacked inner _) = printError showLocation inner
