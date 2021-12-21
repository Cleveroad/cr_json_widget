import 'package:cr_json_widget/cr_json_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final json = <String, dynamic>{
    'squadName': 'Super hero squad',
    'homeTown': 'Metro City',
    'formed': 2016,
    'secretBase': 'Super tower',
    'active': true,
    'members': [
      <String, dynamic>{
        'name': 'Molecule Man',
        'age': 29,
        'secretIdentity': 'Dan Jukes',
        'powers': [
          'Radiation resistance',
          'Turning tiny',
          'Radiation blast',
        ],
      },
      <String, dynamic>{
        'name': 'Madame Uppercut',
        'age': 39,
        'secretIdentity': 'Jane Wilson',
        'powers': [
          'Million tonne punch',
          'Damage resistance',
          'Superhuman reflexes',
        ],
      },
      <String, dynamic>{
        'name': 'Eternal Flame',
        'age': 1000.00,
        'secretIdentity': 'Unknown',
        'powers': [
          'Immortality',
          'Heat Immunity',
          'Inferno',
          'Teleportation',
          'Interdimensional travel',
        ],
      },
    ],
  };

  final _jsonTemplateOneController = JsonController(
    allNodesExpanded: false,
    uncovered: 1,
  );

  final _jsonTemplateTwoController = JsonController(
    allNodesExpanded: false,
    uncovered: 0,
  );

  @override
  Widget build(BuildContext context) {
    const iconSize = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRJsonWidget Example'),
        actions: [
          IconButton(
            onPressed: _expandAllNodes,
            icon: const Icon(Icons.expand),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Json template #1',
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
              'Json template #2',
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
