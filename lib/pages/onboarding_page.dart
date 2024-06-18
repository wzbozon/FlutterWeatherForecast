import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../pages/weather_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WeatherPage()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Welcome to WeatherNow",
          body:
          "Stay updated with the current weather conditions in any city around the world. WeatherNow provides accurate and real-time weather information at your fingertips.",
          image: _buildImage('1.jpg'),
        ),
        PageViewModel(
          title: "Choose Your City",
          body:
          "Select any city to view its current weather. Simply search for your desired city, and get instant weather updates including temperature, humidity, and more.",
          image: _buildImage('2.jpg'),
        ),
        PageViewModel(
          title: "Save Your Favorite Cities",
          body:
          "Add cities to your list and keep track of their weather effortlessly. Your selected cities are saved in the app's database, so you can easily access them anytime.",
          image: _buildImage('3.jpg'),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showBackButton: false,
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

