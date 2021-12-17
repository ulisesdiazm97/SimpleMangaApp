import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:simple_manga_app/widgets/manga_swiper.dart';

//Scaffold with Title, Search Field and Swiper
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [Title(), Search(), MangaSwiper()],
      ),
    ));
  }
}

//Title 'Manga Reader' and menu icon
class Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.blue,
            ),
            iconSize: 35,
            onPressed: () {},
          ),
          SizedBox(
            width: 35,
          ),
          Text(
            'Manga Reader',
            style: TextStyle(fontSize: 28),
          )
        ],
      ),
    );
  }
}

//Search Field
class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: TextField(
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      print('Search Manga');
                    },
                    child: Icon(Icons.search),
                  ),
                  contentPadding: EdgeInsets.all(12),
                  labelText: 'Search',
                  border: InputBorder.none),
            ),
          )
        ]),
      ),
    );
  }
}
