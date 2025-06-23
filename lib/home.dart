import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int slapCount = 0;
  bool isSlapping = false;
  String currentCatImage = 'assets/catSprite/White.png';
  final player = AudioPlayer();
  final Random random = Random();

  void slapCat() async {
    setState(() {
      slapCount++;
      isSlapping = true;
    });

    // Play random slap sound
    int randomIndex = random.nextInt(5) + 1; 
    String randomSound = 'sfx/slap$randomIndex.mp3'; 
    player.play(AssetSource(randomSound)); 

    // Immediately change to cheese cat
    setState(() {
      currentCatImage = random.nextBool() 
          ? 'assets/catSprite/cheese/whiteCheese1.png'
          : 'assets/catSprite/cheese/whiteCheese2.png';
    });

    // Return to normal after showing cheese for shorter duration
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) { 
        setState(() {
          isSlapping = false;
          currentCatImage = 'assets/catSprite/White.png';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCECDD),
      body: Stack(
        children: [
          
          Positioned.fill(
            child: Image.asset(
              'assets/backgroundCheese.png',
              fit: BoxFit.cover,
            ),
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 120, 
            child: Column(
              children: [
                const SizedBox(height: 80),  
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        '$slapCount slap${slapCount == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontFamily: 'Jua',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        '0 slaps/sec',
                        style: TextStyle(fontFamily: 'Jua', fontSize: 16),
                      ),
                    ],
                  ),
                ),

                
                Expanded(
                  child: Center(
                    child: AnimatedScale(
                      scale: isSlapping ? 0.85 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: slapCat,
                        child: Image.asset(
                          currentCatImage,
                          height: 1000, 
            
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        //nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
           
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                ),
                child: Stack(
                  children: [
                    // Nav bar background
                    Positioned.fill(
                      child: Image.asset(
                        'assets/cheesenav.png',
                        fit: BoxFit.fill,
                      ),
                    ),

                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            bottomNavItem('assets/cat.png'),
                            bottomNavItem('assets/store.png'),
                            bottomNavItem('assets/setting.png'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }

  Widget bottomNavItem(String iconPath) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(top: 15), 
        child: 
          Image.asset(
            iconPath, 
            height: 48,
            width: 80,
          ),
        ),
    );
  }
}