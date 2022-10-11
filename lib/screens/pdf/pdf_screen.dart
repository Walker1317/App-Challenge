import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

//ignore: must_be_immutable
class PdfScreen extends StatefulWidget {
  PdfScreen(this.jsonFiles, this.pageController, {super.key});
  Map<String, dynamic>? jsonFiles;
  PageController pageController;

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PFD View"),
        leading: IconButton(
          onPressed: (){
            widget.pageController.jumpToPage(0);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SfPdfViewer.asset("assets/os-lusiadas.pdf")
    );
  }
}