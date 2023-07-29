import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProgressBar extends StatefulWidget {
  final Icon icon;
  final VoidCallback onCompleted;

  const ProgressBar({required this.icon, required this.onCompleted});

  @override
  State<ProgressBar> createState() => ProgressBarState();
}

class ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = IntTween(begin: 0, end: 100).animate(_animationController);
    _animation.addListener(() {
      setState(() {});
    });
    _animationController.forward().whenCompleteOrCancel(() {
      // Animation completed or cancelled
      // Call the callback function to notify the parent
      widget.onCompleted();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularStepProgressIndicator(
          totalSteps: 100,
          currentStep: _animation.value,
          selectedColor: Colors.blue.shade900,
          unselectedColor: Colors.blue.shade100,
          padding: 0,
          width: 100,
          child: Center(
            child: Center(
              child: Icon(
                widget.icon.icon,
                size: 55,
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        // You can add more widgets here if needed, such as a progress percentage or other information.
      ],
    );
  }
}
