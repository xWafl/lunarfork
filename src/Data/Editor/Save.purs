module Lunarbox.Data.Editor.Save
  ( StatePermanentData
  , stateToJson
  , jsonToState
  ) where

import Prelude
import Data.Argonaut (Json, decodeJson, encodeJson, (.:))
import Data.Either (Either)
import Data.Map (Map)
import Data.Tuple (Tuple)
import Lunarbox.Data.Dataflow.Native.Prelude (loadPrelude)
import Lunarbox.Data.Dataflow.Runtime.ValueMap (ValueMap)
import Lunarbox.Data.Editor.Camera (Camera)
import Lunarbox.Data.Editor.FunctionName (FunctionName)
import Lunarbox.Data.Editor.Location (Location)
import Lunarbox.Data.Editor.Node.NodeData (NodeData)
import Lunarbox.Data.Editor.Node.NodeId (NodeId)
import Lunarbox.Data.Editor.Project (Project)
import Lunarbox.Data.Editor.State (State, compile, emptyState, nodeCount, visualFunctionCount)
import Lunarbox.Data.ProjectList (ProjectData)
import Record as Record

type StatePermanentData
  = { project :: Project
    , nextId :: Int
    , nodeData :: Map (Tuple FunctionName NodeId) NodeData
    , cameras :: Map FunctionName Camera
    , runtimeOverwrites :: ValueMap Location
    }

type Save
  = { 
    | ProjectData
      ( project :: StatePermanentData
      , isExample :: Boolean
      , visible :: Boolean
      )
    }

-- Encoding and decoding
stateToJson :: forall a s m. State a s m -> Json
stateToJson state@{ project, nextId, nodeData, cameras, runtimeOverwrites, isExample, name, isVisible } = encodeJson save
  where
  save :: Save
  save =
    { name
    , isExample
    , visible: isVisible
    , metadata:
      { nodeCount: nodeCount state
      , functionCount: visualFunctionCount state
      }
    , project:
      { project
      , nextId
      , nodeData
      , cameras
      , runtimeOverwrites
      }
    }

jsonToState :: forall a s m. Json -> Either String (State a s m)
jsonToState json = do
  obj <- decodeJson json
  name :: String <- obj .: "name"
  isExample :: Boolean <- obj .: "isExample"
  isVisible :: Boolean <- obj .: "visible"
  saveData :: StatePermanentData <- obj .: "project"
  let
    recivedData = Record.merge { name, isExample, isVisible } saveData

    baseState :: State a s m
    baseState = Record.merge recivedData emptyState
  pure $ compile $ loadPrelude baseState
