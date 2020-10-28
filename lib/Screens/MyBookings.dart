import 'dart:io';

import 'package:aayush_carrom_club/Screens/AppBarCommon.dart';
import 'package:aayush_carrom_club/Screens/ErrorPage.dart';
import 'package:aayush_carrom_club/Screens/FancyLoader.dart';
import 'package:aayush_carrom_club/Screens/Home.dart';
import 'package:aayush_carrom_club/Screens/Shop.dart';
import 'package:aayush_carrom_club/Screens/StateManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'DrawerNav.dart';

String enteredBookingCode = '';
bool _clearFilter;

FloatingActionButtonLocation fab = FloatingActionButtonLocation.endDocked;
FloatingActionButtonLocation totalFab = FloatingActionButtonLocation.endDocked;

class MyBookings extends StatefulWidget {
  final String user;
  final String phone;
  final String slots;
  final String userID;
  final String userRole;
  final String showNew;

  MyBookings(
      {this.user,
      this.phone,
      this.slots,
      this.userID,
      this.userRole,
      this.showNew});

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProgressDialog progressDialog;

  int selectedIndex =
      1; //to handle which item is currently selected in the bottom app bar
  String text = "MyBookings";

  @override
  void initState() {
    fab = FloatingActionButtonLocation.endFloat;
    _clearFilter = false;
    super.initState();
  }

  void updateTabSelection(int index) {
    setState(() {
      selectedIndex = index;
      print(index);
      if (index == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBookings(
                      user: widget.user,
                      phone: widget.phone,
                      userID: widget.userID,
                      userRole: widget.userRole,
                      showNew: widget.showNew == "true" ? "true" : null,
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
                      userRole: widget.userRole,
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
        trailingIcon: Icons.search,
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "",
      ),
      drawer: Drawer(
        child: DrawerNav(
          phoneNo: widget.phone,
          userName: widget.user,
          userRole: widget.userRole,
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
                top: 80,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Container(color: Colors.grey[200]),
                )),
            Positioned(
                top: 10,
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    child: _getMyBookings(),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButtonLocation: fab,

      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //specify the location of the FAB

      floatingActionButton: Consumer<StateManager>(
        builder: (context, clearFilter, child) {
          return Visibility(
            visible: clearFilter.getClearFilter(),
            child: FloatingActionButton.extended(
                icon: Icon(Icons.clear),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0))),
                label: Text(
                  "Clear Filter",
                ),
                backgroundColor: Theme.of(context).primaryColor,
                splashColor: Colors.white,
                onPressed: () {
                  var searchDateState =
                      Provider.of<StateManager>(context, listen: false);
                  searchDateState.setSearchDate("WholeList");

                  searchDateState.setClearFilter(false);
                }),
          );
        },
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

  // Widget getIconButton(int sIndex, String pageName, IconData pageIcon) {
  //   return IconButton(
  //     //update the bottom app bar view each time an item is clicked
  //     onPressed: () {
  //     //  updateTabSelection(sIndex, pageName);
  //     },
  //     iconSize: 27.0,
  //     icon: Icon(
  //       pageIcon,
  //       //darken the icon if it is selected or else give it a different color
  //       color: selectedIndex == sIndex
  //           ? Theme.of(context).primaryColor
  //           : Colors.grey[350],
  //     ),
  //   );
  // }

  Widget getTitle(bool isTitle) {
    return isTitle == true
        ? Text(
            "My Bookings".toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              wordSpacing: 1,
              fontStyle: FontStyle.normal,
            ),
          )
        : Text("${widget.user}",
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              wordSpacing: 1,
              fontStyle: FontStyle.normal,
            ));
  }

  String _getReson(String reason, int position) {
    if (reason == "payment  failed") {
      var listString = reason.split("  ");
      return listString[position];
    } else if (position == 0) {
      return reason;
    } else {
      return "";
    }
  }

  Widget _getMyBookings() {
    final databaseReference = Firestore.instance;
    return Consumer<StateManager>(
      builder: (context, searchValue, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: widget.userRole != 'Admin'
              ? databaseReference
                  .collection('Bookings')
                  .where('userID', isEqualTo: widget.userID)
                  .orderBy('creationDate', descending: true)
                  .snapshots()
              : databaseReference
                  .collection('Bookings')
                  .orderBy('creationDate', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              print("hasError");
              print(snapshot.error);

              return ErrorPage(error: error.toString());
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> data = snapshot.data.documents;

              if (searchValue.getSearchDate() != null) {
                if (searchValue.getSearchDate() != "WholeList") {
                  data.removeWhere((element) => !element['bookingDate']
                      .toString()
                      .contains(searchValue.getSearchDate()));

                  print(data.length);

                  print(searchValue.getSearchDate().toString() + "kk");
                }
              } else {
                print("empty");
              }

              if (data.isEmpty || data.length == null) {
                return Center(
                  child: Text("There are No bookings!",
                      style: TextStyle(
                          color: Colors.black,
                          //fontWeight: FontWeight.bold,
                          fontSize: 15)),
                );
              } else {
                // return _buildList(context, lSnapshotData);
                return Scrollbar(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Column(children: <Widget>[
                        ListTile(
                          dense: true,
                          focusColor: Theme.of(context).primaryColor,
                          isThreeLine: true,
                          title: (widget.userID == data[index]['userID'] &&
                                  widget.userRole == "Admin")
                              ? Row(
                                  children: [
                                    Text(data[index]['userName'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    Text("(Admin's Booking)",
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 10)),
                                    (null == widget.showNew ||
                                            index != 0.toInt() ||
                                            (null !=
                                                    searchValue
                                                        .getSearchDate() &&
                                                searchValue.getSearchDate() !=
                                                    "WholeList"))
                                        ? SizedBox(width: 0)
                                        : Shimmer.fromColors(
                                            baseColor: Colors.grey[300],
                                            period: Duration(milliseconds: 500),
                                            highlightColor: Colors.red,
                                            child: Text("  NEW",
                                                style: TextStyle(
                                                    wordSpacing: 1,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                          ),
                                  ],
                                )
                              : (widget.userRole == "Admin")
                                  ? Row(
                                      children: [
                                        Text(data[index]['userName'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                        (null == widget.showNew ||
                                                index != 0.toInt() ||
                                                (null !=
                                                        searchValue
                                                            .getSearchDate() &&
                                                    searchValue
                                                            .getSearchDate() !=
                                                        "WholeList"))
                                            ? SizedBox(width: 0)
                                            : Shimmer.fromColors(
                                                baseColor: Colors.grey[300],
                                                period:
                                                    Duration(milliseconds: 500),
                                                highlightColor: Colors.red,
                                                child: Text("  NEW",
                                                    style: TextStyle(
                                                        wordSpacing: 1,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15))),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Text(data[index]['bookingDate'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                        (null == widget.showNew ||
                                                index != 0.toInt() ||
                                                (null !=
                                                        searchValue
                                                            .getSearchDate() &&
                                                    searchValue
                                                            .getSearchDate() !=
                                                        "WholeList"))
                                            ? SizedBox(width: 0)
                                            : Shimmer.fromColors(
                                                baseColor: Colors.grey[300],
                                                period:
                                                    Duration(milliseconds: 500),
                                                highlightColor: Colors.red,
                                                child: Text("  NEW",
                                                    style: TextStyle(
                                                        wordSpacing: 1,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15)),
                                              ),
                                      ],
                                    ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                        data[index]['mode'] +
                                            "\n" +
                                            data[index]['phone'] +
                                            "\n\n" +
                                            data[index]['slotTime'],
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 11)),
                                  )
                                ],
                              ),
                              widget.userRole == "Admin"
                                  ? Row(
                                      children: [
                                        Text(data[index]['bookingDate'],
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15)),
                                      ],
                                    )
                                  : SizedBox(height: 0)
                            ],
                          ),
                          leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                  data[index]['status']
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30))),

                          trailing: Text(
                              data[index]['status'] == "cancelled"
                                  ? data[index]['status'] +
                                      "\n" +
                                      _getReson(
                                          data[index]['reasonForCancle'], 0) +
                                      "\n" +
                                      _getReson(
                                          data[index]['reasonForCancle'], 1)
                                  : data[index]['status'],
                              style: TextStyle(
                                  color: (data[index]['status']) == "booked"
                                      ? Colors.green
                                      : (data[index]['status']) == "played"
                                          ? Colors.grey
                                          : Colors.red,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),

                          //Text("${data[index].mark}",style: TextStyle(color: Colors.deepPurple[900]))
                          onTap: () {
                            if (widget.userRole == 'Admin') {
                              showAlertDialog(
                                context,
                                data[index]['DocId'],
                                data[index]['confirmationCode'],
                                "Admin",
                                data[index]['status'],
                                data[index]['userID'],
                              );
                            } else if (widget.userRole == 'User') {
                              showAlertDialog(
                                  context,
                                  data[index]['DocId'],
                                  data[index]['confirmationCode'],
                                  "User",
                                  data[index]['status'],
                                  data[index]['userID']);
                            }
                          },
                        ),
                        Divider(
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        )
                      ]);
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

  Widget _getContent(String id, String confirmationCode, String role,
      String status, String bookedUserID) {
    if (status == 'played' && role == 'Admin') {
      return Text(" User already played the game.");
    } else if (status == 'played' && role != 'Admin') {
      return Text("Thanks for playing with us.");
    } else if (status == 'cancelled') {
      return Text("This booking got cancelled.");
    } else if (status == 'booked' && role != 'Admin') {
      return Container(
        height: 100,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Confirmation code: ",
                ),
                Row(
                  children: [
                    Text(
                      confirmationCode,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      );
    } else if (status == 'booked' &&
        role == 'Admin' &&
        bookedUserID == widget.userID) {
      return Container(
        height: 200,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "This booking is done by you. ",
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "As an admin,\nYou can take direct action",
                ),
              ],
            ),
          ],
        ),
      );
    } else if (status == 'booked' && role == 'Admin') {
      return Container(
        height: 200,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Enter code to verify booking ",
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Container(
                    height: 40,
                    width: 150,
                    child: TextFormField(
                      cursorColor: Colors.teal,
                      key: _formKey,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(6),
                      ],
                      autofocus: true,
                      readOnly: false,
                      //  autovalidate: _autoValidate,
                      // validator: _userNameValidator,
                      controller: _codeController,
                      //  enabled: !lreadonlyForm,
                      style: TextStyle(color: Theme.of(context).primaryColor),

                      decoration: InputDecoration(
                          hintText: " Confirmation Code",
                          hintStyle: TextStyle(fontSize: 15)),
                      // focusedBorder: InputBorder.none,
                      // border: InputBorder.none),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Text("Happy Playing!");
    }
  }

  showAlertDialog(BuildContext context, String id, String confirmationCode,
      String role, String status, String bookedUserID) {
    // set up the buttons
    Widget markPlayedButton = FlatButton(
      child: Text("Verify & Mark played"),
      onPressed: () {
        if (_codeController.text == confirmationCode) {
          _updatePlayedOrCancle("played", id);
        } else {
          Fluttertoast.showToast(
              msg: "WRONG CODE",
              fontSize: 20,
              backgroundColor: Colors.grey[850]);
        }
      },
    );
    Widget markCancelButton = FlatButton(
      child: Text("Mark Cancle"),
      onPressed: () {
        print("Mark Cancle");
        _updatePlayedOrCancle("cancle", id);
      },
    );

    Widget markPlayedAdminButton = FlatButton(
      child: Text("Mark Played"),
      onPressed: () {
        print("Mark Played");

        _updatePlayedOrCancle("played", id);
      },
    );

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget tryButton = FlatButton(
      child: Text("Try Again"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hi There!"),
      content: _getContent(id, confirmationCode, role, status, bookedUserID),
      actions: [
        (status == 'played')
            ? okButton
            : (status == 'booked' &&
                    role == 'Admin' &&
                    bookedUserID == widget.userID)
                ? Column(
                    children: [
                      Row(
                        children: [markPlayedAdminButton, markCancelButton],
                      )
                    ],
                  )
                : (status == 'booked' && role == 'Admin')
                    ? Column(
                        children: [
                          Row(
                            children: [markPlayedButton, markCancelButton],
                          )
                        ],
                      )
                    : (status == 'booked' && role != 'Admin')
                        ? okButton
                        : okButton
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _updatePlayedOrCancle(String action, String id) async {
    Navigator.of(context).pop();
    print("after");
    progressDialog.show().then((isShown) {
      print("before");
      print(isShown.toString());
      if (isShown) {
        print("inside");
        if (action == "played") {
          final dbRef = Firestore.instance
              .collection("Bookings")
              .document(id)
              .updateData({"status": "played"}).then((value) {
            final databaseReference = Firestore.instance;
            databaseReference
                .collection("Payments")
                .where("bookingsDocID", isEqualTo: id)
                .getDocuments()
                .then((value) {
              value.documents.forEach((result) {
                databaseReference
                    .collection("Payments")
                    .document(result.documentID)
                    .updateData({"transactionStatus": "success"});
              });
            });
          });
        } else if (action == "cancle") {
          final dbRef = Firestore.instance
              .collection("Bookings")
              .document(id)
              .setData({"status": "cancelled", 'reasonForCancle': 'by Admin'},
                  merge: true).then((value) {
            final databaseReference = Firestore.instance;
            databaseReference
                .collection("Payments")
                .where("bookingsDocID", isEqualTo: id)
                .getDocuments()
                .then((value) {
              value.documents.forEach((result) {
                databaseReference
                    .collection("Payments")
                    .document(result.documentID)
                    .updateData({"transactionStatus": "failure"});

                databaseReference
                    .collection("TotalBalance")
                    .document("o8IeiiVaNNE1dGG9kNxJ")
                    .get()
                    .then((totalbalanceDoc) {
                  print(totalbalanceDoc['total']);
                  databaseReference
                      .collection("TotalBalance")
                      .document("o8IeiiVaNNE1dGG9kNxJ")
                      .setData({
                    'total': totalbalanceDoc['total'] - result.data['amount']
                  }, merge: true);
                });
              });
            });
          });
        }
        progressDialog.hide().then((isHidden) {
          if (isHidden) {
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                "Status Marked!!",
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 2),
            ));
          }
        });
      }
    });
  }
}
