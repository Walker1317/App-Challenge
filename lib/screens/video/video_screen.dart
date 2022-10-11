import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

//ignore: must_be_immutable
class VideoScreen extends StatefulWidget {
  VideoScreen(this.jsonFiles, this.pageController, {super.key});
  Map<String, dynamic>? jsonFiles;
  PageController pageController;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late VideoPlayerController _controller;
  dynamic chewieController;

  _chewie() async {
    _controller = VideoPlayerController.network(widget.jsonFiles!["video"]);
    await _controller.initialize().then((value) => setState(() {}),);
    chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      startAt: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _chewie();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900]!,
      appBar: AppBar(
        title: const Text("Vídeo"),
        leading: IconButton(
          onPressed: (){
            _controller.pause();
            widget.pageController.jumpToPage(0);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: 
      Center(
        child: _controller.value.isInitialized
        ? Chewie(controller: chewieController)
        : Container(),
      ),
    );
  }
}