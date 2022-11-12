import 'package:cr_json_widget/src/constant.dart';
import 'package:cr_json_widget/src/controllers/json_recycler_controller.dart';
import 'package:cr_json_widget/src/models/current_parent_index.dart';
import 'package:cr_json_widget/src/models/elements/json_element.dart';
import 'package:cr_json_widget/src/models/elements/json_parent_element.dart';
import 'package:cr_json_widget/src/models/params/preparing_param.dart';
import 'package:cr_json_widget/src/models/value_type.dart';
import 'package:flutter/cupertino.dart';

abstract class IRecycler {
  late final JsonRecyclerController jsonController;
  late final dynamic json;
}

abstract class BaseRecyclerPageState<T extends StatefulWidget> extends State<T>
    implements IRecycler {
  final jsonList = <JsonElement>[];
  int jsonListLength = 0;
  bool _isExpanded = false;
  CurrentParentIndex? _currentParentIndex;

  @override
  void initState() {
    super.initState();
    jsonList.addAll(
      _creatingListElements(
        json,
        PreparingParam(),
      ),
    );
    jsonListLength = jsonList.length;
    _isExpanded = jsonController.isExpanded;

    if (!_isExpanded) {
      _closeJson();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// If the parent was clicked, calculate the offset
    final currentPressedIndex = _currentParentIndex;
    if (currentPressedIndex != null) {
      _changeListState(
        currentPressedIndex.index,
        currentPressedIndex.originalIndex,
      );

      _currentParentIndex = null;
    }

    if (_isExpanded != jsonController.isExpanded) {
      if (jsonController.isExpanded) {
        _openJson();
      } else {
        _closeJson();
      }

      _isExpanded = jsonController.isExpanded;
    }

    return bodyWidget(context);
  }

  Widget bodyWidget(BuildContext context);

  /// Creating a list of elements from the received object
  /// Recursion going through all elements of the json
  List<JsonElement> _creatingListElements(
    someObject,
    PreparingParam params,
  ) {
    /// Если List
    if (someObject is List) {
      final jsonElem = <JsonElement>[];
      final parentIndex = params.index;
      var parentKey = '';
      var parentValue = '';

      /// Display the parent element
      if (jsonController.showStandardJson) {
        parentKey = '${params.keyValue}[';
      } else {
        parentValue = 'Array<Object>[${someObject.length}]';
        parentKey = params.keyValue;
      }

      final children = <JsonElement>[];
      for (var i = 0; i < someObject.length; i++) {
        final obj = someObject[i];
        if (obj is List || obj is Map) {
          params.index++;
          params.depth++;

          /// Passing the display to the child parent
          if (obj is Map) {
            if (jsonController.showStandardJson) {
              params.keyValue = '';
            } else {
              params.keyValue = '[$i]: ';
            }
          }

          children.addAll(_creatingListElements(obj, params));
          params.depth--;
        } else {
          params.index++;

          final newNode = JsonElement()
            ..value = _valueToString(obj)
            ..valueType = _getType(obj)
            ..shiftIndex = params.index
            ..index = params.index
            ..depth = params.depth + 1;
          children.add(newNode);
        }
      }

      /// Creating a parent
      final parentElement = JsonParentElement()
        ..isClosed = false
        ..nChildren =
            children.length + (jsonController.showStandardJson ? 2 : 1);

      final parentNode = JsonElement()
        ..parentRef = parentElement
        ..keyValue = parentKey
        ..value = parentValue
        ..valueType = ValueType.object
        ..shiftIndex = parentIndex
        ..index = parentIndex
        ..depth = params.depth;

      /// Saving the parent and then the child elements
      jsonElem
        ..add(parentNode)
        ..addAll(children);

      /// Shows the closing of the List block
      if (jsonController.showStandardJson) {
        params.index++;
        final newNodeEnd = JsonElement()
          ..keyValue = ']'
          ..value = ''
          ..valueType = ValueType.object
          ..shiftIndex = params.index
          ..index = params.index
          ..depth = params.depth;

        jsonElem.add(newNodeEnd);
      }

      return jsonElem;

      /// if Map
    } else if (someObject is Map) {
      final jsonElem = <JsonElement>[];
      final parentIndex = params.index;
      var parentKey = '';
      var parentValue = '';

      /// Display the parent element
      if (jsonController.showStandardJson) {
        parentKey = '${params.keyValue}{';
      } else {
        parentValue = 'Object';
        parentKey = params.keyValue;
      }

      final children = <JsonElement>[];
      for (final obj in someObject.entries) {
        final value = obj.value;

        if (value is List || value is Map) {
          params.index++;
          params.depth++;
          params.keyValue = '${obj.key}: ';

          children.addAll(_creatingListElements(value, params));
          params.depth--;
        } else {
          params.index++;

          final newNode = JsonElement()
            ..keyValue = '${obj.key.toString()}: '
            ..value = _valueToString(value)
            ..valueType = _getType(value)
            ..shiftIndex = params.index
            ..index = params.index
            ..depth = params.depth + 1;

          children.add(newNode);
        }
      }

      /// Creating a parent
      final parentElement = JsonParentElement()
        ..isClosed = false
        ..nChildren =
            children.length + (jsonController.showStandardJson ? 2 : 1);

      final parentNode = JsonElement()
        ..parentRef = parentElement
        ..keyValue = parentKey
        ..value = parentValue
        ..valueType = ValueType.object
        ..shiftIndex = parentIndex
        ..index = parentIndex
        ..depth = params.depth;

      /// Saving the parent and then the child elements
      jsonElem
        ..add(parentNode)
        ..addAll(children);

      /// Shows the closing of the Map block
      if (jsonController.showStandardJson) {
        params.index++;
        final newNodeEnd = JsonElement()
          ..keyValue = '}'
          ..value = ''
          ..valueType = ValueType.object
          ..shiftIndex = params.index
          ..index = params.index
          ..depth = params.depth;

        jsonElem.add(newNodeEnd);
      }

      return jsonElem;

      /// If other types
    } else {
      final newNode = JsonElement()
        ..value = _valueToString(someObject)
        ..valueType = _getType(someObject)
        ..shiftIndex = params.index
        ..index = params.index;

      return [newNode];
    }
  }

  /// Return string value
  /// If value is already a string, wrap it in double quotes
  String _valueToString(value) {
    return value is String ? '"${value.toString()}"' : value.toString();
  }

  /// Calculating element shifts when the parent is open/closed
  void _changeListState(int index, int orig) {
    if (jsonList[index].parentRef != null) {
      jsonList[index].parentRef!.isClosed =
          !jsonList[index].parentRef!.isClosed;

      final isClosedSign = jsonList[index].parentRef!.isClosed ? 1 : -1;

      /// -1 remove influence on the parent
      var shiftValue = jsonList[index].parentRef!.nChildren - 1;
      var cutLengthArrayValue = shiftValue * -isClosedSign;

      var sumClosedChildren = 0;
      if (orig + 1 < jsonList.length) {
        /// When closing, counting the child closed elements so as /// not to reduce the size of the array twice.
        final lastIndex = index + shiftValue;
        var skipChildrenLastIndex = -1;

        for (var i = index + 1; i < lastIndex; i++) {
          /// If the parent was closed, skip checking all children
          if (i < skipChildrenLastIndex) {
            continue;
          }

          if (jsonList[i].parentRef?.isClosed == true) {
            final nChildren = jsonList[i].parentRef?.nChildren;
            if (nChildren != null) {
              sumClosedChildren += nChildren - 1;

              /// If the child parent is closed, count as 1 item
              shiftValue -= nChildren - 1;

              skipChildrenLastIndex = i + nChildren;
            }
          }
        }

        cutLengthArrayValue += sumClosedChildren * isClosedSign;

        /// Changing the size of the array
        jsonListLength += cutLengthArrayValue;

        for (var i = orig + 1; i < jsonListLength; i++) {
          /// Closing elements
          if (isClosedSign > 0) {
            final indexWithShift = i + shiftValue;

            /// Copying an existing offset
            if (indexWithShift < jsonList.length) {
              jsonList[i].shiftIndex = jsonList[indexWithShift].shiftIndex;
            }

            /// Opening Elements
          } else {
            /// Offset all values by the number of child elements
            for (var j = jsonListLength - 1; j >= orig + shiftValue; j--) {
              jsonList[j].shiftIndex = jsonList[j - shiftValue].shiftIndex;
            }

            var shiftIndex = index + 1;
            var step = 0;

            /// Insert missing values
            for (var j = 0; j < shiftValue; j++) {
              /// Calculation of displacement
              final targetIndex = shiftIndex + step;
              step++;

              /// Goes through the elements one by one and assigns a new offset
              jsonList[i + j].shiftIndex = targetIndex;

              /// If a closed parent was found, set a new offset
              if (jsonList[targetIndex].parentRef?.isClosed == true) {
                final nChildren = jsonList[targetIndex].parentRef?.nChildren;
                if (nChildren != null) {
                  shiftIndex = targetIndex + nChildren;
                  step = 0;
                }
              }
            }
            break;
          }
        }

        /// Reset history of closed children (close)
        if (!jsonController.saveClosedHistory && isClosedSign > 0) {
          /// End of Map/List block
          final endBlock = jsonList[index].parentRef!.nChildren - 1;
          for (var i = orig + 1; i < endBlock; i++) {
            jsonList[i].parentRef?.isClosed = true;
          }
        }
      }
    }
  }

  /// Reset all shifts (open all parents)
  void _openJson() {
    for (var i = 0; i < jsonList.length; i++) {
      jsonList[i].shiftIndex = i;
      jsonList[i].parentRef?.isClosed = false;
    }

    setState(() {
      jsonListLength = jsonList.length;
    });
  }

  /// Closing all parents
  void _closeJson() {
    for (var i = 0; i < jsonList.length; i++) {
      jsonList[i].parentRef?.isClosed = true;
    }

    setState(() {
      jsonListLength = 1;
    });
  }

  /// Set value type
  ValueType _getType(Object? value) {
    if (value is int) {
      return ValueType.int;
    } else if (value is double) {
      return ValueType.double;
    } else if (value is String) {
      if (value == kHidden) {
        return ValueType.hidden;
      } else {
        return ValueType.string;
      }
    } else if (value == null) {
      return ValueType.nil;
    } else if (value is bool) {
      return ValueType.bool;
    }

    return ValueType.object;
  }

  void rememberIndexOfParent(int indexWithShift, int index) {
    /// Remember the indexes of the parent you clicked on
    if (_currentParentIndex == null) {
      setState(() {
        _currentParentIndex = CurrentParentIndex(indexWithShift, index);
      });
    }
  }
}
