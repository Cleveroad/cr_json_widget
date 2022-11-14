import 'package:cr_json_widget/res/cr_json_color.dart';
import 'package:flutter/material.dart';

class JsonRecyclerController {
  JsonRecyclerController({
    required this.isExpanded,
    this.saveClosedHistory = true,
    this.showStandardJson = false,
    this.jsonKeyColor = CrJsonColors.jsonKeyColor,
    this.intColor = CrJsonColors.intColor,
    this.doubleColor = CrJsonColors.doubleColor,
    this.stringColor = CrJsonColors.stringColor,
    this.nullColor = CrJsonColors.nullColor,
    this.boolColor = CrJsonColors.boolColor,
    this.objectColor = CrJsonColors.objectColor,
    this.standardJsonBackgroundColor = CrJsonColors.jsonBackgroundColor,
    this.iconOpened = const Icon(Icons.arrow_drop_down),
    this.iconClosed = const Icon(Icons.arrow_right),
    this.fontWeight = FontWeight.bold,
    this.horizontalSpaceMultiplier = 18,
    this.verticalOffset = 4,
    this.additionalIndentChildElements = 6,
    this.fontStyle,
  });

  final bool saveClosedHistory;
  final bool showStandardJson;
  bool isExpanded = false;

  final Color jsonKeyColor;
  final Color intColor;
  final Color doubleColor;
  final Color stringColor;
  final Color nullColor;
  final Color boolColor;
  final Color objectColor;
  final Color standardJsonBackgroundColor;
  final Widget iconOpened;
  final Widget iconClosed;
  final FontWeight fontWeight;
  final double verticalOffset;
  final double horizontalSpaceMultiplier;

  /// Additional indentation for aligning child elements
  /// depending on the size of the parent icon
  final double additionalIndentChildElements;

  final FontStyle? fontStyle;

  void changeState() {
    isExpanded = !isExpanded;
  }
}
