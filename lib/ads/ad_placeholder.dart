import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:muslim_book/utils/Constants.dart';

/// Shown in an ad slot while the banner loads: a slowly turning Rub el Hizb
/// pattern with rotating dhikr, so the wait feels calm instead of stuck.
///
/// Deliberately does not point at or mimic the ad (AdMob click-encouragement policy).
class AdPlaceholder extends StatefulWidget {
  final double height;

  const AdPlaceholder({super.key, required this.height});

  @override
  State<AdPlaceholder> createState() => _AdPlaceholderState();
}

class _AdPlaceholderState extends State<AdPlaceholder>
    with SingleTickerProviderStateMixin {
  static const List<String> _azkar = [
    'سبحان الله',
    'الحمد لله',
    'لا إله إلا الله',
    'الله أكبر',
    'أستغفر الله',
  ];
  static const Duration _zikrDuration = Duration(milliseconds: 2800);
  static const Color _gold = Color(0xFFC9A54C);

  late final AnimationController _controller;
  int _zikrIndex = 0;

  @override
  void initState() {
    super.initState();
    // One controller drives both the rotation and the dhikr cycle
    _controller = AnimationController(
      vsync: this,
      duration: _zikrDuration * _azkar.length,
    )
      ..addListener(_onTick)
      ..repeat();
  }

  void _onTick() {
    final index =
        (_controller.value * _azkar.length).floor() % _azkar.length;
    if (index != _zikrIndex) {
      setState(() => _zikrIndex = index);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: ColoredBox(
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                size: Size.square(widget.height * 0.85),
                painter: _RubElHizbPainter(
                  progress: _controller.value,
                  gold: _gold,
                ),
              ),
            ),
            // Soft glow so the pattern lines never cut through the text
            Container(
              width: widget.height * 0.62,
              height: widget.height * 0.3,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.85),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
            // Out-then-in curves so two phrases never overlap
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 900),
              switchInCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
              switchOutCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween(begin: 0.9, end: 1.0).animate(animation),
                  child: child,
                ),
              ),
              child: Text(
                _azkar[_zikrIndex],
                key: ValueKey(_zikrIndex),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'arabic',
                  fontSize: widget.height * 0.11,
                  fontWeight: FontWeight.w600,
                  color: Constants.PRIMARY_COLOR,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two overlapping squares (an eight-pointed star) turning in opposite
/// directions, with a gently breathing ring of dots.
class _RubElHizbPainter extends CustomPainter {
  final double progress;
  final Color gold;

  _RubElHizbPainter({required this.progress, required this.gold});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final angle = progress * 2 * math.pi;
    final breathe = 0.5 + 0.5 * math.sin(angle * 5);

    final goldStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = gold.withValues(alpha: 0.85);
    final green = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Constants.PRIMARY_COLOR.withValues(alpha: 0.35);

    _drawStar(canvas, center, radius * 0.92, angle / 4, goldStroke);
    _drawStar(canvas, center, radius * 0.62, -angle / 2, green);

    final dot = Paint()
      ..color = gold.withValues(alpha: 0.35 + 0.5 * breathe);
    for (var i = 0; i < 8; i++) {
      final a = angle / 4 + i * math.pi / 4 + math.pi / 8;
      canvas.drawCircle(
        center + Offset(math.cos(a), math.sin(a)) * radius * 0.78,
        2 + 1.5 * breathe,
        dot,
      );
    }
  }

  void _drawStar(
      Canvas canvas, Offset center, double r, double rotation, Paint paint) {
    for (final offset in [0.0, math.pi / 4]) {
      final path = Path();
      for (var i = 0; i < 4; i++) {
        final a = rotation + offset + i * math.pi / 2;
        final p = center + Offset(math.cos(a), math.sin(a)) * r;
        i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_RubElHizbPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
