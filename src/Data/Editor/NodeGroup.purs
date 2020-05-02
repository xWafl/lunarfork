module Lunarbox.Data.Editor.NodeGroup
  ( NodeGroup(..)
  , orderNodes
  , compileNodeGroup
  , _NodeGroupInputs
  , _NodeGroupOutput
  , _NodeGroupNodes
  ) where

import Prelude
import Data.Argonaut (class DecodeJson, class EncodeJson)
import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Data.List (List, foldr, (:), (\\))
import Data.Newtype (class Newtype, unwrap)
import Data.Symbol (SProxy(..))
import Lunarbox.Data.Dataflow.Expression (Expression, VarName(..), functionDeclaration)
import Lunarbox.Data.Editor.ExtendedLocation (ExtendedLocation(..), nothing)
import Lunarbox.Data.Editor.Node (Node, compileNode)
import Lunarbox.Data.Editor.Node.NodeId (NodeId)
import Lunarbox.Data.Editor.Node.PinLocation (NodeOrPinLocation)
import Lunarbox.Data.Graph (Graph, topologicalSort)
import Lunarbox.Data.Lens (newtypeIso)

-- Represents a graph of nodes
newtype NodeGroup
  = NodeGroup
  { inputs :: List NodeId
  , nodes :: Graph NodeId Node
  , output :: NodeId
  }

derive instance newtypeNodeGroup :: Newtype NodeGroup _

derive newtype instance showNodeGroup :: Show NodeGroup

derive newtype instance encodeJsonNodeGroup :: EncodeJson NodeGroup

derive newtype instance decodeJsonNodeGroup :: DecodeJson NodeGroup

-- Take a graph of nodes and return a list of nodes sorted in topological order
orderNodes :: NodeGroup -> List NodeId
orderNodes (NodeGroup function) = topologicalSort function.nodes

compileNodeGroup :: NodeGroup -> Expression NodeOrPinLocation
compileNodeGroup group@(NodeGroup { nodes, output, inputs }) =
  let
    ordered = orderNodes group

    bodyNodes = (ordered \\ (output : inputs)) <> pure output

    return =
      foldr
        (compileNode nodes)
        nothing
        bodyNodes
  in
    functionDeclaration Nowhere return $ VarName <$> unwrap <$> inputs

-- Prism
_NodeGroupInputs :: Lens' NodeGroup (List NodeId)
_NodeGroupInputs = newtypeIso <<< prop (SProxy :: _ "inputs")

_NodeGroupNodes :: Lens' NodeGroup (Graph NodeId Node)
_NodeGroupNodes = newtypeIso <<< prop (SProxy :: _ "nodes")

_NodeGroupOutput :: Lens' NodeGroup NodeId
_NodeGroupOutput = newtypeIso <<< prop (SProxy :: _ "output")