import 'dart:ui' as ui;
import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree
CustomPaint flutterLogo({double width: 300.0}) {
  return CustomPaint(
    size: Size(width, (width * 1.237718859429715).toDouble()),
    //You can Replace [WIDTH] with your desired width for Custom Paint
    // and height will be calculated automatically.
    painter: RPSCustomPainter(),
  );
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1905953, size.height * 0.6539488);
    path_0.lineTo(0, size.height * 0.4999596);
    path_0.lineTo(size.width * 0.6188594, 0);
    path_0.lineTo(size.width, 0);
    path_0.moveTo(size.width, size.height * 0.4613612);
    path_0.lineTo(size.width * 0.6188594, size.height * 0.4613612);
    path_0.lineTo(size.width * 0.4760880, size.height * 0.5767117);
    path_0.lineTo(size.width * 0.6666833, size.height * 0.7307008);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff42a5f5).withOpacity(.8);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.4760880, size.height * 0.8846496);
    path_1.lineTo(size.width * 0.6188594, size.height * 1.000000);
    path_1.lineTo(size.width, size.height * 1.000000);
    path_1.lineTo(size.width * 0.6666833, size.height * 0.7307008);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff0d47a1).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2859430, size.height * 0.7307817);
    path_2.lineTo(size.width * 0.4762381, size.height * 0.5769946);
    path_2.lineTo(size.width * 0.6665333, size.height * 0.7307412);
    path_2.lineTo(size.width * 0.4762381, size.height * 0.8845283);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff42a5f5).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.4762381, size.height * 0.8845283);
    path_3.lineTo(size.width * 0.6665333, size.height * 0.7307817);
    path_3.lineTo(size.width * 0.6930965, size.height * 0.7522431);
    path_3.lineTo(size.width * 0.5028014, size.height * 0.9059898);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.shader = ui.Gradient.linear(
        Offset(size.width * -105.8030, size.height * 0.7803495),
        Offset(size.width * -105.8030, size.height * 0.7799453), [
      Color(0xff000000).withOpacity(.15),
      Color(0xff616161).withOpacity(.01)
    ], [
      0.2,
      0.85
    ]);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.4760880, size.height * 0.8846496);
    path_4.lineTo(size.width * 0.7588794, size.height * 0.8057150);
    path_4.lineTo(size.width * 0.6666833, size.height * 0.7306604);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.shader = ui.Gradient.linear(
        Offset(size.width * -105.8163, size.height * 0.7866609),
        Offset(size.width * -105.7663, size.height * 0.7866609), [
      Color(0xff000000).withOpacity(.55),
      Color(0xff616161).withOpacity(.01)
    ], [
      0.2,
      0.85
    ]);
    canvas.drawPath(path_4, paint_4_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
