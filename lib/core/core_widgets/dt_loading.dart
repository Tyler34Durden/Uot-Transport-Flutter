import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class DTLoading extends StatefulWidget {
  final Duration minDisplayTime;
  final double sizeFactor;

  const DTLoading({
    Key? key,
    this.minDisplayTime = const Duration(milliseconds: 1500), // Minimum display time
    this.sizeFactor = 0.40,
  }) : super(key: key);

  @override
  State<DTLoading> createState() => _DTLoadingState();
}

class _DTLoadingState extends State<DTLoading> with SingleTickerProviderStateMixin {
  bool _canDispose = false;
  Timer? _displayTimer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Create animation controller with faster speed
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Faster than default
    );

    _animationController.forward();

    _displayTimer = Timer(widget.minDisplayTime, () {
      if (mounted) {
        setState(() {
          _canDispose = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _displayTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = width * widget.sizeFactor;

    return SizedBox(
      width: size,
      height: size,
      child: Lottie.asset(
        'assets/icons/DT_Loading.json',
        repeat: true,
        controller: _animationController,
        // Increasing speed by setting a shorter animation duration
        frameRate: FrameRate.max,
      ),
    );
  }
}