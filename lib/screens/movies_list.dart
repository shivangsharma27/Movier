import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/global.dart' as globals;
import 'new_movies.dart';

import '../models/Movie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final Function deleteTx;

  MovieList(this.movies, this.deleteTx);

  void _alertDialog(BuildContext context, int index) {
    Alert(
      style: AlertStyle(backgroundColor: globals.themeColor[50]),
      context: context,
      type: AlertType.warning,
      title: "Are u Sure?",
      desc: "This will permanently delete your movie.",
      buttons: [
        DialogButton(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.7],
            colors: [
              Color(0xff90A4AE),
              Color(0xff37474F),
            ],
          ),
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            deleteTx(movies[index].title);
            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.7],
            colors: [
              //Sunkist
              Color(0xff90A4AE),
              Color(0xff37474F),
            ],
          ),
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.85,
      child: movies.isEmpty
          ? Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 160,
                    child: Opacity(
                      child: Image.asset(
                        'assets/images/open-box.png',
                        fit: BoxFit.cover,
                      ),
                      opacity: 0.7,
                    ),
                  ),
            
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'No movies added yet!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
            
                ],
              ),
          )
          : ListView.builder(
              // physics: BouncingScrollPhysics(),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 24,
                      spreadRadius: 16,
                      color: Colors.black.withOpacity(0.2),
                    )
                  ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 0.0,
                        sigmaY: 0.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        margin: EdgeInsetsDirectional.all(5),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child:
                                      Image.file(File(movies[index].filePath)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            movies[index].title,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      movies[index]
                                                              .rating
                                                              .toString() +
                                                          " ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Icon(Icons.star,
                                                        size: 15,
                                                        color:
                                                            Colors.yellow[600]),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  movies[index].director,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      iconSize: 30,
                                      icon: Icon(Icons.delete),
                                      color: Color(0xffCAAF68),
                                      onPressed: () =>
                                          _alertDialog(context, index),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: movies.length,
            ),
    );
  }
}
 
// ListTile(
//                     dense: true,
//                     contentPadding:
//                         EdgeInsets.symmetric(vertical: 0, horizontal: 5),
//                     leading: Image.file(File(movies[index].filePath)),
//                     title: Text(
//                       movies[index].title,
//                       // style: Theme.of(context).textTheme.headline6,
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     subtitle: Text(
//                       movies[index].director,
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(movies[index].rating.toString()),
//                         IconButton(
//                           onPressed: () => {},
//                           icon: Icon(Icons.star),
//                           color: Colors.yellow,
//                         ),
//                         IconButton(
//                           iconSize: 30,
//                           icon: Icon(Icons.delete),
//                           color: globals.themeColor[900],
//                           onPressed: () => _alertDialog(context, index),
//                         ),
//                       ],
//                     ),
//                   ),
