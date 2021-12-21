// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:cr_json_widget/src/builder.dart';
import 'package:cr_json_widget/src/primitives/json_controller.dart';
import 'package:cr_json_widget/src/primitives/json_node.dart';
import 'package:flutter/material.dart';

/// Widget that displays one [JsonNode] and its children.
class JsonNodeWidget extends StatefulWidget {
  const JsonNodeWidget({
    required this.jsonNode,
    required this.state,
    required this.indentLeftEndNode,
    required this.indentWidth,
    required this.indentHeight,
    required this.underTree,
    this.iconOpened,
    this.iconClosed,
    Key? key,
  }) : super(key: key);

  final JsonNode jsonNode;
  final JsonController state;
  final double indentLeftEndNode;
  final double indentWidth;
  final double indentHeight;
  final int underTree;
  final Widget? iconOpened;
  final Widget? iconClosed;

  @override
  _JsonNodeWidgetState createState() => _JsonNodeWidgetState();
}

class _JsonNodeWidgetState extends State<JsonNodeWidget> {
  bool get _isLeaf {
    return widget.jsonNode.children == null ||
        widget.jsonNode.children!.isEmpty;
  }

  bool get _isExpanded {
    return widget.state.isJsonExpanded(widget.jsonNode.key!);
  }

  @override
  Widget build(BuildContext context) {
    /// If the node is final, it does not show the icon.
    /// Otherwise, determine which icon to display
    final icon = _isLeaf
        ? SizedBox(width: widget.indentLeftEndNode)
        : _isExpanded
            ? widget.iconOpened ?? const Icon(Icons.expand_more)
            : widget.iconClosed ?? const Icon(Icons.chevron_right);

    final onIconPressed = _isLeaf
        ? null
        : () => setState(
              () => widget.state.toggleJsonExpanded(widget.jsonNode.key!),
            );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Parent Node
        GestureDetector(
          onTap: onIconPressed,
          child: Row(
            children: [
              icon,
              Expanded(child: widget.jsonNode.content),
            ],
          ),
        ),

        SizedBox(height: widget.indentHeight),

        /// Child Node (final)
        if (_isExpanded && !_isLeaf)
          Padding(
            padding: EdgeInsets.only(left: widget.indentWidth),
            child: JsonNodesWidget(
              jsonNodes: widget.jsonNode.children!,
              state: widget.state,
              indentLeftEndJsonNode: widget.indentLeftEndNode,
              indentWidth: widget.indentWidth,
              indentHeight: widget.indentHeight,
              iconOpened: widget.iconOpened,
              iconClosed: widget.iconClosed,
              underTree: widget.underTree,
            ),
          ),
      ],
    );
  }
}
