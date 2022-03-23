import 'package:flutter/material.dart';

class Starting extends StatefulWidget {
  @override
  _StartingState createState() => _StartingState();
}

class _StartingState extends State<Starting>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _padddown;
  Animation<double> _size;
  double down;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _controller.forward();

    _padddown = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(tween: Tween(begin: 400, end: 0), weight: 1),
      TweenSequenceItem<double>(tween: Tween(begin: 0, end: 400), weight: 1)
    ]).animate(_controller);

    _size = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(tween: Tween(begin: 50, end: 0), weight: 50),
      TweenSequenceItem<double>(tween: Tween(begin: 0, end: 70), weight: 50)
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return Container(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(_size.value),
            margin: EdgeInsets.fromLTRB(0, 0, 0, _padddown.value),
            child: Image(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
        );
      },
    );
  }
}
