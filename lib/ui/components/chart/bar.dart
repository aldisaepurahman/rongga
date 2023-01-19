import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/data/model/bar_item.dart';

class Bar extends StatefulWidget {
  const Bar({super.key});

  @override
  BarState createState() => BarState();
}

class BarState extends State<Bar> {
  final List<BarItems> barData = [
    BarItems("Mendengar", 2.0),
    BarItems("Menulis", 3.0),
    BarItems("Membaca", 2.0),
    BarItems("Menghafal", 2.0),
    BarItems("Latihan", 2.0),
    BarItems("Belajar Sendiri", 2.25),
    BarItems("Belajar Berkelompok", 2.5)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
        <Series<BarItems, String>>[
          Series(
              id: "Aktivitas Belajar",
              data: barData,
              domainFn: (BarItems item, _) => item.domain,
              measureFn: (BarItems item, _) => item.measure,
            colorFn: (BarItems item, _) => item.barColor,
          )
        ],
      animate: true,
      vertical: false,
    );
  }

}