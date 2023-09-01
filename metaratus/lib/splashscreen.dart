import 'package:client_onboarding_app/getstarted/getstarted.dart';
import 'package:client_onboarding_app/screens/2selectuser/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.showGetStarted});
  final bool showGetStarted;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // video controller
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/animations/Metaratus.mp4')
      ..initialize().then((value) {
        setState(() {});
      })
      ..setVolume(0.0);
    _playVideo();
    super.initState();
  }

  _playVideo() async {
    // playing video
    _controller.play();

    // add delay till video is complete
    await Future.delayed(const Duration(seconds: 4)).then(
      (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.showGetStarted
                ? const MyAppGetStarted()
                : const MyUsers(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
