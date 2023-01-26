import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarItems {
  final String domain;
  final double measure;
  final charts.Color color;

  BarItems({required this.domain, required this.measure, required this.color});
}