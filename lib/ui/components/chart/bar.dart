import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:non_cognitive/data/model/bar_item.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

class Bar extends StatefulWidget {
  const Bar({super.key});

  @override
  BarState createState() => BarState();
}

class BarState extends State<Bar> {
  final List<BarItems> barData = [
    BarItems(
        domain: "Mendengar",
        measure: 2.0,
      color: charts.ColorUtil.fromDartColor(green)
    ),
    BarItems(
        domain: "Menulis",
        measure: 3.0,
        color: charts.ColorUtil.fromDartColor(green)
    ),
    BarItems(
        domain: "Membaca",
        measure: 2.0,
        color: charts.ColorUtil.fromDartColor(green)
    ),
    BarItems(
        domain: "Menghafal",
        measure: 2.0,
        color: charts.ColorUtil.fromDartColor(green)
    ),
    BarItems(
        domain: "Latihan",
        measure: 2.0,
        color: charts.ColorUtil.fromDartColor(green)
    ),
    BarItems(
        domain: "Belajar Sendiri",
        measure: 2.25,
        color: charts.ColorUtil.fromDartColor(green)
    ),
    BarItems(
        domain: "Belajar Berkelompok",
        measure: 2.5,
        color: charts.ColorUtil.fromDartColor(green)
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
        <charts.Series<BarItems, String>>[
          charts.Series(
              id: "Aktivitas Belajar",
              data: barData,
              domainFn: (BarItems item, _) => item.domain,
              measureFn: (BarItems item, _) => item.measure,
            colorFn: (BarItems item, _) => item.color,
            labelAccessorFn: (BarItems item, _) => item.domain,
            insideLabelStyleAccessorFn: (BarItems item, _) {
              return charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(white), fontFamily: "Poppins");
            },
          )
        ],
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.NoneRenderSpec()
      ),

    );
  }

}