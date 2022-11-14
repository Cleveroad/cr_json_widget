import 'package:cr_json_widget/cr_json_widget.dart';
import 'package:cr_json_wiget_example/json.dart';
import 'package:cr_json_wiget_example/main.dart';
import 'package:flutter/material.dart';

class CrJsonPage extends StatefulWidget {
  const CrJsonPage({Key? key}) : super(key: key);

  @override
  State<CrJsonPage> createState() => _CrJsonPageState();
}

class _CrJsonPageState extends State<CrJsonPage> {
  final _expandedNodesCtr = ExpandNodesController.instance;
  late final _jsonTemplateOneController = JsonController(
    allNodesExpanded: _expandedNodesCtr.isExpanded,
    uncovered: 1,
  );

  late final _jsonTemplateTwoController = JsonController(
    allNodesExpanded: _expandedNodesCtr.isExpanded,
    uncovered: 0,
  );

  @override
  void initState() {
    super.initState();
    _expandedNodesCtr.addListener(_expandAllNodes);
  }

  @override
  void dispose() {
    _expandedNodesCtr.removeListener(_expandAllNodes);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 20.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Simple Json template',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          CrJsonWidget(
            jsonController: _jsonTemplateOneController,
            json: json,
            iconOpened: const Icon(
              Icons.arrow_drop_down,
              size: iconSize,
            ),
            iconClosed: const Icon(
              Icons.arrow_right,
              size: iconSize,
            ),
            indentHeight: 5,
            indentLeftEndJsonNode: iconSize,
          ),
          const Text(
            'Json template with custom JsonNodes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          CrJsonWidget(
            jsonController: _jsonTemplateTwoController,
            iconOpened: const Icon(
              Icons.arrow_drop_down,
              size: iconSize,
            ),
            iconClosed: const Icon(
              Icons.arrow_right,
              size: iconSize,
            ),
            indentHeight: 5,
            indentLeftEndJsonNode: iconSize,
            jsonNodes: [
              JsonNode(
                content: const Text(
                  'root1',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              JsonNode(
                content: const Text(
                  'root2',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                children: [
                  JsonNode(
                    content: const Text('child21'),
                  ),
                  JsonNode(
                    content: const Text('child22'),
                  ),
                  JsonNode(
                    content: const Text('root23'),
                    children: [
                      JsonNode(
                        content: const Text('child231'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _expandAllNodes() {
    setState(() {
      _jsonTemplateOneController.allNodesExpanded =
          !_jsonTemplateOneController.allNodesExpanded;

      if (_jsonTemplateTwoController.allNodesExpanded) {
        _jsonTemplateTwoController.collapseAll();
      } else {
        _jsonTemplateTwoController.expandAll();
      }
    });
  }
}
