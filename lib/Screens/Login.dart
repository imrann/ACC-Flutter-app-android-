import 'dart:async';
import 'dart:io';

import 'package:aayush_carrom_club/Screens/Home.dart';
import 'package:aayush_carrom_club/SharedPref/UserDetailsSP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var smsCode;

  String errorText = "";
  bool enableResendButton = false;
  String enteredOtp = '';
  ProgressDialog progressDialogotp;
  var onTapRecognizer;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  bool _autoValidate = false;

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if (user != null) {
            UserDetailsSP().loginUser(user, _userNameController.text);
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                          user: _userNameController.text,
                          phone: "+91" + _phoneController.text,
                          userID: user.uid,
                        )));
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print("failed");
          print(exception.message);
          progressDialogotp.hide().then((isHidden) {
            if (isHidden) {
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  exception.message,
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 5),
              ));
            }
          });
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          print(verificationId);
          progressDialogotp.hide().then((value) {
            if (value) {
              // scaffoldKey.currentState.showSnackBar(SnackBar(
              //   content: Text(
              //     "OTP SENT to : " + _phoneController.text.toString(),
              //     textAlign: TextAlign.center,
              //   ),
              //   duration: Duration(seconds: 5),
              // ));
              otpSlider(
                  _phoneController.text, verificationId, forceResendingToken);
            }
          });
        },
        codeAutoRetrievalTimeout: (String id) {
          // Navigator.of(context).pop();
          setState(() {
            enableResendButton = true;
          });
        });
  }

  StreamController<ErrorAnimationType> errorController;
  StreamController<ErrorAnimationType> errorController1;

  bool hasError = false;
  bool hasError1 = false;

  String phoneNumber = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    errorController1 = StreamController<ErrorAnimationType>();

    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    errorController1.close();
    super.dispose();
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
    progressDialogotp = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogotp.style(
        message: "Please Wait...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

    return Scaffold(
        key: scaffoldKey,
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: Center(
                child: loginformUI(),
              ),
            )));
  }

  Widget loginformUI() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 40),
            Image.asset(
              'images/striker1.png',
              height: MediaQuery.of(context).size.height / 4,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'LOGIN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Theme.of(context).primaryColorLight,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: TextFormField(
                  key: _formKey,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(8),
                  ],
                  autofocus: false,
                  readOnly: false,
                  autovalidate: _autoValidate,
                  validator: _userNameValidator,
                  controller: _userNameController,
                  //  enabled: !lreadonlyForm,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  decoration: InputDecoration(labelText: ""),
                  // focusedBorder: InputBorder.none,
                  // border: InputBorder.none),
                  keyboardType: TextInputType.text,
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: RichText(
                text: TextSpan(
                    text: "Enter User Name ",
                    children: [],
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: inputOTPField()),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: RichText(
                text: TextSpan(
                    text: "Enter Phone Number ",
                    children: [],
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(hasError ? "*Invalid Phone Number" : "",
                  style: TextStyle(color: Colors.red, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: 60,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "OTP will be sent via SMS on above number",
                style: TextStyle(
                    color: Theme.of(context).primaryColorLight, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              child: ButtonTheme(
                height: 50,
                child: FlatButton(
                  color: Theme.of(context).primaryColorLight,
                  onPressed: () {
                    veryfyAndGetOtp();
                  },
                  child: Center(
                      child: Text(
                    "GET OTP".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Clear",
                    style:
                        TextStyle(color: Theme.of(context).primaryColorLight),
                  ),
                  onPressed: () {
                    _phoneController.clear();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget inputOTPField() {
    return PinCodeTextField(
      length: 10,
      textStyle: TextStyle(
        color: Theme.of(context).primaryColorDark,
      ),
      textInputType: TextInputType.number,
      obsecureText: false,
      animationType: AnimationType.fade,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        // borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 30,
        activeColor: Theme.of(context).primaryColor,
        activeFillColor: Theme.of(context).primaryColor,
        selectedColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColorDark,
        selectedFillColor: Theme.of(context).primaryColor,
      ),
      animationDuration: Duration(milliseconds: 200),
      backgroundColor: Colors.transparent,
      enableActiveFill: false,
      errorAnimationController: errorController,
      controller: _phoneController,
      onCompleted: (v) {},
      onChanged: (value) {
        setState(() {
          phoneNumber = value;
        });
      },
    );
  }

  veryfyAndProceed(String verificationId, int forceResendingToken,
      StateSetter setModalState) async {
    if (enteredOtp.length != 6) {
      errorController1
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError1 = true;
        errorText = "Invalid SMS Code";
      });
      progressDialogotp.hide();
    } else {
      setState(() {
        hasError1 = false;
        errorText = "";
      });

      FirebaseAuth _auth = FirebaseAuth.instance;
      final code = _codeController.text.trim();
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: code);

      AuthResult result =
          await _auth.signInWithCredential(credential).catchError((err) {
        print('Caught $err');
        errorController1
            .add(ErrorAnimationType.shake); // Triggering error shake animation

        if (err.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {
          setModalState(() {
            hasError1 = true;
            errorText = "Invalid SMS Code";
          });
        }
      });

      progressDialogotp.hide().then((isHidden) {
        if (isHidden) {
          FirebaseUser user = result == null ? null : result.user;
          if (user != null) {
            UserDetailsSP().loginUser(user, _userNameController.text);
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                          user: _userNameController.text,
                          phone: "+91" + _phoneController.text,
                          userID: user.uid,
                        )));
          }
        }
      });
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  veryfyAndGetOtp() {
// conditions for validating
    Pattern pattern = r'^\d{10}$';
    RegExp regex = new RegExp(pattern);

    if ((!regex.hasMatch(phoneNumber)) ||
        (_userNameController.text.length < 4)) {
      errorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError = true;
        _autoValidate = true;
      });
    } else {
      setState(() {
        hasError = false;
        _autoValidate = false;
      });
      String phoneNumber = "+91" + _phoneController.text.trim();
      progressDialogotp.show().then((isProgressShown) {
        if (isProgressShown) {
          print(phoneNumber);
          loginUser(phoneNumber, context);
          // Future.delayed(Duration(seconds: 5), () {
          //   progressDialogotp.hide().then((isHidden) {
          //     if (isHidden) {
          //       // Navigator.push(context, SlideRightRoute(widget: OtpScreen()));
          //       //otpSlider();
          //     }
          //   });
          // });
        }
      });
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  otpSlider(
      String phoneNumber, String verificationId, int forceResendingToken) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: Scrollbar(
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
                        child: otpFormUI(verificationId, forceResendingToken,
                            setModalState)),
                  );
                }),
              ),
            ),
          );
        });
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget otpFormUI(String verificationId, int forceResendingToken,
      StateSetter setModalState) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'OTP Verification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.redAccent[200],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Hi " + _userNameController.text.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.redAccent[200],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                "Enter the OTP sent to +91 ",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                phoneNumber,
                                style: TextStyle(
                                    color: Colors.redAccent[200],
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: inputPhoneNumberField()),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(errorText,
                  style: TextStyle(color: Colors.red, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Didn't Recieve the OTP?",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 0),
                      Column(
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              child: ButtonTheme(
                splashColor: Theme.of(context).primaryColorLight,
                height: 50,
                child: FlatButton(
                  color: Theme.of(context).primaryColorLight,
                  onPressed: () {
                    progressDialogotp.show().then((isShown) {
                      if (isShown) {
                        veryfyAndProceed(
                            verificationId, forceResendingToken, setModalState);
                      }
                    });
                    // conditions for validating
                  },
                  child: Center(
                      child: Text(
                    "Verify & Proceed".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Clear",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  onPressed: () {
                    _codeController.clear();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _userNameValidator(String value) {
    if (value.trim().length < 4) {
      return 'Must be greator than 3 and smaller than 8 charactors';
    } else
      return null;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget inputPhoneNumberField() {
    return PinCodeTextField(
      length: 6,
      textStyle: TextStyle(
        color: Theme.of(context).primaryColorDark,
      ),
      textInputType: TextInputType.number,
      obsecureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        // borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 50,
        activeColor: Theme.of(context).primaryColor,
        activeFillColor: Theme.of(context).primaryColor,
        selectedColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColorDark,
        selectedFillColor: Theme.of(context).primaryColor,
      ),
      animationDuration: Duration(milliseconds: 200),
      backgroundColor: Colors.transparent,
      enableActiveFill: false,
      errorAnimationController: errorController1,
      controller: _codeController,
      textCapitalization: TextCapitalization.characters,
      onCompleted: (v) {},
      onChanged: (value) {
        setState(() {
          enteredOtp = value;
        });
      },
    );
  }
}
