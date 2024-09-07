import 'package:flutter/material.dart';

class DotProgressIndicator extends StatefulWidget {
  final int totalDots;
  final double dotSize;
  final Color activeColor;
  final Color inactiveColor;
  final Duration animationDuration;

  const DotProgressIndicator({
    Key? key,
    this.totalDots = 4,
    this.dotSize = 10,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DotProgressIndicatorState createState() => _DotProgressIndicatorState();
}

class _DotProgressIndicatorState extends State<DotProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentDot = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..addListener(() {
        if (_controller.isCompleted) {
          setState(() {
            _currentDot = (_currentDot + 1) % widget.totalDots;
          });
          _controller.reset();
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalDots, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AnimatedContainer(
            duration: widget.animationDuration,
            width: widget.dotSize,
            height: widget.dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index <= _currentDot
                  ? widget.activeColor
                  : widget.inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}
