// Copyright 2020 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:cr_json_widget/src/models/json_node.dart';
import 'package:cr_json_widget/src/providers/key_provider.dart';

/// Copies nodes to unmodifiable list, assigning missing keys and checking for duplicates.
List<JsonNode> copyJsonNodes(List<JsonNode>? jsonNodes) {
  return _copyJsonNodesRecursively(jsonNodes, KeyProvider())!;
}

List<JsonNode>? _copyJsonNodesRecursively(
  List<JsonNode>? jsonNodes,
  KeyProvider keyProvider,
) {
  if (jsonNodes == null) {
    return null;
  }

  return List.unmodifiable(jsonNodes.map((n) {
    return JsonNode(
      key: keyProvider.key(n.key),
      content: n.content,
      children: _copyJsonNodesRecursively(n.children, keyProvider),
    );
  }));
}
