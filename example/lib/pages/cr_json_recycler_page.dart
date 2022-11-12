import 'package:cr_json_widget/cr_json_recycler.dart';
import 'package:cr_json_wiget_example/json.dart';
import 'package:cr_json_wiget_example/main.dart';
import 'package:flutter/material.dart';

class CrJsonRecyclerPage extends StatefulWidget {
  const CrJsonRecyclerPage({Key? key}) : super(key: key);

  @override
  State<CrJsonRecyclerPage> createState() => _CrJsonRecyclerPageState();
}

class _CrJsonRecyclerPageState extends State<CrJsonRecyclerPage> {
  final _expandedNodesCtr = ExpandNodesController.instance;
  late final _jsonController1 = JsonRecyclerController(
    saveClosedHistory: true,
    showStandardJson: false,
    isExpanded: _expandedNodesCtr.isExpanded,
  );

  @override
  void initState() {
    super.initState();
    _expandedNodesCtr.addListener(_expandNodes);
  }

  @override
  void dispose() {
    _expandedNodesCtr.removeListener(_expandNodes);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Simple Json template with CrJsonRecyclerWidget',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Expanded(
                child: CrJsonRecyclerWidget(
                  json: json,
                  jsonController: _jsonController1,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Simple Json template with CrJsonRecyclerSliver',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomScrollView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                CrJsonRecyclerSliver(
                  jsonController: _jsonController1,
                  json: json,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _expandNodes() => setState(() {
        _jsonController1.isExpanded = !_jsonController1.isExpanded;
      });
}
