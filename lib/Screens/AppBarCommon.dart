import 'package:aayush_carrom_club/Screens/StateManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool l_isSearch;
String selectedDateTime;

class AppBarCommon extends StatefulWidget implements PreferredSizeWidget {
  AppBarCommon(
      {this.title,
      this.subTitle,
      this.trailingIcon,
      this.profileIcon,
      this.centerTile,
      this.context,
      this.route,
      this.notificationCount,
      this.isTabBar,
      this.isSearch,
      this.searchOwner});

  final Widget title;
  final Widget subTitle;
  final IconData trailingIcon;
  final IconData profileIcon;
  final bool centerTile;
  final BuildContext context;
  final Widget route;
  final Widget notificationCount;
  final bool isTabBar;
  final bool isSearch;
  final String searchOwner;

  @override
  _AppBarCommonState createState() => _AppBarCommonState();
  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _AppBarCommonState extends State<AppBarCommon> {
  @override
  void initState() {
    super.initState();
    l_isSearch = widget.isSearch;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: getTabBar(isTabBar: widget.isTabBar),
      centerTitle: widget.centerTile,
      elevation: 0.0,
      // backgroundColor:Theme.of(context).primaryColor,
      title: l_isSearch != null
          ? getSearchBox()
          : getTitle(title: widget.title, subTitle: widget.subTitle),
      actions: <Widget>[
        SizedBox(width: 5),
        getIcon(widget.profileIcon, context, widget.route,
            widget.notificationCount),
        l_isSearch != null
            ? getIcon(Icons.close, context, null, null)
            : getIcon(widget.trailingIcon, context, widget.route,
                widget.notificationCount),
      ],
      bottomOpacity: 1,
    );
  }

  Widget getSearchBox() {
    return TextFormField(
      autofocus: true,
      readOnly: false,
      validator: null,
      enabled: true,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        hintText: "Search...",
        hintStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.text,
      onChanged: (text) {
        searchStart(dynamicSearchText: text, listAllData: false);
      },
    );
  }

  searchStart({String dynamicSearchText, bool listAllData}) {
    print(dynamicSearchText);
  }

  Widget getTabBar({bool isTabBar}) {
    if (isTabBar) {
      return TabBar(
        tabs: [
          Tab(
            text: "Pharmacy",
          ),
          Tab(text: "Chain"),
        ],
        indicatorColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
      );
    } else {
      return null;
    }
  }

  Widget getIcon(IconData icon, BuildContext context, Widget route,
      Widget notificationCount) {
    final IconData iconCompare = Icons.notifications;
    if (null != icon) {
      return new Container(
        child: Row(
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.circular(100),
              child: iconCompare == icon ? Icon(icon) : Icon(icon),
              onTap: () {
                // if (icon == Icons.search) {
                //   print("search");
                //   setState(() {
                //     l_isSearch = true;
                //   });
                // } else
                if (icon == Icons.close) {
                  print("close search");
                  searchStart(listAllData: true);
                  setState(() {
                    l_isSearch = null;
                  });
                } else if (icon == Icons.search) {
                  print("calender");
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  ).then((date) {
                    setState(() {
                      if (widget.searchOwner == "Transactions") {
                        selectedDateTime = date.toString().substring(0, 10);
                        var searchDateStateTrans =
                            Provider.of<StateManager>(context, listen: false);
                        searchDateStateTrans
                            .setSearchDateTrans(selectedDateTime);

                        searchDateStateTrans.setClearFilterTrans(true);

                        Firestore.instance
                            .collection('Payments')
                            .where('TransactionDate',
                                isEqualTo: selectedDateTime)
                            .getDocuments()
                            .then((value) {
                          List<DocumentSnapshot> data = value.documents;

                          data.removeWhere((element) =>
                              !element['transactionStatus']
                                  .toString()
                                  .contains("success"));
                          var totalBalance = 0;
                          for (int i = 0; i < data.length; i++) {
                            totalBalance =
                                num.parse(data[i]['amount'].toString()) +
                                    totalBalance;
                          }
                          searchDateStateTrans
                              .setBalance(totalBalance.toString());
                        });
                      } else {
                        selectedDateTime = date.toString().substring(0, 10);
                        var searchDateState =
                            Provider.of<StateManager>(context, listen: false);
                        searchDateState.setSearchDate(selectedDateTime);

                        searchDateState.setClearFilter(true);
                      }

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => SlotBooking(
                      //               phone: widget.phone,
                      //               user: widget.user,
                      //               date: selectedDateTime,
                      //               userID: widget.userID,
                      //               userRole: role,
                      //             )));
                    });
                  });
                } else {
                  print("Notification");
                }

                //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Maintainance()),);
              },
            ),
            SizedBox(width: 15),
          ],
        ),
      );
    } else {
      return SizedBox(width: 0);
    }
  }

  Widget getTitle({Widget title, Widget subTitle}) {
    if (title != null && subTitle != null) {
      return new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[title],
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[subTitle],
            )
          ],
        ),
      );
    } else if (title != null && subTitle == null) {
      return title;
    } else {
      return new Text("Your Pharmacy");
    }
  }
}
