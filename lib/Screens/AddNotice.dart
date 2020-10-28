import 'package:aayush_carrom_club/Screens/AppBarCommon.dart';
import 'package:aayush_carrom_club/Screens/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

FloatingActionButtonLocation fab = FloatingActionButtonLocation.endDocked;

int controllerPosition;

bool field1 = false;
bool field2 = false;
bool field3 = false;
bool field4 = false;
bool field5 = false;
bool field6 = false;
bool field7 = false;
bool field8 = false;
int countFields = 0;

class AddNotice extends StatefulWidget {
  final String user;
  final String phone;
  final String userID;
  AddNotice({this.user, this.phone, this.userID});
  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  TextEditingController titleController = TextEditingController();
  TextEditingController title1Controller = TextEditingController();
  TextEditingController title2Controller = TextEditingController();
  TextEditingController title3Controller = TextEditingController();
  TextEditingController title4Controller = TextEditingController();
  TextEditingController title5Controller = TextEditingController();
  TextEditingController title6Controller = TextEditingController();
  TextEditingController title7Controller = TextEditingController();
  TextEditingController title8Controller = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController description1Controller = TextEditingController();
  TextEditingController descriptio2Controller = TextEditingController();
  TextEditingController description3Controller = TextEditingController();
  TextEditingController description4Controller = TextEditingController();
  TextEditingController descriptio5Controller = TextEditingController();
  TextEditingController description6Controller = TextEditingController();
  TextEditingController description7Controller = TextEditingController();
  TextEditingController descriptio8Controller = TextEditingController();

  ScrollController scrollCon = ScrollController();

  @override
  void initState() {
    fab = FloatingActionButtonLocation.endFloat;

    super.initState();
  }

  @override
  void dispose() {
    titleController.clear();
    title1Controller.clear();
    title2Controller.clear();
    title3Controller.clear();
    title4Controller.clear();
    title5Controller.clear();
    title6Controller.clear();
    title7Controller.clear();
    title8Controller.clear();

    descriptionController.clear();
    description1Controller.clear();
    descriptio2Controller.clear();
    description3Controller.clear();
    description4Controller.clear();
    descriptio5Controller.clear();
    description6Controller.clear();
    description7Controller.clear();
    descriptio8Controller.clear();

    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;
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
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "",
      ),
      body: Stack(
        children: [
          ListView(
            controller: scrollCon,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _getMainTitle()
                            //Text("data", style: TextStyle(color: Colors.red))
                          ],
                        ),
                        Row(
                          children: [_getMainDescription()],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_getFieldWidget()],
              )
            ],
          ),
          Positioned(
              bottom: (MediaQuery.of(context).size.width * 4) / 100,
              left: (MediaQuery.of(context).size.width * 40) / 100,
              right: 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    switch (countFields) {
                      case 0:
                        {
                          field1 = true;
                          countFields++;
                          scrollCon.animateTo(
                              scrollCon.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                        break;

                      case 1:
                        {
                          field2 = true;
                          countFields++;
                          scrollCon.animateTo(
                              scrollCon.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                        break;

                      case 2:
                        {
                          field3 = true;
                          countFields++;
                          scrollCon.animateTo(
                              scrollCon.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                        break;
                      case 3:
                        {
                          field4 = true;
                          countFields++;
                          scrollCon.animateTo(
                              scrollCon.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                        break;
                      case 4:
                        {
                          field5 = true;
                          countFields++;
                          scrollCon.animateTo(
                              scrollCon.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                        break;
                      case 5:
                        {
                          field6 = true;
                          countFields++;
                          scrollCon.animateTo(
                              scrollCon.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                        break;
                      case 6:
                        {
                          field7 = true;
                          countFields++;
                          scrollCon.animateTo(
                              scrollCon.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                        break;
                      case 7:
                        {
                          field8 = true;
                          countFields++;
                          scrollCon.animateTo(
                              scrollCon.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                        break;

                      default:
                        {
                          Fluttertoast.showToast(msg: "Only 8 Cards Allowed!");
                        }
                        break;
                    }
                    // fields.add(_getFieldWidget(controllerList[controllerPosition],
                    //     controllerList[++controllerPosition]));
                    // print(controllerList[controllerPosition]);
                  });
                },
                child: Container(
                    width: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Icon(
                        Icons.add,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    color: Colors.transparent),
              ))
        ],
      ),
      floatingActionButtonLocation: fab,

      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //specify the location of the FAB

      floatingActionButton: FloatingActionButton.extended(
          // icon: Icon(Icons.check),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0))),
          label: Text(
            "Post",
          ),
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Colors.white,
          onPressed: () {
            progressDialog.show().then((value) {
              if (value) {
                final databaseReference = Firestore.instance;

                databaseReference.collection("NoticeBoard").add({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'createdDate': DateTime.now(),
                  'title1': title1Controller.text,
                  'description1': description1Controller.text,
                  'title2': title2Controller.text,
                  'description2': descriptio2Controller.text,
                  'title3': title3Controller.text,
                  'description3': description3Controller.text,
                  'title4': title4Controller.text,
                  'description4': description4Controller.text,
                  'title5': title5Controller.text,
                  'description5': descriptio5Controller.text,
                  'title6': title6Controller.text,
                  'description6': description6Controller.text,
                  'title7': title7Controller.text,
                  'description7': description7Controller.text,
                  'title8': title8Controller.text,
                  'description8': descriptio8Controller.text,
                }).then((value) {
                  Firestore.instance
                      .collection("NoticeBoard")
                      .document(value.documentID)
                      .updateData({
                    "NoticeDocId": value.documentID.toString(),
                  });
                  progressDialog.hide().then((value) {
                    if (value) {
                      Fluttertoast.showToast(msg: "Notice Posted!");

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(
                                    user: widget.user,
                                    phone: widget.phone,
                                    userID: widget.userID,
                                  )));
                    }
                  });
                });
              }
            });
          }),
    );
  }

  Widget _getMainTitle() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: new TextField(
          controller: titleController,
          style: TextStyle(color: Colors.white, height: 1),
          inputFormatters: [
            new LengthLimitingTextInputFormatter(20),
          ],
          cursorColor: Colors.white,
          decoration: new InputDecoration(
            labelText: "Main Title",
            labelStyle: TextStyle(fontSize: 20, color: Colors.white),
            fillColor: Colors.white,
            focusedBorder: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.white),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(5.0),
              borderSide: new BorderSide(color: Colors.white),
            ),
            //fillColor: Colors.green
          ),
        ),
      ),
    );
  }

  Widget _getMainDescription() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: TextField(
          controller: descriptionController,

          // controller: descriptionController,
          maxLines: 4,
          cursorColor: Colors.white,
          keyboardType: TextInputType.multiline,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
            labelText: "Main Description",

            alignLabelWithHint: true,
            labelStyle: TextStyle(fontSize: 20, color: Colors.white),
            fillColor: Colors.white,
            focusedBorder: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.white),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(5.0),
              borderSide: new BorderSide(color: Colors.white),
            ),
            //fillColor: Colors.green
          ),
        ),
      ),
    );
  }

  Widget getTitle(bool isTitle) {
    return isTitle == true
        ? Text(
            "Create Notice",
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

  Widget _getFieldWidget() {
    return Column(
      children: [
        Visibility(
          visible: field1,
          child: Row(
            children: [
              Stack(
                children: [
                  Card(
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  controller: title1Controller,
                                  style:
                                      TextStyle(color: Colors.white, height: 1),
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(20),
                                  ],
                                  cursorColor: Colors.white,
                                  decoration: new InputDecoration(
                                    labelText: "Sub Title",
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: description1Controller,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.multiline,
                                  decoration: new InputDecoration(
                                    labelText: "Description",

                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 25,
                          ),
                          child: Icon(Icons.close)),
                      splashColor: Colors.white,
                      onTap: () {
                        setState(() {
                          field1 = false;
                          countFields--;
                          print("1");
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Visibility(
          visible: field2,
          child: Row(
            children: [
              Stack(
                children: [
                  Card(
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  controller: title2Controller,
                                  style:
                                      TextStyle(color: Colors.white, height: 1),
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(20),
                                  ],
                                  cursorColor: Colors.white,
                                  decoration: new InputDecoration(
                                    labelText: "Sub Title",
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: descriptio2Controller,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.multiline,
                                  decoration: new InputDecoration(
                                    labelText: "Description",

                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 25,
                          ),
                          child: Icon(Icons.close)),
                      splashColor: Colors.white,
                      onTap: () {
                        setState(() {
                          setState(() {
                            field2 = false;
                            countFields--;
                          });
                          print("2");
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Visibility(
          visible: field3,
          child: Row(
            children: [
              Stack(
                children: [
                  Card(
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  controller: title3Controller,
                                  style:
                                      TextStyle(color: Colors.white, height: 1),
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(20),
                                  ],
                                  cursorColor: Colors.white,
                                  decoration: new InputDecoration(
                                    labelText: "Sub Title",
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: description3Controller,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.multiline,
                                  decoration: new InputDecoration(
                                    labelText: "Description",

                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 25,
                          ),
                          child: Icon(Icons.close)),
                      splashColor: Colors.white,
                      onTap: () {
                        setState(() {
                          field3 = false;
                          countFields--;
                          print("3");
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Visibility(
          visible: field4,
          child: Row(
            children: [
              Stack(
                children: [
                  Card(
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  controller: title4Controller,
                                  style:
                                      TextStyle(color: Colors.white, height: 1),
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(20),
                                  ],
                                  cursorColor: Colors.white,
                                  decoration: new InputDecoration(
                                    labelText: "Sub Title",
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: description4Controller,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.multiline,
                                  decoration: new InputDecoration(
                                    labelText: "Description",

                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 25,
                          ),
                          child: Icon(Icons.close)),
                      splashColor: Colors.white,
                      onTap: () {
                        setState(() {
                          setState(() {
                            field4 = false;
                            countFields--;
                          });
                          print("4");
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Visibility(
          visible: field5,
          child: Row(
            children: [
              Stack(
                children: [
                  Card(
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  controller: title5Controller,
                                  style:
                                      TextStyle(color: Colors.white, height: 1),
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(20),
                                  ],
                                  cursorColor: Colors.white,
                                  decoration: new InputDecoration(
                                    labelText: "Sub Title",
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: descriptio5Controller,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.multiline,
                                  decoration: new InputDecoration(
                                    labelText: "Description",

                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 25,
                          ),
                          child: Icon(Icons.close)),
                      splashColor: Colors.white,
                      onTap: () {
                        setState(() {
                          field5 = false;
                          countFields--;
                          print("5");
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Visibility(
          visible: field6,
          child: Row(
            children: [
              Stack(
                children: [
                  Card(
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  controller: title6Controller,
                                  style:
                                      TextStyle(color: Colors.white, height: 1),
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(20),
                                  ],
                                  cursorColor: Colors.white,
                                  decoration: new InputDecoration(
                                    labelText: "Sub Title",
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: description6Controller,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.multiline,
                                  decoration: new InputDecoration(
                                    labelText: "Description",

                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 25,
                          ),
                          child: Icon(Icons.close)),
                      splashColor: Colors.white,
                      onTap: () {
                        setState(() {
                          setState(() {
                            field6 = false;
                            countFields--;
                          });
                          print("6");
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Visibility(
          visible: field7,
          child: Row(
            children: [
              Stack(
                children: [
                  Card(
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  controller: title7Controller,
                                  style:
                                      TextStyle(color: Colors.white, height: 1),
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(20),
                                  ],
                                  cursorColor: Colors.white,
                                  decoration: new InputDecoration(
                                    labelText: "Sub Title",
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: description7Controller,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.multiline,
                                  decoration: new InputDecoration(
                                    labelText: "Description",

                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 25,
                          ),
                          child: Icon(Icons.close)),
                      splashColor: Colors.white,
                      onTap: () {
                        setState(() {
                          field7 = false;
                          countFields--;
                          print("7");
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Visibility(
          visible: field8,
          child: Row(
            children: [
              Stack(
                children: [
                  Card(
                    color: Colors.black87,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  controller: title8Controller,
                                  style:
                                      TextStyle(color: Colors.white, height: 1),
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(20),
                                  ],
                                  cursorColor: Colors.white,
                                  decoration: new InputDecoration(
                                    labelText: "Sub Title",
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: descriptio8Controller,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.multiline,
                                  decoration: new InputDecoration(
                                    labelText: "Description",

                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide:
                                          new BorderSide(color: Colors.white),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 25,
                          ),
                          child: Icon(Icons.close)),
                      splashColor: Colors.white,
                      onTap: () {
                        setState(() {
                          setState(() {
                            field8 = false;
                            countFields--;
                          });
                          print("8");
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 200,
        )
      ],
    );
  }
}
