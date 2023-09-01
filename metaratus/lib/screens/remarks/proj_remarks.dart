import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class MyClientReview extends StatefulWidget {
  const MyClientReview({super.key});

  @override
  State<MyClientReview> createState() => _MyClientReviewState();
}

class _MyClientReviewState extends State<MyClientReview> {
  bool hasImage = false;
  bool hasVideo = false;
  String? path = '';
  int maxLength = 45;
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Pick a Video',
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        path = file.path;
        // videoFile(path);

        _controller = VideoPlayerController.file(File(path!))
          ..initialize().then((_) {
            setState(() {
              _chewieController = ChewieController(
                videoPlayerController: _controller,
                autoPlay: false,
                looping: false,
                showControls: true,
                zoomAndPan: true,
                materialProgressColors: ChewieProgressColors(
                  playedColor: Colors.red,
                  handleColor: Colors.red,
                  backgroundColor: Colors.grey,
                  bufferedColor: Colors.white,
                ),
              );
              hasVideo = true;
            });
          });
      });
      // videoFile(path);
    }
  }

  // videoFile(path) {
  //   _videoPlayerController = VideoPlayerController.file(File(path));

  //   // Initialize the chewie controller with the video player controller
  //   _chewieController = ChewieController(
  //     videoPlayerController: _videoPlayerController,
  //     autoPlay: true,
  //     looping: true,
  //     showControls: true,
  //     materialProgressColors: ChewieProgressColors(
  //       playedColor: Colors.red,
  //       handleColor: Colors.red,
  //       backgroundColor: Colors.grey,
  //       bufferedColor: Colors.white,
  //     ),
  //   );
  // }

  shareFiles() async {
    await Share.shareXFiles([XFile(path!)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'We are glad that you have shown your trust in us!',
                style: TextStyle(
                  color: Colors.indigo,
                  fontFamily: 'fontOneBold',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Please take a moment to share your thoughts and help others discover our services.',
                style: TextStyle(
                  fontFamily: 'fontTwo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            // instructions
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'To share your review, simply select a video from your gallery that best captures your thoughts about our service. You can record a new video, or choose one you\'ve already created. Then, share it on your social media accounts for others to see.',
                style: TextStyle(
                  fontFamily: 'fontTwo',
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            // buttons
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 50,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green),
                        ),
                        onPressed: () {
                          pickFiles();
                        },
                        child: const Text(
                          'Select a video',
                          style: TextStyle(
                            fontFamily: 'fontThree',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 50,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                        ),
                        onPressed: () {
                          Future<void> launchBrowser(Uri url) async {
                            if (!await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                              webViewConfiguration: const WebViewConfiguration(
                                  enableDomStorage: true),
                            )) {
                              throw Exception('could not launch $url');
                            }
                          }

                          launchBrowser(Uri.parse(
                              'https://g.page/r/CaF3j4ZkLKMeEB0/review'));
                        },
                        child: const Text(
                          'Review us on Google',
                          style: TextStyle(
                            fontFamily: 'fontThree',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),

                  // const SizedBox(width: 10),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.4,
                  //   height: 20,
                  //   child: Text.rich(
                  //     TextSpan(
                  //       style: const TextStyle(
                  //         fontFamily: 'fontTwo',
                  //         fontSize: 14,
                  //       ),
                  //       text: path!.length <= maxLength
                  //           ? path!
                  //           : "${path!.substring(0, maxLength)}...",
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            hasVideo ? content() : const SizedBox(),
            const SizedBox(height: 20),

            hasVideo
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 40,
                    child: ElevatedButton.icon(
                        icon: const Icon(Icons.share_rounded,
                            color: Colors.white),
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.orange),
                        ),
                        onPressed: () {
                          shareFiles();
                        },
                        label: const Text(
                          'Share',
                          style: TextStyle(
                            fontFamily: 'fontThree',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget content() {
    return Center(
      child: Container(
        color: Colors.black87,
        height: 250,
        width: MediaQuery.of(context).size.width * 0.9,
        // decoration: BoxDecoration(
        //     border: Border.all(width: 2.0),
        //     borderRadius: BorderRadius.circular(15.0)),
        // child: VideoPlayer(_controller),
        child: Chewie(controller: _chewieController),
      ),
    );
  }
}
