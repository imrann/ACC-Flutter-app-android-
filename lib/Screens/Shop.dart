import 'dart:io';

import 'package:aayush_carrom_club/Screens/AppBarCommon.dart';
import 'package:aayush_carrom_club/Screens/ErrorPage.dart';
import 'package:aayush_carrom_club/Screens/FancyLoader.dart';
import 'package:aayush_carrom_club/Screens/Home.dart';
import 'package:aayush_carrom_club/Screens/MyBookings.dart';
import 'package:aayush_carrom_club/Screens/StateManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'DrawerNav.dart';

int totalBalance;

FloatingActionButtonLocation fab = FloatingActionButtonLocation.endDocked;

class Shop extends StatefulWidget {
  final String user;
  final String phone;
  final String userID;
  final String userRole;

  Shop({this.user, this.phone, this.userID, this.userRole});

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;

  int selectedIndex =
      2; //to handle which item is currently selected in the bottom app bar
  String text = "Shop";

  @override
  void initState() {
    fab = FloatingActionButtonLocation.miniEndFloat;
    totalBalance = 0;
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
        searchOwner: "Transactions",
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
                child: Container(
                  child: _getMyTransactions(),
                )),
            widget.userRole == 'Admin'
                ? Positioned(
                    top: (MediaQuery.of(context).size.width * 20.5) / 100,
                    left: (MediaQuery.of(context).size.width * 65) / 100,
                    right: 0,
                    child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                            bottom: Radius.circular(10)),
                        child: Center(
                          child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: _getMyBalance(),
                              ),
                              color: Colors.teal),
                        )))
                : SizedBox(height: 0),
          ],
        ),
      ),

      floatingActionButtonLocation: fab,

      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //specify the location of the FAB

      floatingActionButton: Consumer<StateManager>(
        builder: (context, clearFilterTrans, child) {
          return Visibility(
            visible: clearFilterTrans.getClearFilterTrans(),
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
                  var searchDateStateTrans =
                      Provider.of<StateManager>(context, listen: false);
                  searchDateStateTrans.setSearchDateTrans("WholeList");
                  clearFilterTrans.setBalance("xxxxxx");

                  searchDateStateTrans.setClearFilterTrans(false);
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
              title: Text(
                'Home',
                style: TextStyle(color: Colors.white),
              )),
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

  Widget _getMyBalance() {
    return Consumer<StateManager>(
      builder: (context, balance, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('TotalBalance').snapshots(),
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
              // tdata = data;
              // tdata.removeWhere((element) =>
              //     !element['transactionStatus'].toString().contains("success"));

              // for (int i = 0; i < tdata.length; i++) {
              //   totalBalance =
              //       num.parse(tdata[i]['amount'].toString()) + totalBalance;
              // }
              // print("total: " + totalBalance.toString());
              // setState(() {
              //   totalBalance = total;
              // });

              if (data.isEmpty || data.length == null) {
                return Center(
                  child: Text("Balance: xxxxxx",
                      style: TextStyle(
                          color: Colors.white,
                          //fontWeight: FontWeight.bold,
                          fontSize: 15)),
                );
              } else {
                String tempbal = balance.getBalance();
                if (tempbal == "xxxxxx") {
                  return Text("Balance: " + data[0]['total'].toString(),
                      style: TextStyle(
                          color: Colors.white,
                          //fontWeight: FontWeight.bold,
                          fontSize: 15));
                } else {
                  return Text("Balance: " + tempbal,
                      style: TextStyle(
                          color: Colors.white,
                          //fontWeight: FontWeight.bold,
                          fontSize: 15));
                }
              }
            } else {
              return Text("Balance: Loading.",
                  style: TextStyle(
                      color: Colors.white,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15));
            }
          },
        );
      },
    );
  }

  Widget _getMyTransactions() {
    return Consumer<StateManager>(
      builder: (context, searchValueTrans, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: widget.userRole != 'Admin'
              ? Firestore.instance
                  .collection('Payments')
                  .where('userID', isEqualTo: widget.userID)
                  .orderBy('TransactionDate', descending: true)
                  .snapshots()
              : Firestore.instance
                  .collection('Payments')
                  .orderBy('TransactionDate', descending: true)
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

              if (searchValueTrans.getSearchDateTrans() != null) {
                if (searchValueTrans.getSearchDateTrans() != "WholeList") {
                  data.removeWhere((element) => !element['TransactionDate']
                      .toString()
                      .contains(searchValueTrans.getSearchDateTrans()));

                  print(data.length);

                  print(
                      searchValueTrans.getSearchDateTrans().toString() + "kk");
                }
              } else {
                print("empty");
              }
              // tdata = data;
              // tdata.removeWhere((element) =>
              //     !element['transactionStatus'].toString().contains("success"));

              // for (int i = 0; i < tdata.length; i++) {
              //   totalBalance =
              //       num.parse(tdata[i]['amount'].toString()) + totalBalance;
              // }
              // print("total: " + totalBalance.toString());
              // setState(() {
              //   totalBalance = total;
              // });

              if (data.isEmpty || data.length == null) {
                return Center(
                  child: Text("There are no transactions yet!",
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
                      print(totalBalance);
                      return Column(children: <Widget>[
                        ListTile(
                          dense: true,
                          focusColor: Theme.of(context).primaryColor,
                          isThreeLine: true,
                          title: Text(data[index]['from'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text("To:  " + data[index]['to'],
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 11)),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(data[index]['TransactionDate'],
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 11)),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(data[index]['transactionStatus'],
                                      style: TextStyle(
                                          color: (data[index]
                                                      ['transactionStatus'] ==
                                                  'success')
                                              ? Colors.green
                                              : (data[index][
                                                          'transactionStatus'] ==
                                                      'payment pending')
                                                  ? Colors.yellow[700]
                                                  : Colors.red,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15)),
                                ],
                              )
                            ],
                          ),
                          leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey[200],
                              child: data[index]['transactionStatus'] ==
                                      "success"
                                  ? Icon(
                                      Icons.done,
                                      size: 55,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    )
                                  : Icon(
                                      Icons.error_outline,
                                      size: 55,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    )),

                          trailing: Text(
                              "Rs." + data[index]['amount'].toString(),
                              style: TextStyle(
                                  color: (data[index]['transactionStatus']) ==
                                          "success"
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),

                          //Text("${data[index].mark}",style: TextStyle(color: Colors.deepPurple[900]))
                          onTap: () {},
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
            "Transactions".toUpperCase(),
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
}
