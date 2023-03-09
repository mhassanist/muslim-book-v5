import 'package:flutter/material.dart';
import 'package:muslim_book/widgets/loading_pkg/loading.dart';

abstract class Indicator {
  late LoadingState context;
  late List<AnimationController> animationControllers;

  paint(Canvas canvas, Paint paint, Size size);

  List<AnimationController> animation();

  void postInvalidate() {
    context.setState(() {});
  }

  void start() {
    animationControllers = animation();
    if (animationControllers.isNotEmpty) {
      startAnims(animationControllers);
    }
  }

  void dispose() {
    if (animationControllers.isNotEmpty) {
      for (var i = 0; i < animationControllers.length; i++) {
        animationControllers[i].stop();
        animationControllers[i].dispose();
      }
    }
    animationControllers = [];
  }

  void startAnims(List<AnimationController> controllers) {
    for (var i = 0; i < controllers.length; i++) {
      startAnim(controllers[i]);
    }
  }

  void startAnim(AnimationController controller) {
    controller.repeat();
  }
}
