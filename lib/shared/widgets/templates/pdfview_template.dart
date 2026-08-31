import 'dart:async';
import 'dart:io';

import 'package:myapp/shared/widgets/templates/appbar_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewTemplate extends StatefulWidget {
  final String? title, url;

  const PdfViewTemplate(
      {super.key,
      this.title = "Reader",
      this.url = "http://www.africau.edu/images/default/sample.pdf"});

  @override
  State<PdfViewTemplate> createState() => _PdfViewTemplateState();
}

class _PdfViewTemplateState extends State<PdfViewTemplate> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String remotePDFpath = "";

  @override
  void initState() {
    createFileOfPdfUrl().then((f) {
      setState(() => remotePDFpath = f.path);
    });
    super.initState();
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    debugPrint("Start download file from internet!");
    try {
      final url = widget.url!;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      debugPrint("Download files");
      debugPrint("${dir.path}/$filename");
      final path = "${dir.path}/$filename";
      File file = File(path);
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      setState(() {
        errorMessage = "Not Found";
      });
      throw Exception('Error parsing asset file!');
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return AppbarTemplate(
      title: widget.title!,
      isCustom: true,
      body: Stack(
        children: [
          remotePDFpath != ''
              ? PDFView(
                  filePath: remotePDFpath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                  onRender: (pages) {
                    setState(() {
                      pages = pages;
                      isReady = true;
                    });
                  },
                  onError: (error) {
                    debugPrint(error.toString());
                    setState(() {
                      errorMessage = "Not Found";
                    });
                  },
                  onPageError: (page, error) {
                    debugPrint('$page: ${error.toString()}');
                    setState(() {
                      errorMessage = "$page: ${error.toString()}";
                    });
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    _controller.complete(pdfViewController);
                  },
                )
              : errorMessage.isEmpty
                  ? !isReady
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container()
                  : Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_download_off_outlined, size: 80),
                          SizedBox(height: 20),
                          Text(errorMessage),
                        ],
                      )))
        ],
      ),
    );
  }
}
