import 'package:cr_json_widget/cr_json_recycler.dart';
import 'package:cr_json_widget/src/widgets/base/base_recycler_page_state.dart';
import 'package:cr_json_widget/src/widgets/item_recycler_widget.dart';
import 'package:flutter/material.dart';

class CrJsonRecyclerSliver extends StatefulWidget {
  const CrJsonRecyclerSliver({
    required this.jsonController,
    required this.json,
    Key? key,
  }) : super(key: key);

  final JsonRecyclerController jsonController;
  final dynamic json;

  @override
  State<CrJsonRecyclerSliver> createState() => _CrJsonRecyclerSliverState();
}

class _CrJsonRecyclerSliverState
    extends BaseRecyclerPageState<CrJsonRecyclerSliver> {
  @override
  late dynamic json = widget.json;

  @override
  late JsonRecyclerController jsonController = widget.jsonController;

  @override
  Widget bodyWidget(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final indexWithShift = jsonList[index].shiftIndex;
          final jsonElement = jsonList[indexWithShift];
          return ItemRecyclerWidget(
            jsonList: widget.json,
            jsonController: widget.jsonController,
            jsonElement: jsonElement,
            callback: () => rememberIndexOfParent(
              indexWithShift,
              index,
            ),
          );
        },
        childCount: jsonListLength,
      ),
    );
  }
}
