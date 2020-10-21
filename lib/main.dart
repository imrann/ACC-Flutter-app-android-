import 'package:aayush_carrom_club/Screens/Home.dart';
import 'package:aayush_carrom_club/Screens/Login.dart';
import 'package:aayush_carrom_club/Screens/Maintainance.dart';
import 'package:aayush_carrom_club/Screens/Splash.dart';
import 'package:aayush_carrom_club/Screens/StateManager.dart';
import 'package:aayush_carrom_club/SharedPref/UserDetailsSP.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAuth.instance.currentUser().then((currentUser) => {
        UserDetailsSP().getUserDetails().then((value) {
          Future.delayed(Duration(seconds: 2), () {
            if (currentUser != null) {
              runApp(MyApp("HomePage", value["uName"], value["uPhoneNumber"],
                  value["uID"]));
            } else {
              runApp(MyApp("LoginPage", value["uName"], value["uPhoneNumber"],
                  value["uID"]));
            }
          });
        })
      });
  runApp(MyApp("SplashScreen", "No User", "No Number", "No uID"));

  // UserDetailsSP().getUserDetails().then((value) {
  //   if (value["uLoggedIn"] == true) {
  //     runApp(MyApp(
  //         "HomePage", value["uName"], value["uPhoneNumber"], value["uID"]));
  //   } else if (value["uLoggedIn"] == false) {
  //     print("0");
  //     runApp(MyApp(
  //         "LoginPage", value["uName"], value["uPhoneNumber"], value["uID"]));
  //   } else if (value["uLoggedIn"] == "SplashScreen") {
  //     print("1");
  //     runApp(MyApp(
  //         "LoginPage", value["uName"], value["uPhoneNumber"], value["uID"]));
  //   } else {
  //     print("2");
  //     runApp(MyApp(
  //         "LoginPage", value["uName"], value["uPhoneNumber"], value["uID"]));
  //   }
  // });
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF000000, color);

class MyApp extends StatelessWidget {
  MyApp(this.redirect, this.userName, this.phone, this.userID);

  final String redirect;
  final String userName;
  final String phone;
  final String userID;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StateManager()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: colorCustom,

          primaryColor: colorCustom,
          // buttonColor: Colors.teal,
          backgroundColor: Colors.grey[200],
          // //put primaryColorLight..wher ever u encounters backgroundcolor
          primaryColorLight: colorCustom,
          // primaryColorDark: Colors.black,
          // splashColor: Colors.white,
          // highlightColor: Colors.grey[500],
          // // cardColor: Colors.orangeAccent[400],
          // errorColor: Colors.red,
          // cursorColor: Colors.white

          // canvasColor: colorCustom,
        ),
        home: _getStartupScreens(redirect, context),
      ),
    );
  }

  Widget _getStartupScreens(String redirectPage, BuildContext context) {
    print(redirectPage);

    if (redirectPage == "LoginPage") {
      return Login();
    } else if (redirectPage == "HomePage") {
      return Home(
        user: userName.toString(),
        phone: phone.toString(),
        userID: userID.toString(),
      );
    } else if (redirectPage == "SplashScreen") {
      return Splash();
    }

    return Maintainance();
  }
}
