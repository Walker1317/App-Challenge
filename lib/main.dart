import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music_player/provider/song_model_provider.dart';
import 'package:flutter_music_player/screens/audio/audio_screen.dart';
import 'package:flutter_music_player/screens/home/home_screen.dart';
import 'package:flutter_music_player/screens/pdf/pdf_screen.dart';
import 'package:flutter_music_player/screens/video/video_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'features/shared/ui/screens/AllSongs.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => SongModelProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? jsonFiles;
  
  Future<Map<String, dynamic>> changeJson() async {
    String jsonFile = "content.json";
    String data = await rootBundle.loadString(jsonFile);

    late Map<String, dynamic> _result;

    try{
      _result = json.decode(data);
      debugPrint("Json Recuperado");
    } catch (e){
      _result = {};
      debugPrint("Erro ao recuperar Json");
    }

    debugPrint(_result.toString());
    return _result;
  }

  _loadJson() async {
    jsonFiles = await changeJson();
    setState(() {
      jsonFiles;
    });
  }

  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: jsonFiles == null ?
      const Center(child: CircularProgressIndicator(),):
      PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          HomeScreen(jsonFiles, pageController),
          VideoScreen(jsonFiles, pageController),
          AudioScreen(jsonFiles, pageController),
          PdfScreen(jsonFiles, pageController),
        ],
      )
    );
  }
}