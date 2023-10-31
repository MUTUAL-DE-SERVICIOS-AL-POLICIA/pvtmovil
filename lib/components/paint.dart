import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class FormButtom extends StatelessWidget {
  const FormButtom({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: FormButtomPainter(AdaptiveTheme.of(context).mode.isDark? const Color(0xff214a44) : const Color(0xfff2f2f2)),
      ),
    );
  }
}

class FormButtomPainter extends CustomPainter {
  final Color color;

  FormButtomPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill; //stroke //fill

    final path = Path()
      ..moveTo(0, size.height / 3)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.25, size.width * 0.5, size.height * 0.28)
      ..quadraticBezierTo(size.width / 1.2, size.height * 0.3, size.width, size.height * 0.25)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Formtop extends StatelessWidget {
  const Formtop({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: FormtopPainter(),
      ),
    );
  }
}

class FormtopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffb3d4cf)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill; //stroke //fill

    final path = Path()
      ..moveTo(0, size.height / 3.4)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.25, size.width * 0.5, size.height * 0.27)
      ..quadraticBezierTo(size.width / 1.2, size.height * 0.3, size.width, size.height * 0.25)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
