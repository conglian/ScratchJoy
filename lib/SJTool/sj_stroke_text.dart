import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SJStrokeText extends StatelessWidget {
  final String text;
  final double size;
  final TextAlign align;
  final Color color;
  final FontWeight weight;
  final int maxLines;
  final double skWidth;
  final Color skColor;
  final bool is_btn;

  const SJStrokeText({
    required this.text,
    required this.size,
    required this.color,
    required this.weight,
    required this.skWidth,
    required this.skColor,
    this.align = TextAlign.center,
    this.maxLines = 1,
    this.is_btn = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = skWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = skColor;

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(text,
            textAlign: align,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(foreground: paint, fontSize: size, height: 1.15, fontWeight: weight, fontFamily: is_btn ? '' : 'Barlow_Black')),
        Text(text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: align,
            style: TextStyle(fontSize: size, color: color, height: 1.15, fontWeight: weight, fontFamily: is_btn ? '' : 'Barlow_Black')),
      ],
    );
  }
}
