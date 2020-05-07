module Lunarbox.Data.Dataflow.Native.Math
  ( mathNodes
  ) where

import Prelude
import Data.Maybe (Maybe(..))
import Lunarbox.Data.Dataflow.Expression (NativeExpression(..))
import Lunarbox.Data.Dataflow.Native.NativeConfig (NativeConfig(..))
import Lunarbox.Data.Dataflow.Runtime (RuntimeValue(..), binaryFunction)
import Lunarbox.Data.Dataflow.Scheme (Scheme(..))
import Lunarbox.Data.Dataflow.Type (typeFunction, typeNumber)
import Lunarbox.Data.Editor.FunctionData (internal)
import Lunarbox.Data.Editor.FunctionName (FunctionName(..))
import Math (pow, (%))

-- ALl the math native nodes
mathNodes :: forall a s m. Array (NativeConfig a s m)
mathNodes = [ add, substract, multiply, divide, raiseToPower, modulus ]

-- Type for functions of type Number -> Number -> Number
binaryNumberType :: Scheme
binaryNumberType = Forall [] $ typeFunction typeNumber $ typeFunction typeNumber typeNumber

-- Internal function used to perform the unwrapping and wrapping necessary for the binaryMathFUnction helper
binaryMathFunction' :: (Number -> Number -> Number) -> RuntimeValue -> RuntimeValue -> RuntimeValue
binaryMathFunction' function (Number first) (Number second) = Number $ function first second

binaryMathFunction' _ _ _ = Null

-- Helper for wrapping a purescript binary math operator into a runtime value
binaryMathFunction :: (Number -> Number -> Number) -> RuntimeValue
binaryMathFunction = binaryFunction <<< binaryMathFunction'

-- The actual math functions
add :: forall a s m. NativeConfig a s m
add =
  NativeConfig
    { name: FunctionName "add"
    , expression: (NativeExpression binaryNumberType $ binaryMathFunction (+))
    , functionData: internal [ { name: "first number" }, { name: "second number" } ] { name: "sum" }
    , component: Nothing
    }

substract :: forall a s m. NativeConfig a s m
substract =
  NativeConfig
    { name: FunctionName "substract"
    , expression: (NativeExpression binaryNumberType $ binaryMathFunction (-))
    , functionData: internal [ { name: "first number" }, { name: "second number" } ] { name: "difference" }
    , component: Nothing
    }

multiply :: forall a s m. NativeConfig a s m
multiply =
  NativeConfig
    { name: FunctionName "multiply"
    , expression: (NativeExpression binaryNumberType $ binaryMathFunction (*))
    , functionData: internal [ { name: "first number" }, { name: "second number" } ] { name: "product" }
    , component: Nothing
    }

divide :: forall a s m. NativeConfig a s m
divide =
  NativeConfig
    { name: FunctionName "divide"
    , expression: (NativeExpression binaryNumberType $ binaryMathFunction (/))
    , functionData: internal [ { name: "first number" }, { name: "second number" } ] { name: "quotient" }
    , component: Nothing
    }

raiseToPower :: forall a s m. NativeConfig a s m
raiseToPower =
  NativeConfig
    { name: FunctionName "raise to power"
    , expression: (NativeExpression binaryNumberType $ binaryMathFunction pow)
    , functionData: internal [ { name: "base" }, { name: "exponend" } ] { name: "base^exponent" }
    , component: Nothing
    }

modulus :: forall a s m. NativeConfig a s m
modulus =
  NativeConfig
    { name: FunctionName "modulus"
    , expression: (NativeExpression binaryNumberType $ binaryMathFunction (%))
    , functionData: internal [ { name: "left side" }, { name: "right side" } ] { name: "a % b" }
    , component: Nothing
    }
