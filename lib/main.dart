import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './widgets/global.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

import './screens/auth_screen.dart';
import 'screens/new_movies.dart';
import 'screens/movies_list.dart';
import 'models/Movie.dart';


String currUserEmail;
List<Movie> userMovies = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Personal Expenses',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(0xff263238, globals.themeColor),
          primaryColor: globals.themeColor[900],
          // accentColor: Colors.purple,
          canvasColor: globals.themeColor[500],
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline1: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline1: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (FirebaseAuth.instance.currentUser != null &&
                  globals.login == true) {
                currUserEmail = FirebaseAuth.instance.currentUser.email;
                return MyHomePage();
              } else {
                return AuthScreen();
              }
            })
        // (FirebaseAuth.instance.currentUser != null)? MyHomePage() : AuthScreen()
        );
  }
}

class MyHomePage extends StatefulWidget {
  // List<Movie> userMovies;
  // MyHomePage(this.userMovies);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;

  void _alertDialog(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.warning,
      style: AlertStyle(backgroundColor: globals.themeColor[50]),
      title: "Are u Sure?",
      desc: "You will be signed out.",
      buttons: [
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
            "YES",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async{
            userMovies = [];
            await globals.googleSignIn.disconnect();
            await FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.7],
            colors: [
              Color(0xff90A4AE),
              Color(0xff37474F),
            ],
          ),
        )
      ],
    ).show();
  }

  void _addNewMovie(
      String movieTitle, String director, String filePath, double rating) {
    final newTx = Movie(
      title: movieTitle,
      director: director,
      filePath: filePath,
      rating: rating,
    );

    setState(() {
      userMovies.add(newTx);
    });
  }

  void _startAddNewMovies(BuildContext ctx) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewMovie(_addNewMovie),
      ),
    );
    // showModalBottomSheet(
    //   context: ctx,
    //   builder: (_) {
    //     return GestureDetector(
    //       onTap: () {},
    //       child: NewMovie(_addNewMovie),
    //       behavior: HitTestBehavior.opaque,
    //     );
    //   },
    // );
  }

  void stat() {
    setState(() {});
  }

  void _deleteMovie(String id) {
    setState(() {
      userMovies.removeWhere((tx) => tx.title == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            'assets/images/Movier.png',
            width: 140,
            height: 45,
          ), //Text(
          //   'OutlayPlanner',
          // ),
          actions: [
            IconButton(
              icon: Image.asset('assets/images/userAccount1.png', width: 33,),
              onPressed: () => _alertDialog(context),
              padding: EdgeInsets.only(right: 8,top: 4),
            ),
          ],
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MovieList(userMovies, _deleteMovie),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                ],
              ),
            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            padding: MaterialStateProperty.all(EdgeInsets.all(13)),
            elevation: MaterialStateProperty.all(10),
            backgroundColor:
                MaterialStateProperty.all(Colors.blueGrey[800]),
          ),
          child: Text(
            'Add a movie',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () => _startAddNewMovies(context),
        ),
      ),
    );
  }
}
