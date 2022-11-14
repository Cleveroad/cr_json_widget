import 'package:cr_json_widget/cr_json_recycler.dart';
import 'package:cr_json_widget/src/widgets/base/base_recycler_page_state.dart';
import 'package:cr_json_widget/src/widgets/item_recycler_widget.dart';
import 'package:flutter/material.dart';

class CrJsonRecyclerWidget extends StatefulWidget {
  const CrJsonRecyclerWidget({
    required this.jsonController,
    required this.json,
    Key? key,
  }) : super(key: key);

  final JsonRecyclerController jsonController;
  final dynamic json;

  @override
  State<CrJsonRecyclerWidget> createState() => _CrJsonRecyclerWidgetState();
}

class _CrJsonRecyclerWidgetState
    extends BaseRecyclerPageState<CrJsonRecyclerWidget> {
  @override
  late dynamic json = widget.json;

  @override
  late JsonRecyclerController jsonController = widget.jsonController;

  @override
  Widget bodyWidget(BuildContext context) {
    return ListView.builder(
      itemCount: jsonListLength,
      itemBuilder: (BuildContext context, int index) {
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
    );
  }
}
