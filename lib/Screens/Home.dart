import 'dart:async';
import 'dart:io';
import 'package:aayush_carrom_club/SharedPref/UserDetailsSP.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:aayush_carrom_club/Screens/AddNotice.dart';
import 'package:aayush_carrom_club/Screens/AppBarCommon.dart';
import 'package:aayush_carrom_club/Screens/ErrorPage.dart';
import 'package:aayush_carrom_club/Screens/FancyLoader.dart';
import 'package:aayush_carrom_club/Screens/MyBookings.dart';
import 'package:aayush_carrom_club/Screens/Shop.dart';
import 'package:aayush_carrom_club/Screens/SlotBooking.dart';
import 'package:aayush_carrom_club/Screens/StateManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'DrawerNav.dart';

bool selected;
List<String> selectedList;

final DateFormat format = new DateFormat("EEE, M/d/y").add_jms();

String role = 'User';
FloatingActionButtonLocation fab = FloatingActionButtonLocation.centerFloat;
FloatingActionButtonLocation miniFab = FloatingActionButtonLocation.centerFloat;

String selectedDateTime;

class Home extends StatefulWidget {
  final String user;
  final String phone;
  final String userID;
  Home({this.user, this.phone, this.userID});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // getToken() {
  //   _firebaseMessaging.getToken().then((token) {
  //     print("Device Token: $token");
  //   });
  // }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;

  int selectedIndex =
      0; //to handle which item is currently selected in the bottom app bar
  String text = "Home";

  @override
  void initState() {
    fab = FloatingActionButtonLocation.centerFloat;
    miniFab = FloatingActionButtonLocation.miniEndFloat;

    Firestore.instance
        .collection("Admin")
        .where('phone', isEqualTo: widget.phone)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        if (result != null) {
          if (result.data['role'] == 'Admin') {
            print(result.data.toString() + "jj");
            setState(() {
              role = 'Admin';
            });

            print(role + "dd");
          }
        } else {
          setState(() {
            role = 'User';
          });
        }
      });
    });
    super.initState();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    selectedList = [];
    selected = false;
    UserDetailsSP().getDeviceToken().then((sharedPtoken) {
      print("sharedPtoken: " + sharedPtoken);
      if (sharedPtoken == 'empty') {
        _firebaseMessaging.getToken().then((tokenValue) {
          print("tokenValue :" + tokenValue);
          UserDetailsSP().setDeviceToken(tokenValue);
          final databaseReference = Firestore.instance;

          databaseReference
              .collection("DecviceToken")
              .add({"deviceToken": tokenValue}).then((value) {});
        });
      }
    });

    getMessage();
  }

  Future _showNotificationWithDefaultSound(String title, String body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        priority: Priority.High, importance: Importance.Max);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future onSelectNotification(String payload) async {
    return null;
  }

// message['notification:']['title'], message['data:']['message:']
  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      // _showNotificationWithDefaultSound(
      //     message['notification']['title'].toString(),
      //     message['notification']['body'].toString());
      print('on message $message');
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    });
  }

  void updateTabSelection(int index) {
    setState(() {
      selectedIndex = index;
      print(index);
      if (index == 1) {
        print(widget.userID);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBookings(
                      user: widget.user,
                      phone: widget.phone,
                      userID: widget.userID,
                      userRole: role,
                    )));
      } else if (index == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      user: widget.user,
                      phone: widget.phone,
                      userID: widget.userID,
                    )));
      } else if (index == 2) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Shop(
                      user: widget.user,
                      phone: widget.phone,
                      userID: widget.userID,
                      userRole: role,
                    )));
      }
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
        message: "Please Wait...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: new AppBarCommon(
        title: getTitle(true),
        subTitle: getTitle(false),
        profileIcon: Icons.notifications,
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "MainSearch",
      ),
      drawer: Drawer(
        child: DrawerNav(
          phoneNo: widget.phone,
          userName: widget.user,
          userRole: role,
        ),
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
            ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 65, left: 15),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("${widget.user}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 1,
                                  fontStyle: FontStyle.normal,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 180,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _getNoticeBoardCards()),
                  ),
                )),
            role == 'Admin'
                ? Positioned(
                    top: (MediaQuery.of(context).size.width * 50) / 100,
                    left: selected == false
                        ? (MediaQuery.of(context).size.width * 53) / 100
                        : (MediaQuery.of(context).size.width * 67) / 100,
                    right: 0,
                    child: Center(
                      child: InkWell(
                        splashColor: Colors.redAccent[200],
                        onTap: () {
                          progressDialog.show().then((value) {
                            if (value) {
                              if (selected == true) {
                                for (var item in selectedList) {
                                  Firestore.instance
                                      .collection("NoticeBoard")
                                      .document(item)
                                      .delete();
                                }
                                progressDialog.hide();
                                setState(() {
                                  selected = false;
                                });
                                Fluttertoast.showToast(msg: "Deleted!");
                              } else {
                                progressDialog.hide();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddNotice(
                                              user: widget.user,
                                              phone: widget.phone,
                                              userID: widget.userID,
                                            )));
                              }
                            }
                          });
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              children: [
                                selected == false
                                    ? Icon(
                                        Icons.add,
                                        size: 30,
                                        color: Colors.black,
                                      )
                                    : Icon(
                                        Icons.delete,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                selected == false
                                    ? Text("Notice Board",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))
                                    : Text("Delete",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                : Positioned(
                    top: (MediaQuery.of(context).size.width * 50) / 100,
                    left: (MediaQuery.of(context).size.width * 65) / 100,
                    right: 0,
                    child: Center(
                      child: InkWell(
                        splashColor: Colors.redAccent[200],
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text("Notice Board",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ))
            // Container(
            //     child: Padding(
            //       padding: const EdgeInsets.all(3),
            //       child: Text("Notice Board",
            //           style: TextStyle(fontSize: 50, color: Colors.green)),
            //     ),
            //   ),
          ],
        ),
      ),
      floatingActionButtonLocation: fab,

      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //specify the location of the FAB
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton.extended(
                  icon: Icon(Icons.check),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  label: Text("Book Slots"),
                  backgroundColor: Theme.of(context).primaryColor,
                  splashColor: Colors.white,
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    ).then((date) {
                      setState(() {
                        selectedDateTime = date.toString().substring(0, 10);
                        print(selectedDateTime);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SlotBooking(
                                      phone: widget.phone,
                                      user: widget.user,
                                      date: selectedDateTime,
                                      userID: widget.userID,
                                      userRole: role,
                                    )));
                      });
                    });
                  }),
            ],
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        elevation: 10,

        //to add a space between the FAB and BottomAppBar
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              // ignore: deprecated_member_use
              title: Text('Home', style: TextStyle(color: Colors.white))),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.confirmation_number,
                color: Colors.white,
              ),
              // ignore: deprecated_member_use
              title:
                  Text('My Bookings', style: TextStyle(color: Colors.white))),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.compare_arrows,
                color: Colors.white,
              ),
              // ignore: deprecated_member_use
              title:
                  Text('Transactions', style: TextStyle(color: Colors.white))),
        ],
        currentIndex: selectedIndex,
        //   fixedColor: Colors.deepPurple,
        onTap: updateTabSelection,
      ),
    );

    /// );
  }

  Widget _getNoticeBoardCards() {
    return Consumer<StateManager>(
      builder: (context, searchValueTrans, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('NoticeBoard')
              .orderBy('createdDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              print("hasError");
              print(snapshot.error);

              return ErrorPage(error: error.toString());
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> data = snapshot.data.documents;
              // List<DocumentSnapshot> tdata = snapshot.data.documents;

              // if (searchValueTrans.getSearchDateTrans() != null) {
              //   if (searchValueTrans.getSearchDateTrans() != "WholeList") {
              //     data.removeWhere((element) => !element['TransactionDate']
              //         .toString()
              //         .contains(searchValueTrans.getSearchDateTrans()));

              //     print(data.length);

              //     print(
              //         searchValueTrans.getSearchDateTrans().toString() + "kk");
              //   }
              // } else {
              //   print("empty");
              // }

              if (data.isEmpty || data.length == null) {
                return Center(
                  child: Text(" No Notice Yet!",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                );
              } else {
                // return _buildList(context, lSnapshotData);
                return Scrollbar(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.white,
                        onLongPress: () {
                          if (role == 'Admin') {
                            print("before : " + selectedList.length.toString());
                            setState(() {
                              if (selectedList.length == 0 && selected) {
                                setState(() {
                                  selected = false;
                                });
                              } else {
                                selected = true;
                                if (selectedList.contains(
                                    data[index]['NoticeDocId'].toString())) {
                                  selectedList.remove(
                                      data[index]['NoticeDocId'].toString());
                                  HapticFeedback.selectionClick();
                                  selectedList.length == 0
                                      ? selected = false
                                      // ignore: unnecessary_statements
                                      : null;
                                } else {
                                  selectedList.add(
                                      data[index]['NoticeDocId'].toString());
                                  HapticFeedback.selectionClick();
                                }
                              }
                              print(
                                  "after : " + selectedList.length.toString());
                            });
                          } else {
                            return null;
                          }
                        },
                        onTap: () {
                          print("before : " + selectedList.length.toString());
                          selected == true
                              ? setState(() {
                                  if (selectedList.length == 0 && selected) {
                                    setState(() {
                                      selected = false;
                                    });
                                  } else {
                                    if (selectedList.contains(data[index]
                                            ['NoticeDocId']
                                        .toString())) {
                                      selectedList.remove(data[index]
                                              ['NoticeDocId']
                                          .toString());
                                      HapticFeedback.selectionClick();
                                      selectedList.length == 0
                                          ? selected = false
                                          // ignore: unnecessary_statements
                                          : null;
                                    } else {
                                      selectedList.add(data[index]
                                              ['NoticeDocId']
                                          .toString());
                                      HapticFeedback.selectionClick();
                                    }
                                  }
                                  print("after : " +
                                      selectedList.length.toString());
                                })
                              : noticeSlider(
                                  data[index]['title'],
                                  data[index]['description'],
                                  data[index]['title1'],
                                  data[index]['description1'],
                                  data[index]['title2'],
                                  data[index]['description2'],
                                  data[index]['title3'],
                                  data[index]['description3'],
                                  data[index]['title4'],
                                  data[index]['description4'],
                                  data[index]['title5'],
                                  data[index]['description5'],
                                  data[index]['title6'],
                                  data[index]['description6'],
                                  data[index]['title7'],
                                  data[index]['description7'],
                                  data[index]['title8'],
                                  data[index]['description8'],
                                  data[index]['createdDate']
                                      .toDate()
                                      .toString()
                                      .substring(0, 16),
                                  //
                                  context);
                        },
                        child: Card(
                          color: (selected == true &&
                                  selectedList.contains(
                                      data[index]['NoticeDocId'].toString()))
                              ? Colors.redAccent[700]
                              : Colors.redAccent[200],
                          child: Row(
                            children: [
                              Column(children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[index]['title'].toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                              data[index]['description']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Posted On: " +
                                                data[index]['createdDate']
                                                    .toDate()
                                                    .toString()
                                                    .substring(0, 16),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 10),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                              Column(
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 15,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            } else {
              return FancyLoader(
                loaderType: "list",
              );
            }
          },
        );
      },
    );
  }

  Widget getTitle(bool isTitle) {
    return isTitle == true
        ? Text(
            "${widget.phone}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              wordSpacing: 1,
              fontStyle: FontStyle.normal,
            ),
          )
        : Text("",
            style: TextStyle(
              fontSize: 0.0,
              fontWeight: FontWeight.bold,
              wordSpacing: 1,
              fontStyle: FontStyle.normal,
            ));
  }

  noticeSlider(
      String title,
      String description,
      String title1,
      String description1,
      String title2,
      String description2,
      String title3,
      String description3,
      String title4,
      String description4,
      String title5,
      String description5,
      String title6,
      String descriptio6,
      String title7,
      String descriptio7,
      String title8,
      String descriptio8,
      String date,
      BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (BuildContext context) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                return new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  child: new Center(
                      child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                description.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Posted On: " + date,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.grey[700],
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title1 ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                description1.toString() ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title2 ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                description2.toString() ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title3 ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                description3.toString() ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title4 ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                description4.toString() ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title5 ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                description5.toString() ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title6 ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                descriptio6.toString() ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title7 ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                descriptio7.toString() ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title8 ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(
                                descriptio8.toString() ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
                );
              }),
            ),
          );
        });
  }
}
