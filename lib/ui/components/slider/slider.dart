import 'package:flutter/cupertino.dart';
import 'package:non_cognitive/ui/components/core/color.dart';

class SliderCustom extends StatefulWidget {
  final int currentIndex;
  final int index;
  const SliderCustom({super.key, required this.currentIndex, required this.index});

  @override
  _SliderState createState() => _SliderState();

}

class _SliderState extends State<SliderCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.currentIndex == widget.index
            ? blue
            : white,
      ),
    );
  }

}