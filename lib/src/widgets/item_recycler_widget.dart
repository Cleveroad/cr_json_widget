import 'dart:convert';

import 'package:cr_json_widget/cr_json_recycler.dart';
import 'package:cr_json_widget/res/cr_json_color.dart';
import 'package:cr_json_widget/src/constant.dart';
import 'package:cr_json_widget/src/models/elements/json_element.dart';
import 'package:cr_json_widget/src/models/params/seach_object_param.dart';
import 'package:cr_json_widget/src/models/value_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemRecyclerWidget extends StatelessWidget {
  const ItemRecyclerWidget({
    required this.callback,
    required this.jsonElement,
    required this.jsonController,
    required this.jsonList,
    Key? key,
  }) : super(key: key);
  final VoidCallback callback;
  final JsonElement jsonElement;
  final JsonRecyclerController jsonController;
  final dynamic jsonList;

  @override
  Widget build(BuildContext context) {
    final isParent = jsonElement.parentRef != null;
    var depthOffset =
        jsonController.horizontalSpaceMultiplier * jsonElement.depth;

    if (!isParent && !jsonController.showStandardJson) {
      depthOffset += jsonController.additionalIndentChildElements;
    }

    return Padding(
      padding: EdgeInsets.only(left: depthOffset),
      child: InkWell(
        onTap: isParent ? callback : null,

        /// If the standard json display mode
        /// mark in color the parent elements
        child: Container(
          decoration: BoxDecoration(
            gradient: jsonController.showStandardJson && isParent
                ? LinearGradient(
                    colors: <Color>[
                      jsonController.standardJsonBackgroundColor,
                      jsonController.standardJsonBackgroundColor
                          .withOpacity(0.1),
                      jsonController.standardJsonBackgroundColor
                          .withOpacity(0.1),
                    ],
                  )
                : null,
          ),
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: jsonController.verticalOffset),
            child: Row(
              children: [
                /// Show icon only if not standard mode
                /// display json
                if (!jsonController.showStandardJson && isParent)
                  jsonElement.parentRef?.isClosed == true
                      ? jsonController.iconClosed
                      : jsonController.iconOpened,
                Expanded(
                  child: GestureDetector(
                    onLongPress: () => _onLongPress(context),
                    child: jsonElement.valueType != ValueType.hidden
                        ? RichText(
                            text: TextSpan(
                              children: [
                                /// Key value
                                TextSpan(
                                  text: jsonElement.keyValue,
                                  style: TextStyle(
                                    color: jsonController.jsonKeyColor,
                                    fontWeight: jsonController.fontWeight,
                                    fontStyle: jsonController.fontStyle,
                                  ),
                                ),

                                /// Value
                                TextSpan(
                                  text: jsonElement.value,
                                  style: TextStyle(
                                    color: _getColor(jsonElement.valueType),
                                    fontWeight: jsonController.fontWeight,
                                    fontStyle: jsonController.fontStyle,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Row(
                            children: [
                              Text(
                                jsonElement.keyValue,
                                style: TextStyle(
                                  color: jsonController.jsonKeyColor,
                                  fontWeight: jsonController.fontWeight,
                                  fontStyle: jsonController.fontStyle,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: CrJsonColors.hiddenContainerColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                child: const Text(
                                  kHidden,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(ValueType type) {
    switch (type) {
      case ValueType.int:
        return jsonController.intColor;
      case ValueType.double:
        return jsonController.doubleColor;
      case ValueType.string:
        return jsonController.stringColor;
      case ValueType.nil:
        return jsonController.nullColor;
      case ValueType.bool:
        return jsonController.boolColor;
      case ValueType.object:
        return jsonController.objectColor;
      case ValueType.hidden:
        return jsonController.stringColor;
    }
  }

  /// Copying an item to the buffer
  void _onLongPress(BuildContext context) {
    var copyValue = '';
    final nChildren = jsonElement.parentRef?.nChildren;

    /// If a parent is copied, find and copy its children
    if (nChildren != null) {
      final foundObject = _findObject(
        jsonList,
        SearchObjectParam()..targetIndex = jsonElement.index,
      );

      if (foundObject is Map) {
        copyValue = const JsonEncoder.withIndent('  ').convert(foundObject);
      } else {
        copyValue = foundObject.toString();
      }
    } else {
      copyValue = jsonElement.value.replaceAll('"', '');
    }

    Clipboard.setData(ClipboardData(text: copyValue));
    final snackBar = SnackBar(
      content: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 4,
        text: TextSpan(
          children: [
            const TextSpan(text: 'Copy '),
            TextSpan(
              text: '"$copyValue"',
              style: TextStyle(
                color: _getColor(jsonElement.valueType),
              ),
            ),
            const TextSpan(text: ' to clipboard'),
          ],
        ),
      ),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Recursive search for a parent by index (ordinal number of an element)
  dynamic _findObject(
    someObject,
    SearchObjectParam params,
  ) {
    dynamic result;

    if (params.targetIndex == params.currentIndex) {
      return someObject;
    }

    if (someObject is List) {
      for (final obj in someObject) {
        params.currentIndex++;
        if (obj is List || obj is Map) {
          result = _findObject(obj, params);
          if (result != null) {
            return result;
          }

          /// If standard json view mode is enabled, consider
          /// closing blocks } and ]
          if (jsonController.showStandardJson) {
            params.currentIndex++;
          }
        }
      }
    } else if (someObject is Map) {
      for (final obj in someObject.values) {
        params.currentIndex++;
        if (obj is List || obj is Map) {
          result = _findObject(obj, params);
          if (result != null) {
            return result;
          }

          /// If standard json view mode is enabled, consider
          /// closing blocks } and ]
          if (jsonController.showStandardJson) {
            params.currentIndex++;
          }
        }
      }
    }
  }
}
