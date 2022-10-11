import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../provider/song_model_provider.dart';

//ignore: must_be_immutable
class AudioScreen extends StatefulWidget {
  AudioScreen(this.jsonFiles, this.pageController, {super.key});
  Map<String, dynamic>? jsonFiles;
  PageController pageController;

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Duration _duration = const Duration();
  Duration _position = const Duration();
  final AudioPlayer audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  List<AudioSource> songList = [];

  int currentIndex = 0;

  void seekToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  @override
  void initState() {
    super.initState();
    parseSong();
  }

  void parseSong() {
    try {
      songList.add(
        AudioSource.uri(
          Uri.parse("asset:assets/a-arte-da-guerra.mp3"),
          tag: const  MediaItem(
            id: "A arte da guerra",
            album: "No Album",
            title: "A Arte da guerra",
          ),
        ),
      );
      audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: songList),
      ).catchError((e){
        debugPrint("Erro: $e");
      });
      audioPlayer.play();
      _isPlaying = true;

      audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() {
            _duration = duration;
          });
        }
      });
      audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
        });
      });
      listenToEvent();
      listenToSongIndex();
    } on Exception catch (_) {
      widget.pageController.jumpTo(0);
    }
  }

  void listenToEvent() {
    audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void listenToSongIndex() {
    audioPlayer.currentIndexStream.listen(
      (event) {
        setState(
          () {
            if (event != null) {
              currentIndex = event;
            }
            context
                .read<SongModelProvider>()
                .setId(0);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("A arte da guerra"),
        leading: IconButton(
          onPressed: (){
            widget.pageController.jumpToPage(0);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        height: height,
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: ArtWorkWidget(),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Text(
                    "A Arte da Guerra",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Slider(
                    min: 0.0,
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble() + 1.0,
                    onChanged: (value) {
                      setState(
                        () {
                          seekToSeconds(value.toInt());
                          value = value;
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _position.toString().split(".")[0],
                      ),
                      Text(
                        _duration.toString().split(".")[0],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_isPlaying) {
                          audioPlayer.pause();
                        } else {
                          if (_position >= _duration) {
                            seekToSeconds(0);
                          } else {
                            audioPlayer.play();
                          }
                        }
                        _isPlaying = !_isPlaying;
                      });
                    },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40.0,
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkHeight: 200,
      artworkWidth: 200,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: const Icon(
        Icons.music_note,
        size: 200,
      ),
    );
  }
}