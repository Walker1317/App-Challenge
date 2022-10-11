import 'package:flutter/material.dart';

//ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen(this.jsonFiles, this.pageController, {super.key});
  Map<String, dynamic>? jsonFiles;
  PageController pageController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    Widget button(String title, IconData icon, Function() onPressed){
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40,),
            const SizedBox(height: 10,),
            Text(title)
          ],
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mobile Challenge"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            children: [
              button("Vídeo", Icons.movie_outlined, (){
                widget.pageController.jumpToPage(1);
              }),
              button("Música", Icons.music_note, (){
                widget.pageController.jumpToPage(2);
              }),
              button("Livro", Icons.book_outlined, (){
                widget.pageController.jumpToPage(3);
              }),
            ],
          ),
        ],
      ),
    );
  }
}