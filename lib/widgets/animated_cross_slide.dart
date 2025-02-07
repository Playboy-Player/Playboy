import 'package:flutter/material.dart';

class AnimatedCrossSlide extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final CrossFadeState crossFadeState;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve firstCurve;
  final Curve secondCurve;
  final Curve sizeCurve;
  final AlignmentGeometry alignment;

  const AnimatedCrossSlide({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.crossFadeState,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration,
    this.firstCurve = Curves.linear,
    this.secondCurve = Curves.linear,
    this.sizeCurve = Curves.linear,
    this.alignment = Alignment.center,
  });

  @override
  AnimatedCrossSlideState createState() => AnimatedCrossSlideState();
}

class AnimatedCrossSlideState extends State<AnimatedCrossSlide>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _firstAnimation;
  late Animation<Offset> _secondAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    );
    _updateAnimations();
    _controller.value =
        widget.crossFadeState == CrossFadeState.showFirst ? 0.0 : 1.0;
  }

  @override
  void didUpdateWidget(AnimatedCrossSlide oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.crossFadeState != oldWidget.crossFadeState) {
      widget.crossFadeState == CrossFadeState.showFirst
          ? _controller.reverse()
          : _controller.forward();
    }

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    if (widget.firstCurve != oldWidget.firstCurve ||
        widget.secondCurve != oldWidget.secondCurve) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    _firstAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.firstCurve,
    ));

    _secondAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.secondCurve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return AnimatedSize(
          duration: widget.duration,
          curve: widget.sizeCurve,
          alignment: widget.alignment,
          child: Stack(
            alignment: widget.alignment,
            children: [
              SlideTransition(
                position: _firstAnimation,
                child: widget.firstChild,
              ),
              SlideTransition(
                position: _secondAnimation,
                child: widget.secondChild,
              ),
            ],
          ),
        );
      },
    );
  }
}
