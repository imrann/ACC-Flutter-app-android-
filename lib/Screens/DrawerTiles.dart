import 'package:aayush_carrom_club/Screens/Login.dart';
import 'package:aayush_carrom_club/Screens/WebViewContainer.dart';
import 'package:aayush_carrom_club/SharedPref/UserDetailsSP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog progressDialogotp;

class DrawerTiles extends StatelessWidget {
  DrawerTiles({this.icon, this.title});

  final Widget icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    progressDialogotp = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogotp.style(
        message: "Please Wait...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

    return ListTile(
        leading: icon,
        title: Text(title),
        onTap: () {
          if (title == "Logout") {
            progressDialogotp.show().then((value) {
              if (value) {
                _signOut(context);
              }
            });
          } else if (title == "ACC Youtube Channel") {
            Navigator.of(context).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WebViewContainer()));
          } else if (title == "Payent Details") {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Payment Details'),
                    content: SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Row(
                            children: [SelectableText("Phone No : 8850558137")],
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              SelectableText("UPI ID : 8850558137@ybl")
                            ],
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      // FlatButton(
                      //   child: Text('NO'),
                      //   onPressed: () {
                      //     Navigator.of(context).pop(false);
                      //   },
                      // ),
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => WebViewContainer()));
          }
        });
  }

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    progressDialogotp.hide().then((isHidden) {
      if (isHidden) {
        UserDetailsSP().logOutUser();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }
}
