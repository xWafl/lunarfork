module Lunarbox.Component.Editor.Add
  ( add
  ) where

import Prelude
import Control.MonadZero (guard)
import Data.Default (def)
import Data.Either (either)
import Data.List ((!!))
import Data.Map as Map
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple(..))
import Halogen (ClassName(..))
import Halogen.HTML (HTML)
import Halogen.HTML as HH
import Halogen.HTML.Events (onClick)
import Halogen.HTML.Properties as HP
import Lunarbox.Capability.Editor.Type (generateTypeMap)
import Lunarbox.Component.Editor.Node (node)
import Lunarbox.Component.Editor.Node as NodeC
import Lunarbox.Component.Icon (icon)
import Lunarbox.Component.Utils (className, container)
import Lunarbox.Data.Dataflow.Type (Type, inputs, output)
import Lunarbox.Data.Editor.Constants (arcWidth, nodeRadius)
import Lunarbox.Data.Editor.ExtendedLocation (ExtendedLocation(..))
import Lunarbox.Data.Editor.FunctionData (FunctionData)
import Lunarbox.Data.Editor.FunctionName (FunctionName)
import Lunarbox.Data.Editor.Location (Location)
import Lunarbox.Data.Editor.Node (Node(..))
import Lunarbox.Data.Editor.Node.NodeDescriptor (NodeDescriptor, describe)
import Lunarbox.Data.Editor.Node.PinLocation (Pin(..))
import Lunarbox.Data.Editor.Project (Project)
import Svg.Attributes as SA
import Svg.Elements as SE

type Input
  = { project :: Project
    , currentFunction :: Maybe FunctionName
    , functionData :: Map.Map FunctionName FunctionData
    , typeMap :: Map.Map Location Type
    }

type Actions a
  = { edit :: FunctionName -> Maybe a
    , addNode :: FunctionName -> Maybe a
    }

resolvePin :: Pin -> Type -> Maybe Type
resolvePin (InputPin index) type' = inputs type' !! index

resolvePin OutputPin type' = Just $ output type'

nodeInput :: Map.Map Location Type -> FunctionName -> FunctionData -> NodeC.Input
nodeInput typeMap name functionData =
  { nodeData: def
  , node
  , functionData
  , labels: mempty
  , hasOutput: false
  , colorMap:
    either (const mempty) identity
      $ generateTypeMap
          (\pin -> Map.lookup (Location name) typeMap >>= resolvePin pin)
          functionData
          node
  }
  where
  node = ComplexNode { inputs: mempty, function: name }

makeNode :: forall h a. Actions a -> NodeDescriptor -> FunctionName -> Map.Map Location Type -> FunctionData -> HTML h a
makeNode { edit, addNode } { isUsable, isEditable } name typeMap functionData =
  HH.div [ className "node" ]
    [ SE.svg
        [ SA.width 75.0
        , SA.height 75.0
        , let size = arcWidth + nodeRadius in SA.viewBox (-size) (-size) (2.0 * size) (2.0 * size)
        ]
        [ node
            (nodeInput typeMap name functionData)
            { select: Nothing }
        ]
    , container "node-data"
        [ container "node-text"
            [ container "node-name"
                [ HH.text $ show name
                ]
            ]
        , container "node-buttons"
            [ HH.div
                [ HP.classes $ ClassName <$> ("active" <$ guard isUsable)
                , onClick $ const if isUsable then addNode name else Nothing
                ]
                [ icon "add" ]
            , HH.div
                [ HP.classes $ ClassName <$> ("active" <$ guard isEditable)
                , onClick $ const if isEditable then edit name else Nothing
                ]
                [ icon "edit" ]
            ]
        ]
    ]

add :: forall h a. Input -> Actions a -> HTML h a
add { project, currentFunction, functionData, typeMap } actions =
  container "nodes"
    $ ( \(Tuple name descriptor) ->
          let
            functionData' = fromMaybe def $ Map.lookup name functionData
          in
            makeNode actions descriptor name typeMap functionData'
      )
    <$> ( Map.toUnfoldable
          $ describe currentFunction project
      )
