import 'package:flutter/material.dart';

int replaceColor(String color){
  return int.parse(color.replaceAll('#', '0xff'));
}

Color white = Color(replaceColor("#FFFFFF"));
Color black = Color(replaceColor("#000000"));
Color green = Color(replaceColor("#179B24"));
Color skyBlue = Color(replaceColor("#2092D2"));
Color blue = Color(replaceColor("#182776"));
Color orange = Color(replaceColor("#FA9C18"));
Color gray = Color(replaceColor("#605F5F"));
Color lightGreen = Color(replaceColor("#18D62B"));
Color red = Color(replaceColor("#C81616"));
    