import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web_scraper/web_scraper.dart';

class SimpleReaderScreen extends StatefulWidget {
  final String mangaChapters;

  const SimpleReaderScreen({Key? key, required this.mangaChapters})
      : super(key: key);
  @override
  State<SimpleReaderScreen> createState() => _SimpleReaderScreenState();
}

class _SimpleReaderScreenState extends State<SimpleReaderScreen> {
  List<Map<String, dynamic>> mangaContent = [];
  int pages = 1;
  bool mangaData = false;
  ScrollController _scrollController = new ScrollController();

  //Gets the manga content from the web with WebScrapper package
  static const String baseUrl = "http://www.mangatown.com";
  void getMangaContent() async {
    String tempBaseUrl = baseUrl;
    String tempRoute = widget.mangaChapters + '$pages' + '.html';

    final webscrapper = WebScraper(tempBaseUrl);

    if (await webscrapper.loadWebPage(tempRoute)) {
      mangaContent = webscrapper.getElement(
          'body > section.main.black-bg.clearfix > div#viewer.read_img > a > img#image',
          ['src']);

      setState(() {
        mangaData = true;
      });
    }
  }

//Changes the page state
  void stateA() {
    setState(() {
      pages++;
      getMangaContent();
    });
  }

  void stateB() {
    setState(() {
      pages--;
      getMangaContent();
    });
  }

  @override
  void initState() {
    super.initState();
    getMangaContent();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMangaContent();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manga Reader'),
          actions: [
            //Changes the state page state with a forward and backward button
            IconButton(
                onPressed: () {
                  stateB();
                },
                icon: Icon(Icons.arrow_back)),
            IconButton(
                onPressed: () {
                  stateA();
                },
                icon: Icon(Icons.arrow_forward)),
          ],
        ),
        body: mangaData
            ? SingleChildScrollView(
                child: Container(
                    child: Column(children: [
                  MangaContent(
                    scrollController: _scrollController,
                    mangaContent: mangaContent,
                    page: '$pages',
                  ),
                ])),
              )
            : Container(
                padding: EdgeInsets.all(200),
                child: CircularProgressIndicator(),
              ));
  }
}

//Shows the content of the manga for each chapter
class MangaContent extends StatelessWidget {
  final scrollController;
  final String page;
  final List<Map<String, dynamic>> mangaContent;
  const MangaContent(
      {Key? key,
      required this.mangaContent,
      required this.scrollController,
      required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: mangaContent.length,
            itemBuilder: (context, int index) {
              return Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Page: ' + page,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.network(
                      "https:" +
                          mangaContent[index]['attributes']['src']
                              .toString()
                              .trim(),
                      fit: BoxFit.fitWidth,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;

                        return Container(
                          padding: EdgeInsets.all(150),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ],
                ),
              );
            }));
  }
}
