import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:non_cognitive/ui/components/core/color.dart';
import 'package:pie_chart/pie_chart.dart';

class Pie extends StatefulWidget {
  const Pie({super.key});

  @override
  PieState createState() => PieState();

}

class PieState extends State<Pie>{

  final dataMap = <String, double>{
    "Visual": 3,
    "Auditori": 4,
    "Kinestetik": 8,
  };

  final legendLabels = <String, String>{
    "Visual": "Visual legend",
    "Auditori": "Auditori legend",
    "Kinestetik": "Kinestetik legend",
  };

  final colorList = <Color>[
    red,
    blue,
    green,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Poppins"
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 0,
        chartValueStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),
      )
    );
  }

}