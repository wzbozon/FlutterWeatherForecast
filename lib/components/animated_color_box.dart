import 'package:flutter/material.dart';

class AnimatedColorBox extends StatefulWidget {
  const AnimatedColorBox({super.key});

  @override
  _AnimatedColorBoxState createState() => _AnimatedColorBoxState();
}

class _AnimatedColorBoxState extends State<AnimatedColorBox> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<Color?>? animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    animation = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(controller!);

    controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller!.forward();
      }
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      builder: (context, child) => Container(
        width: 100,
        height: 100,
        color: animation!.value,
      ),
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
