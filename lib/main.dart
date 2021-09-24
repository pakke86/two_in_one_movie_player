import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController? _firstVideoController;
  late VideoPlayerController? _secondVideoController;
  late Future<void> _initFirstVideoPlayer;
  late Future<void> _initSecondVideoPlayer;

  @override
  void initState() {
    super.initState();
    _firstVideoController =
        VideoPlayerController.asset('assets/video/video_demo.mp4');

    _secondVideoController =
        VideoPlayerController.asset('assets/video/tolk.mp4');

    _firstVideoController!.addListener(() {
      setState(() {});
    });

    //_firstVideoController!.setLooping(true);
    _firstVideoController!.initialize().then((_) {
      setState(() {});
    });
    _secondVideoController!.initialize().then((_) {
      setState(() {});
    });

    _initFirstVideoPlayer = _firstVideoController!.initialize();
    _initSecondVideoPlayer = _secondVideoController!.initialize();

    _firstVideoController!.addListener(() {
      if (_firstVideoController!.value.isPlaying) {
        _secondVideoController!.play();
      } else if (!_firstVideoController!.value.isPlaying) {
        _secondVideoController!.pause();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _firstVideoController!.dispose();
    _secondVideoController!.dispose();
  }

  bool isHiddenSecondvideo = true;

  final double _playerButtonSize = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' \"2 in 1 video proof of concept\"'),
      ),
      body: FutureBuilder(
        future: _initFirstVideoPlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 720,
                      child: Column(children: [
                        Stack(children: [
                          AspectRatio(
                            aspectRatio:
                                _firstVideoController!.value.aspectRatio,
                            child: VideoPlayer(_firstVideoController!),
                          ),
                          Visibility(
                            visible: isHiddenSecondvideo,
                            child: Positioned(
                                right: 10,
                                bottom: 5,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  clipBehavior: Clip.hardEdge,
                                  child: SizedBox(
                                      width: 200,
                                      height: 150,
                                      child:
                                          VideoPlayer(_secondVideoController!)),
                                )),
                          )
                        ]),
                        Container(
                          color: Colors.black87,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    _firstVideoController!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: _playerButtonSize,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _firstVideoController!.value.isPlaying
                                          ? _firstVideoController!.pause()
                                          : _firstVideoController!.play();
                                    });
                                  }),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isHiddenSecondvideo = !isHiddenSecondvideo;
                                  });
                                },
                                icon: Icon(
                                  Icons.wash,
                                  size: _playerButtonSize,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Text(
                            ' \"Proof of concept\" för att ha uppspelning av en video med teckentolking i en ruta i. Det är planerad att teckenrutan ska gå att flytta runt och förstora och förminska.\n Klicka på \"handen\" för att visa/dölja rutan ')
                      ]),
                    ),
                  ]),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
