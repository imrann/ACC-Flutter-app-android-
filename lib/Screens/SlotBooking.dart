import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upi_india/upi_india.dart';
import 'package:aayush_carrom_club/Screens/AppBarCommon.dart';
import 'package:aayush_carrom_club/Screens/ErrorPage.dart';
import 'package:aayush_carrom_club/Screens/FancyLoader.dart';
import 'package:aayush_carrom_club/Screens/MyBookings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

FloatingActionButtonLocation fab = FloatingActionButtonLocation.centerFloat;
String selectedDateTime;
bool enableButton;
String docID;
var selectedSlots = new List();
var _playingMode = ["Single", "Double"];
var _selectedPlayingMode = 'Single';
int selectedSlotsCount;

String slot0001 = "Available";
String slot0102 = "Available";
String slot0203 = "Available";
String slot0304 = "Available";
String slot0405 = "Available";
String slot0506 = "Available";
String slot0607 = "Available";
String slot0708 = "Available";
String slot0809 = "Available";
String slot0910 = "Available";
String slot1011 = "Available";
String slot1112 = "Available";

String slot1213 = "Available";
String slot1314 = "Available";
String slot1415 = "Available";
String slot1516 = "Available";
String slot1617 = "Available";
String slot1718 = "Available";
String slot1819 = "Available";
String slot1920 = "Available";
String slot2021 = "Available";
String slot2122 = "Available";
String slot2223 = "Available";
String slot2324 = "Available";

class SlotBooking extends StatefulWidget {
  final String user;
  final String phone;
  final String date;
  final String userID;
  final String userRole;
  SlotBooking({this.user, this.phone, this.date, this.userID, this.userRole});

  @override
  _SlotBookingState createState() => _SlotBookingState();
}

class _SlotBookingState extends State<SlotBooking> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;
  Future<UpiResponse> _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;
  @override
  void initState() {
    fab = FloatingActionButtonLocation.centerFloat;
    enableButton = false;
    docID = "";
    selectedSlotsCount = 0;
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

//
  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: '8850558137@ybl',
      receiverName: 'Ajay Thori',
      transactionRefId: 'Carrom Slot Booking',
      transactionNote:
          'Pay Rs.' + '${selectedSlotsCount * 1.00}' + '/-  to ACC',
      amount: selectedSlotsCount * 1.00.toDouble(),
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps.length == 0)
      return Center(child: Text("No apps found to handle transaction."));
    else
      return Center(
        child: Wrap(
          children: apps.map<Widget>((UpiApp app) {
            return GestureDetector(
              onTap: () {
                _transaction = initiateTransaction(app);
                setState(() {});
              },
              child: Container(
                height: 100,
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.memory(
                      app.icon,
                      height: 60,
                      width: 60,
                    ),
                    Text(app.name),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
  }

  void updateTabSelection(int index) {
    setState(() {});
  }

  showUPIErrorDialog(BuildContext context, String errorMsg, String docID) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        _cancleTransaction(errorMsg, docID);
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Oooops!!!"),
      content: Text(errorMsg),
      actions: [
        okButton,
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
        isTabBar: false,
      ),

      body: Stack(
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
              top: 85,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // FutureBuilder(
                    //   future: _transaction,
                    //   builder: (BuildContext context,
                    //       AsyncSnapshot<UpiResponse> snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.done) {
                    //       if (snapshot.hasError) {
                    //         print(
                    //             "An Unknown error has occured##############################################################");
                    //         return Center(
                    //             child: Text('An Unknown error has occured'));
                    //       }
                    //       UpiResponse _upiResponse;
                    //       _upiResponse = snapshot.data;
                    //       // if (_upiResponse.runtimeType != null) {
                    //       //   String text = '';
                    //       //   switch (snapshot.error.runtimeType) {
                    //       //     case UpiIndiaAppNotInstalledException:
                    //       //       print(
                    //       //           "Requested app not installed on device##############################################################");
                    //       //       text = "no UPI app found";

                    //       //       break;
                    //       //     case UpiIndiaInvalidParametersException:
                    //       //       print(
                    //       //           "Requested app cannot handle the transaction##############################################################");
                    //       //       text = "due to failed Payment";
                    //       //       break;
                    //       //     case UpiIndiaNullResponseException:
                    //       //       print(
                    //       //           "requested app didn't returned any response##############################################################");
                    //       //       text = "due to failed Payment";
                    //       //       break;
                    //       //     case UpiIndiaUserCancelledException:
                    //       //       print(
                    //       //           "You cancelled the transaction##############################################################");
                    //       //       text = "by you";
                    //       //       break;
                    //       //   }
                    //       //   return Center(
                    //       //     child: Text(text),
                    //       //     // showUPIErrorDialog(context, text, docID),
                    //       //   );
                    //       // }
                    //       String txnId = _upiResponse.transactionId;
                    //       String resCode = _upiResponse.responseCode;
                    //       String txnRef = _upiResponse.transactionRefId;
                    //       String status = _upiResponse.status;
                    //       String approvalRef = _upiResponse.approvalRefNo;
                    //       switch (status) {
                    //         case UpiPaymentStatus.SUCCESS:
                    //           print(
                    //               'Transaction Successful##############################################################');
                    //           print(docID);
                    //           _updatePayments(
                    //               txnId,
                    //               status,
                    //               selectedSlotsCount * 50.00.toInt(),
                    //               widget.user,
                    //               "ACC",
                    //               docID,
                    //               "Transaction Successful");

                    //           break;
                    //         case UpiPaymentStatus.SUBMITTED:
                    //           print(
                    //               'Transaction Pending##############################################################');
                    //           _updatePayments(
                    //               txnId,
                    //               status,
                    //               selectedSlotsCount * 50.00.toInt(),
                    //               widget.user,
                    //               "ACC",
                    //               docID,
                    //               "Transaction Pending");

                    //           break;
                    //         case UpiPaymentStatus.FAILURE:
                    //           print(
                    //               'Transaction Failed##############################################################');
                    //           _updatePayments(
                    //               txnId,
                    //               status,
                    //               selectedSlotsCount * 50.00.toInt(),
                    //               widget.user,
                    //               "ACC",
                    //               docID,
                    //               "Transaction Failed");

                    //           break;
                    //         default:
                    //           _updatePayments(
                    //               txnId,
                    //               status,
                    //               selectedSlotsCount * 50.00.toInt(),
                    //               widget.user,
                    //               "ACC",
                    //               docID,
                    //               "Transaction Failed");

                    //           print(
                    //               'Received an Unknown transaction status##############################################################');
                    //       }
                    //       return Text("data");
                    //     } else
                    //       return Text(' ');
                    //   },
                    // ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                color: Colors.red,
                              ),
                              Text("Booked"),
                              SizedBox(width: 30),
                              Container(
                                height: 10,
                                width: 10,
                                color: Colors.green,
                              ),
                              Text("Selected"),
                              SizedBox(width: 30),
                              Container(
                                height: 10,
                                width: 10,
                                color: Colors.grey,
                              ),
                              Text("Available"),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: _buildBody(),
                    ),
                    SizedBox(height: 30),
                    Container(
                        width: 250,
                        height: 150,
                        child: DropdownButtonFormField<String>(
                          // value: "Single",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          items: _getDropDownListItem(_playingMode),
                          onChanged: (String newSelectedValue) {
                            setState(() {
                              _selectedPlayingMode = newSelectedValue;
                            });
                          },
                          hint: new Text("SELECT MODE   (dafault : Single)"),
                        )),
                  ],
                ),
              )),
        ],
      ),
      floatingActionButtonLocation: fab,

      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //specify the location of the FAB
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.check),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          label: Text("Confirm Booking"),
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Colors.white,
          onPressed: () {
            if (selectedSlotsCount > 0) {
              setState(() {
                enableButton = true;
              });
            }
            // enableButton == true ?
            if (enableButton == true) {
              print(selectedSlots.toString());
              progressDialog.show().then((value) {
                if (value) {
                  setState(() {
                    slot0001 = "Available";
                    slot0102 = "Available";
                    slot0203 = "Available";
                    slot0304 = "Available";
                    slot0405 = "Available";
                    slot0506 = "Available";
                    slot0607 = "Available";
                    slot0708 = "Available";
                    slot0809 = "Available";
                    slot0910 = "Available";
                    slot1011 = "Available";
                    slot1112 = "Available";

                    slot1213 = "Available";
                    slot1314 = "Available";
                    slot1415 = "Available";
                    slot1516 = "Available";
                    slot1617 = "Available";
                    slot1718 = "Available";
                    slot1819 = "Available";
                    slot1920 = "Available";
                    slot2021 = "Available";
                    slot2122 = "Available";
                    slot2223 = "Available";
                    slot2324 = "Available";
                  });
                  String tempSlots = selectedSlots.join();
                  bookSlot(tempSlots).then((idDOC) {
                    print("docID" + idDOC);
                    setState(() {
                      docID = idDOC;
                    });

                    // requestOrderAPI(idDOC).then((orderID) {
                    //   print('id: ' + orderID);
                    //      });

                    progressDialog.hide().then((isHidden) {
                      if (isHidden) {
                        _paymentGateway(idDOC);
                      }
                    });
                    //Fluttertoast.showToast(msg: "Hi!: Booking Successful ");

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             // PaymentGateway(
                    //             //       userName: widget.user,
                    //             //       phone: widget.phone,
                    //             //       userID: widget.userID,
                    //             //       amount: 1,
                    //             //       documentID: idDOC,
                    //             //       user: widget.user,
                    //             //       userRole: widget.userRole,
                    //             //       orderID: orderID,
                    //             //     )

                    //             //   MyBookings(
                    //             //   user: widget.user,
                    //             //   phone: widget.phone,
                    //             //   userID: widget.userID,
                    //             //   userRole: widget.userRole,
                    //             // )
                    //             // PaymentGateway()
                    //             ));

                    selectedSlots.clear();
                  });
                }
              });
            } else {
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Please, select atleast one slot!"),
                duration: Duration(seconds: 2),
              ));
              return null;
            }
          }),
    );

    /// );
  }

  // Future<String> requestOrderAPI(String docID) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   print("RAZORRRRRRRRRRRR");
  //   print(preferences.getString("razorPayKey"));
  //   print(preferences.getString("RazorPayValue"));

  //   String username = preferences.getString("razorPayKey");
  //   String password = preferences.getString("RazorPayValue");
  //   String basicAuth =
  //       'Basic ' + base64Encode(utf8.encode('$username:$password'));
  //   print("basicAuth: " + basicAuth);
  //   final String orderAPI = "https://api.razorpay.com/v1/orders";

  //   Map<String, String> headers = {
  //     'Content-type': 'application/json',
  //     'Authorization': basicAuth
  //   };

  //   var body = json.encode(
  //       {"amount": 100, "currency": "INR", "receipt": docID.toString()});

  //   try {
  //     http.Response res =
  //         await http.post(orderAPI, headers: headers, body: body);
  //     print("status: " + res.statusCode.toString());
  //     if (res.statusCode == 200) {
  //       var joinresponse = json.decode(res.body);
  //       print("joinresponse: " + joinresponse['id']);
  //       return joinresponse['id'];
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  Future<String> bookSlot(String timeSlot) async {
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    var rnd = new Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    print(next.toInt());

    final databaseReference =
        await Firestore.instance.collection("Bookings").add({
      'bookingDate': widget.date.toString(),
      'mode': _selectedPlayingMode,
      'phone': widget.phone.toString(),
      'slotTime': timeSlot.toString(),
      'status': 'booked',
      'userID': widget.userID.toString(),
      'userName': widget.user.toString(),
      'paymentID': '',
      'confirmationCode': next.toInt().toString(),
      'creationDate': new DateTime.now()
    }).then((value) {
      setState(() {
        docID = value.documentID;
      });
      Firestore.instance
          .collection("Bookings")
          .document(value.documentID)
          .updateData({
        "DocId": value.documentID.toString(),
      });
    });
    // print(databaseReference.documentID);
    return docID;
  }

  List _getDropDownListItem(List<String> dropDwonList) {
    return dropDwonList.map((String dropDownItem) {
      return DropdownMenuItem<String>(
        value: dropDownItem,
        child: Text(dropDownItem),
      );
    }).toList();
  }

  Widget getTitle(bool isTitle) {
    return isTitle == true
        ? Text(
            "Booking".toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              wordSpacing: 1,
              fontStyle: FontStyle.normal,
            ),
          )
        : Text("${widget.date}",
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              wordSpacing: 1,
              fontStyle: FontStyle.normal,
            ));
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Bookings')
          .where('bookingDate', isEqualTo: widget.date)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          print("hasError");
          print(snapshot.error);

          return ErrorPage(error: error.toString());
        } else if (snapshot.hasData) {
          int time;
          List<DocumentSnapshot> lSnapshotData = snapshot.data.documents;
          lSnapshotData.removeWhere(
              (element) => !element["status"].toString().contains("booked"));

          if (widget.date == DateTime.now().toString().substring(0, 10)) {
            time = int.parse(DateFormat.H().format(DateTime.now()).toString());
          } else {
            time = 101;
          }
          return _buildList(context, lSnapshotData, time);
        } else {
          return FancyLoader(
            loaderType: "logo",
          );
        }

        // return _buildList(context, snapshot.data.documents[1]);
      },
    );
  }

  // _buildList(BuildContext context, List<DocumentSnapshot> data) {

  //   // print(data['slotTime'].toString());
  //   // Center(child: Text(data['slotTime'].toString()));
  //   // return null;
  // }

  Widget _buildList(
      BuildContext context, List<DocumentSnapshot> data, int time) {
    StringBuffer bookedSlots = new StringBuffer();
    bookedSlots.clear();
    if (data.length == 0) {
      print("All slots are empty");
    } else {
      for (var i = 0; i < data.length; i++) {
        bookedSlots.write(data[i]['slotTime']);
        bookedSlots.write("-");
      }
      //  print(bookedSlots);
    }
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 0 && time != 101) ? 0 : 10,
                color: (time >= 0 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("12am - 01am"))
                        ? Colors.red
                        : (slot0001 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("12am - 01am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 0) {
                    if (!bookedSlots.toString().contains("12am - 01am")) {
                      setState(() {
                        if (slot0001 == "seleted") {
                          slot0001 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("12am - 01am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot0001 = "seleted";
                          selectedSlots.add("12am - 01am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 1 && time != 101) ? 0 : 10,
                color: (time >= 1 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("01am - 02am"))
                        ? Colors.red
                        : (slot0102 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("01am - 02am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 1) {
                    if (!bookedSlots.toString().contains("01am - 02am")) {
                      setState(() {
                        if (slot0102 == "seleted") {
                          slot0102 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("01am - 02am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot0102 = "seleted";
                          selectedSlots.add("01am - 02am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 2 && time != 101) ? 0 : 10,
                color: (time >= 2 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("02am - 03am"))
                        ? Colors.red
                        : (slot0203 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("02am - 03am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 2) {
                    if (!bookedSlots.toString().contains("02am - 03am")) {
                      setState(() {
                        if (slot0203 == "seleted") {
                          slot0203 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("02am - 03am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot0203 = "seleted";
                          selectedSlots.add("02am - 03am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 3 && time != 101) ? 0 : 10,
                color: (time >= 3 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("03am - 04am"))
                        ? Colors.red
                        : (slot0304 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("03am - 04am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 3) {
                    if (!bookedSlots.toString().contains("03am - 04am")) {
                      setState(() {
                        if (slot0304 == "seleted") {
                          slot0304 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("03am - 04am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot0304 = "seleted";
                          selectedSlots.add("03am - 04am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 4 && time != 101) ? 0 : 10,
                color: (time >= 4 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("04am - 05am"))
                        ? Colors.red
                        : (slot0405 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("04am - 05am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 4) {
                    if (!bookedSlots.toString().contains("04am - 05am")) {
                      setState(() {
                        if (slot0405 == "seleted") {
                          slot0405 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("04am - 05am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot0405 = "seleted";
                          selectedSlots.add("04am - 05am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
        ],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "12 am - 01 am",
            style: TextStyle(fontSize: 8),
          ),
          Text("01 am - 02 am", style: TextStyle(fontSize: 8)),
          Text("02 am - 03 am", style: TextStyle(fontSize: 8)),
          Text("03 am - 04 am", style: TextStyle(fontSize: 8)),
          Text("04 am - 05 am", style: TextStyle(fontSize: 8)),
        ],
      ),
      SizedBox(height: 50),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 5 && time != 101) ? 0 : 10,
                color: (time >= 5 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("05am - 06am"))
                        ? Colors.red
                        : (slot0506 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("05am - 06am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 5) {
                    if (!bookedSlots.toString().contains("05am - 06am")) {
                      setState(() {
                        if (slot0506 == "seleted") {
                          slot0506 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("05am - 06am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot0506 = "seleted";
                          selectedSlots.add("05am - 06am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 6 && time != 101) ? 0 : 10,
                color: (time >= 6 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("06am - 07am"))
                        ? Colors.red
                        : (slot0607 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("06am - 07am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 6) {
                    if (!bookedSlots.toString().contains("06am - 07am")) {
                      setState(() {
                        if (slot0607 == "seleted") {
                          slot0607 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("06am - 07am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot0607 = "seleted";
                          selectedSlots.add("06am - 07am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 7 && time != 101) ? 0 : 10,
                color: (time >= 7 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("07am - 08am"))
                        ? Colors.red
                        : (slot0708 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("07am - 08am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 7) {
                    if (!bookedSlots.toString().contains("07am - 08am")) {
                      setState(() {
                        if (slot0708 == "seleted") {
                          slot0708 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("07am - 08am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot0708 = "seleted";
                          selectedSlots.add("07am - 08am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 8 && time != 101) ? 0 : 10,
                color: (time >= 8 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("08am - 09am"))
                        ? Colors.red
                        : (slot0809 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("08am - 09am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 8) {
                    if (!bookedSlots.toString().contains("08am - 09am")) {
                      setState(() {
                        if (slot0809 == "seleted") {
                          slot0809 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("08am - 09am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot0809 = "seleted";
                          selectedSlots.add("08am - 09am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 9 && time != 101) ? 0 : 10,
                color: (time >= 9 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("09am - 10am"))
                        ? Colors.red
                        : (slot0910 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("09am - 10am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 9) {
                    if (!bookedSlots.toString().contains("09am - 10am")) {
                      setState(() {
                        if (slot0910 == "seleted") {
                          slot0910 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("09am - 10am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot0910 = "seleted";
                          selectedSlots.add("09am - 10am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
        ],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "05 am - 06 am",
            style: TextStyle(fontSize: 8),
          ),
          Text("06 am - 07 am", style: TextStyle(fontSize: 8)),
          Text("07 am - 08 am", style: TextStyle(fontSize: 8)),
          Text("08 am - 09 am", style: TextStyle(fontSize: 8)),
          Text("09 am - 10 am", style: TextStyle(fontSize: 8)),
        ],
      ),
      SizedBox(height: 50),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 10 && time != 101) ? 0 : 10,
                color: (time >= 10 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("10am - 11am"))
                        ? Colors.red
                        : (slot1011 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("10am - 11am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 10) {
                    if (!bookedSlots.toString().contains("10am - 11am")) {
                      setState(() {
                        if (slot1011 == "seleted") {
                          slot1011 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("10am - 11am  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot1011 = "seleted";
                          selectedSlots.add("10am - 11am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 11 && time != 101) ? 0 : 10,
                color: (time >= 11 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("11am - 12pm"))
                        ? Colors.red
                        : (slot1112 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("11am - 12pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 11) {
                    if (!bookedSlots.toString().contains("11am - 12pm")) {
                      setState(() {
                        if (slot1112 == "seleted") {
                          slot1112 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("11am - 12pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot1112 = "seleted";
                          selectedSlots.add("11am - 12pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 12 && time != 101) ? 0 : 10,
                color: (time >= 12 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("12pm - 01pm"))
                        ? Colors.red
                        : (slot1213 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("12pm - 01pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 12) {
                    if (!bookedSlots.toString().contains("12pm - 01pm")) {
                      setState(() {
                        if (slot1213 == "seleted") {
                          slot1213 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("12pm - 01pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot1213 = "seleted";
                          selectedSlots.add("12pm - 01pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 13 && time != 101) ? 0 : 10,
                color: (time >= 13 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("01pm - 02pm"))
                        ? Colors.red
                        : (slot1314 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("01pm - 02pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 13) {
                    if (!bookedSlots.toString().contains("01pm - 02pm")) {
                      setState(() {
                        if (slot1314 == "seleted") {
                          slot1314 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("01pm - 02pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot1314 = "seleted";
                          selectedSlots.add("01pm - 02pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 14 && time != 101) ? 0 : 10,
                color: (time >= 14 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("02pm - 03pm"))
                        ? Colors.red
                        : (slot1415 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("02pm - 03pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 14) {
                    if (!bookedSlots.toString().contains("02pm - 03pm")) {
                      setState(() {
                        if (slot1415 == "seleted") {
                          slot1415 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("02pm - 03pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot1415 = "seleted";
                          selectedSlots.add("02pm - 03pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
        ],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "10 am - 11 am",
            style: TextStyle(fontSize: 8),
          ),
          Text("11 am - 12 pm", style: TextStyle(fontSize: 8)),
          Text("12 pm - 13 pm", style: TextStyle(fontSize: 8)),
          Text("13 pm - 14 pm", style: TextStyle(fontSize: 8)),
          Text("14 pm - 15 pm", style: TextStyle(fontSize: 8)),
        ],
      ),
      SizedBox(height: 50),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 15 && time != 101) ? 0 : 10,
                color: (time >= 15 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("03pm - 04pm"))
                        ? Colors.red
                        : (slot1516 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("03pm - 04pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 15) {
                    if (!bookedSlots.toString().contains("03pm - 04pm")) {
                      setState(() {
                        if (slot1516 == "seleted") {
                          slot1516 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("03pm - 04pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot1516 = "seleted";
                          selectedSlots.add("03pm - 04pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 16 && time != 101) ? 0 : 10,
                color: (time >= 16 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("04pm - 05pm"))
                        ? Colors.red
                        : (slot1617 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("04pm - 05pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 16) {
                    if (!bookedSlots.toString().contains("04pm - 05pm")) {
                      setState(() {
                        if (slot1617 == "seleted") {
                          slot1617 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("04pm - 05pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot1617 = "seleted";
                          selectedSlots.add("04pm - 05pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 17 && time != 101) ? 0 : 10,
                color: (time >= 17 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("05pm - 06pm"))
                        ? Colors.red
                        : (slot1718 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("05pm - 06pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 17) {
                    if (!bookedSlots.toString().contains("05pm - 06pm")) {
                      setState(() {
                        if (slot1718 == "seleted") {
                          slot1718 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("05pm - 06pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot1718 = "seleted";
                          selectedSlots.add("05pm - 06pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 18 && time != 101) ? 0 : 10,
                color: (time >= 18 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("06pm - 07pm"))
                        ? Colors.red
                        : (slot1819 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("06pm - 07pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 18) {
                    if (!bookedSlots.toString().contains("06pm - 07pm")) {
                      setState(() {
                        if (slot1819 == "seleted") {
                          slot1819 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("06pm - 07pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot1819 = "seleted";
                          selectedSlots.add("06pm - 07pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 19 && time != 101) ? 0 : 10,
                color: (time >= 19 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("07pm - 08pm"))
                        ? Colors.red
                        : (slot1920 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("07pm - 08pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 19) {
                    if (!bookedSlots.toString().contains("07pm - 08pm")) {
                      setState(() {
                        if (slot1920 == "seleted") {
                          slot1920 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("07pm - 08pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot1920 = "seleted";
                          selectedSlots.add("07pm - 08pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
        ],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "15 pm - 16 pm",
            style: TextStyle(fontSize: 8),
          ),
          Text("16 pm - 17 pm", style: TextStyle(fontSize: 8)),
          Text("17 pm - 18 pm", style: TextStyle(fontSize: 8)),
          Text("18 pm - 19 pm", style: TextStyle(fontSize: 8)),
          Text("19 pm - 20 pm", style: TextStyle(fontSize: 8)),
        ],
      ),
      SizedBox(height: 50),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 20 && time != 101) ? 0 : 10,
                color: (time >= 20 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("08pm - 09pm"))
                        ? Colors.red
                        : (slot2021 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("08pm - 09pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 20) {
                    if (!bookedSlots.toString().contains("08pm - 09pm")) {
                      setState(() {
                        if (slot2021 == "seleted") {
                          slot2021 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("08pm - 09pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot2021 = "seleted";
                          selectedSlots.add("08pm - 09pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 21 && time != 101) ? 0 : 10,
                color: (time >= 21 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("09pm - 10pm"))
                        ? Colors.red
                        : (slot2122 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("09pm - 10pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 21) {
                    if (!bookedSlots.toString().contains("09pm - 10pm")) {
                      setState(() {
                        if (slot2122 == "seleted") {
                          slot2122 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("09pm - 10pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot2122 = "seleted";
                          selectedSlots.add("09pm - 10pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 22 && time != 101) ? 0 : 10,
                color: (time >= 22 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("10pm - 11pm"))
                        ? Colors.red
                        : (slot2223 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("10pm - 11pm"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 22) {
                    if (!bookedSlots.toString().contains("10pm - 11pm")) {
                      setState(() {
                        if (slot2223 == "seleted") {
                          slot2223 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("10pm - 11pm  |  "));
                          selectedSlots.join(', ');
                          selectedSlotsCount--;
                        } else {
                          slot2223 = "seleted";
                          selectedSlots.add("10pm - 11pm  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
          Container(
              width: 40,
              height: 40,
              child: RaisedButton(
                elevation: (time >= 23 && time != 101) ? 0 : 10,
                color: (time >= 23 && time != 101)
                    ? Colors.grey[300]
                    : (bookedSlots.toString().contains("11pm - 12am"))
                        ? Colors.red
                        : (slot2324 == "seleted")
                            ? Colors.green
                            : (!bookedSlots.toString().contains("11pm - 12am"))
                                ? Colors.grey
                                : Colors.transparent,
                onPressed: () {
                  if (time == 101 || time < 23) {
                    if (!bookedSlots.toString().contains("11pm - 12am")) {
                      setState(() {
                        if (slot2324 == "seleted") {
                          slot2324 = "Available";
                          selectedSlots.removeWhere(
                              (item) => item.contains("11pm - 12am  |  "));
                          selectedSlotsCount--;
                        } else {
                          slot2324 = "seleted";
                          selectedSlots.add("11pm - 12am  |  ");
                          selectedSlotsCount++;
                        }
                      });
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Slot Not Available");
                  }
                },
              )),
        ],
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "20 pm - 21 pm",
            style: TextStyle(fontSize: 8),
          ),
          Text("21 pm - 22 pm", style: TextStyle(fontSize: 8)),
          Text("22 pm - 23 pm", style: TextStyle(fontSize: 8)),
          Text("23 pm - 24 am", style: TextStyle(fontSize: 8)),
        ],
      ),
    ]));
  }

  Future<bool> _onBackPressed(String idDOC) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going cancle the Transaction!!'),
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
                  progressDialog.show().then((value) {
                    if (value) {
                      _cancleTransaction("by you", idDOC);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  _cancleTransaction(String reason, String idDOC) {
    Firestore.instance.collection("Bookings").document(idDOC).setData(
        {'status': 'cancelled', "reasonForCancle": reason},
        merge: true).then((value) {
      if (reason == "by you") {
        Fluttertoast.showToast(msg: "BOOKING TERMINATED");
        progressDialog.hide().then((value) {
          if (value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyBookings(
                          user: widget.user,
                          phone: widget.phone,
                          userID: widget.userID,
                          userRole: widget.userRole,
                          showNew: "true",
                        )));
          }
        });
      }
    });
  }

  _paymentGateway(String idDOC) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            // ignore: missing_return
            onWillPop: () {
              _onBackPressed(idDOC);
            },
            child: Scrollbar(
              child: SingleChildScrollView(
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                  return new Container(
                    height: 500,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0))),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Checkout',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.redAccent[200]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Booking Amount',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColorLight),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Rs. ' +
                                    (selectedSlotsCount * 50.00).toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColorLight),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'No of slots booked',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColorLight),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                selectedSlotsCount.toString() + ' slots',
                                style: TextStyle(
                                    //  fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColorLight),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Booking Date',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColorLight),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                widget.date.toString(),
                                style: TextStyle(
                                    //  fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColorLight),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            color: Colors.redAccent[300],
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SelectableText("Phone No : 8850558137",
                                        style: TextStyle(color: Colors.black))
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SelectableText("UPI ID : 8850558137@ybl",
                                        style: TextStyle(color: Colors.black))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Please click OK to complete the booking',
                              style: TextStyle(
                                  //  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.redAccent),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                progressDialog.show().then((value) {
                                  if (value) {
                                    _updatePayments(
                                        "",
                                        'payment pending',
                                        selectedSlotsCount * 50.00.toInt(),
                                        widget.user,
                                        "ACC",
                                        docID,
                                        "Transaction Successful");
                                  }
                                });
                              },
                            ),
                          ),
                        ),

                        //  displayUpiApps(),
                      ],
                    ),
                  );
                }),
              ),
            ),
          );
        });
  }

  _updatePayments(String txnId, String status, int amount, String from,
      String to, String docID, String reason) {
    print(status);
    if (status.contains("success") || status.contains("payment pending")) {
      Fluttertoast.showToast(msg: "TRANSACTION SUCCESSFULL");

      final databaseReference = Firestore.instance;
      databaseReference.collection("Payments").add({
        'amount': amount,
        'from': from,
        'to': to,
        'transactionID': txnId,
        'transactionStatus': status,
        'bookingsDocID': docID,
        'TransactionDate': DateTime.now().toString().substring(0, 10),
        'userID': widget.userID
      }).then((value) {
        Firestore.instance
            .collection("TotalBalance")
            .document("o8IeiiVaNNE1dGG9kNxJ")
            .get()
            .then((totalbalanceDoc) {
          print(totalbalanceDoc['total']);
          Firestore.instance
              .collection("TotalBalance")
              .document("o8IeiiVaNNE1dGG9kNxJ")
              .setData({'total': totalbalanceDoc['total'] + amount},
                  merge: true);
          progressDialog.hide().then((value) {
            if (value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyBookings(
                            user: widget.user,
                            phone: widget.phone,
                            userID: widget.userID,
                            userRole: widget.userRole,
                            showNew: "true",
                          )));
            }
          });

          Fluttertoast.showToast(msg: "BOOKING CONFIRMED");
        });
      });
    } else if (status == "failure" || status.contains("pending")) {
      Fluttertoast.showToast(msg: "TRANSACTION UNSUCCESSFULL");
      final databaseReference = Firestore.instance;

      databaseReference.collection("Payments").add({
        'amount': amount,
        'from': from,
        'to': to,
        'transactionID': txnId,
        'transactionStatus': status,
        'bookingsDocID': docID,
        'TransactionDate': DateTime.now().toString().substring(0, 10),
        'userID': widget.userID
      }).then((value) {
        _cancleTransaction('payment  failed', docID);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBookings(
                      user: widget.user,
                      phone: widget.phone,
                      userID: widget.userID,
                      userRole: widget.userRole,
                      showNew: "true",
                    )));
        Fluttertoast.showToast(msg: "BOOKING CANCELLED");
      });
    }
  }
}
