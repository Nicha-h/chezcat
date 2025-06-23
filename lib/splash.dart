import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home.dart';

class CheesySplash extends StatefulWidget {
  @override
  _CheesySplashState createState() => _CheesySplashState();
}

class _CheesySplashState extends State<CheesySplash>
    with TickerProviderStateMixin {
  final String title = "Cheesy Cat";
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _fadeOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _playRandomSound();
    
    for (int i = 0; i < title.length; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 600),
        vsync: this,
      );
      final animation = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.elasticOut))
          .animate(controller);
      _controllers.add(controller);
      _animations.add(animation);
      
      Future.delayed(Duration(milliseconds: i * 150), () {
        controller.forward();
      });
    }

    Future.delayed(Duration(seconds: 3), () {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _fadeOpacity = 0.0;
        });
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        });
      });
    });
  }

  void _playRandomSound() async {
    int index = Random().nextInt(5) + 1;
    String filePath = 'sfx/splash$index.mp3';
    await _audioPlayer.play(AssetSource(filePath));
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCECDD),
      body: AnimatedOpacity(
        opacity: _fadeOpacity,
        duration: Duration(milliseconds: 500),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(title.length, (i) {
              return ScaleTransition(
                scale: _animations[i],
                child: Text(
                  title[i],
                  style: const TextStyle(
                    fontFamily: 'Jua',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF804E3F),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}