import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsSP {
  Future<dynamic> loginUser(FirebaseUser userDetails, String uName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("uID", userDetails.uid);
    preferences.setString("uPhoneNumber", userDetails.phoneNumber);
    preferences.setString("uName", uName);
    preferences.setBool("uLoggedIn", true);

    return true;
  }

  Future<dynamic> logOutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // var user = jsonEncode(userDetails);

    preferences.remove("uID");
    preferences.remove("uPhoneNumber");
    preferences.remove("uName");
    preferences.setBool("uLoggedIn", false);
  }

  Future<Map> getUserDetails() async {
    // String role = 'User';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userDetailsMap = new Map();

    // Firestore.instance.collection('Links').getDocuments().then((links) async {
    //   userDetailsMap["uLoggedIn"] = "SplashScreen";
    //   preferences.setString(
    //       "razorPayKey", links.documents[0]['razorPayKey'].toString());
    //   preferences.setString(
    //       "RazorPayValue", links.documents[0]['RazorPayValue'].toString());
    //   preferences.setString(
    //       "YoutubeLink", links.documents[0]['YoutubeLink'].toString());

    //       });

    // if (preferences.getBool("uLoggedIn") == null) {
    //   print(preferences.getBool("uLoggedIn") ?? "nulllll");
    //   userDetailsMap["uLoggedIn"] = null;
    // } else {
    //    }

    userDetailsMap["uID"] = preferences.getString("uID");
    userDetailsMap["uPhoneNumber"] = preferences.getString("uPhoneNumber");

    userDetailsMap["uName"] = preferences.getString("uName");

    userDetailsMap["uLoggedIn"] = preferences.getBool("uLoggedIn");

    return userDetailsMap;
  }
}
