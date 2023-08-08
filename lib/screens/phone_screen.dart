import 'package:black_coffer/screens/verify_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth _firebase = FirebaseAuth.instance;

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController _enteredNumber = TextEditingController();
  String verificationID = "";
  var _isAuthenticating = false;
  String? _errorText;
  TextEditingController countryController = TextEditingController();

  //creating new mobile number collection in firebase firestore to store all registered mobile numbers
  //i also showing that recently verified number in otp screen

  void createFirestoreCollection(String phoneNumber) async {
    await FirebaseFirestore.instance
        .collection('numbers')
        .add({'phoneNumber': phoneNumber}).then((value) {
      print('Document added successfully');
    }).catchError((error) {
      print('Failed to add document: $error');
    });
  }

  void verifyNUmber() async {
    final String value = _enteredNumber.text.trim();

    //validating the mobile number

    if (value == null ||
        value.isEmpty ||
        value.length < 10 ||
        value.length > 10) {
      setState(() {
        _errorText = 'Please enter the valid number';
      });
      return;
    }
    createFirestoreCollection(value);

    //verifying the mobile number

    _firebase.verifyPhoneNumber(
      phoneNumber: "+91" + _enteredNumber.text,
      verificationCompleted: (credential) async {
        setState(() {
          _isAuthenticating = true;
        });
        await _firebase.signInWithCredential(credential).then((value) async {
          print('you loggen in');
        });
      },
      verificationFailed: (FirebaseAuthException error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Auhtentication Failed')));
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        verificationID = verificationId;
        print("verifiactionid" + verificationID);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyScreen(
                  verificationId:
                      verificationID), //passing the verification id to otp screen
            ));
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );

    @override
    void dispose() {
      _enteredNumber.dispose();
      countryController.text = "+91";

      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '+91',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      controller: _enteredNumber,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: verifyNUmber,
                    child: Text("Send the code")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
