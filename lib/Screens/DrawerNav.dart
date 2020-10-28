import 'package:flutter/material.dart';

import 'DrawerTiles.dart';

class DrawerNav extends StatefulWidget {
  final String userName;
  final String phoneNo;
  final String userRole;
  DrawerNav({this.userName, this.phoneNo, this.userRole});

  @override
  _DrawerNavState createState() => _DrawerNavState();
}

class _DrawerNavState extends State<DrawerNav> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        InkWell(
          child: Card(
              margin: EdgeInsets.all(0),
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Text(
                            // "IK",
                            widget.userName
                                .substring(0, 2)
                                .toString()
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          //"+918369275230",
                          widget.phoneNo,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          //"+918369275230",
                          "Aayush Carrom Club",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          color: Colors.red,
                          child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                widget.userRole,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        DrawerTiles(icon: Icon(Icons.play_arrow), title: 'ACC Youtube Channel'),
        Divider(thickness: 0.5, endIndent: 5, color: Colors.grey),
        DrawerTiles(icon: Icon(Icons.payment), title: 'Payent Details'),
        Divider(thickness: 0.5, endIndent: 5, color: Colors.grey),
        DrawerTiles(icon: Icon(Icons.people_outline), title: 'About Us'),
        Divider(thickness: 0.5, endIndent: 5, color: Colors.grey),
        DrawerTiles(icon: Icon(Icons.exit_to_app), title: 'Logout'),
        Divider(thickness: 0.5, endIndent: 5, color: Colors.grey),
      ],
    ));
  }
}
