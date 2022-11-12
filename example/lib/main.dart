import 'package:cr_json_wiget_example/pages/cr_json_page.dart';
import 'package:cr_json_wiget_example/pages/cr_json_recycler_page.dart';
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
  static const _tabs = [
    Tab(
      text: 'CrJsonWidget',
      icon: Icon(Icons.create),
    ),
    Tab(
      text: 'CrJsonRecyclers',
      icon: Icon(Icons.construction),
    ),
  ];

  static const _pages = [
    CrJsonPage(),
    CrJsonRecyclerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CRJsonWidgets Example'),
          bottom: const TabBar(tabs: _tabs),
          actions: [
            IconButton(
              onPressed: ExpandNodesController.instance.expandAllNodes,
              icon: const Icon(Icons.expand),
            ),
          ],
        ),
        body: const TabBarView(
          children: _pages,
        ),
      ),
    );
  }
}

class ExpandNodesController extends ChangeNotifier {
  ExpandNodesController._();

  static final instance = ExpandNodesController._();

  bool isExpanded = false;

  void expandAllNodes() {
    isExpanded = !isExpanded;
    notifyListeners();
  }
}
