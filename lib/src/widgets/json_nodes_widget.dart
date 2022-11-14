// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:cr_json_widget/src/controllers/json_controller.dart';
import 'package:cr_json_widget/src/models/json_node.dart';
import 'package:cr_json_widget/src/widgets/json_node_widget.dart';
import 'package:flutter/material.dart';

/// Builds set of [jsonNodes] respecting [state], [indent] and [_iconSize].
class JsonNodesWidget extends StatelessWidget {
  const JsonNodesWidget({
    required this.jsonNodes,
    required this.state,
    required this.indentLeftEndJsonNode,
    required this.indentWidth,
    required this.indentHeight,
    required this.underTree,
    this.isDefaultExpanded = false,
    this.iconOpened,
    this.iconClosed,
    Key? key,
  }) : super(key: key);

  final Iterable<JsonNode> jsonNodes;
  final JsonController state;
  final double indentLeftEndJsonNode;
  final double indentWidth;
  final double indentHeight;
  final int underTree;
  final bool isDefaultExpanded;
  final Widget? iconOpened;
  final Widget? iconClosed;

  @override
  Widget build(BuildContext context) {
    if (underTree <= state.uncovered) {
      for (final jsonNode in jsonNodes) {
        if (state.isHasExpanded(jsonNode.key!) == null) {
          state.expandJsonNode(jsonNode.key!);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var jsonNode in jsonNodes)
          JsonNodeWidget(
            jsonNode: jsonNode,
            state: state,
            indentLeftEndNode: indentLeftEndJsonNode,
            indentWidth: indentWidth,
            indentHeight: indentHeight,
            iconOpened: iconOpened,
            iconClosed: iconClosed,
            underTree: underTree + 1,
          ),
      ],
    );
  }
}
