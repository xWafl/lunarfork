{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "lunarbox"
, dependencies =
  [ "aff"
  , "aff-bus"
  , "affjax"
  , "argonaut"
  , "argonaut-generic"
  , "arrays"
  , "colehaus-graphs"
  , "console"
  , "css"
  , "data-default"
  , "debug"
  , "effect"
  , "filterable"
  , "generics-rep"
  , "halogen"
  , "halogen-css"
  , "halogen-formless"
  , "halogen-svg"
  , "halogen-vdom"
  , "lists"
  , "math"
  , "maybe"
  , "memoize"
  , "numbers"
  , "ordered-collections"
  , "profunctor-lenses"
  , "psci-support"
  , "random"
  , "record"
  , "routing"
  , "routing-duplex"
  , "sized-vectors"
  , "spec"
  , "stringutils"
  , "tuples"
  , "typelevel"
  , "typelevel-prelude"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}