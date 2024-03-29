import 'package:cr_json_widget/res/cr_json_color.dart';
import 'package:cr_json_widget/src/utils/copy_clipboard.dart';
import 'package:cr_json_widget/src/utils/json_utils.dart';
import 'package:flutter/material.dart';

class JsonNodeContent extends StatelessWidget {
  const JsonNodeContent({
    required this.keyValue,
    this.value,
    Key? key,
  }) : super(key: key);

  final String keyValue;
  final Object? value;

  @override
  Widget build(BuildContext context) {
    var valueText = '';

    /// If the value is a List, print its type and cardinality
    /// (example: Array<int>[10])
    if (value is List) {
      final listNode = value as List;
      valueText = listNode.isEmpty
          ? 'Array[0]'
          : 'Array<${_getTypeName(listNode[0])}>[${listNode.length}]';

      /// If the type is map, output - Object
    } else if (value is Map) {
      valueText = 'Object';
    } else {
      valueText = value is String ? '"$value"' : value.toString();
    }

    return GestureDetector(
      onLongPress: () => _onLongPress(context),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: keyValue,
              style: const TextStyle(
                color: CrJsonColors.jsonTreeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: valueText,
              style: TextStyle(
                color: _getTypeColor(value),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(Object? content) {
    if (content is int) {
      return CrJsonColors.intColor;
    } else if (content is String) {
      return CrJsonColors.stringColor;
    } else if (content is bool) {
      return CrJsonColors.boolColor;
    } else if (content is double) {
      return CrJsonColors.doubleColor;
    } else {
      return CrJsonColors.nullColor;
    }
  }

  String _getTypeName(content) {
    if (content is int) {
      return 'int';
    } else if (content is String) {
      return 'String';
    } else if (content is bool) {
      return 'bool';
    } else if (content is double) {
      return 'double';
    } else if (content is List) {
      return 'List';
    }

    return 'Object';
  }

  void _onLongPress(BuildContext context) {
    copyClipboard(
      context,
      value is Map<String, dynamic> ? toJson(value) : value.toString(),
      selectValueColor: _getTypeColor(value),
    );
  }
}
