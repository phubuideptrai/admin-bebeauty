import 'package:bebeautyapp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeInformationScreen extends StatefulWidget {
  @override
  _ChangeInformationScreenState createState() =>
      _ChangeInformationScreenState();
}

class _ChangeInformationScreenState extends State<ChangeInformationScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = "StoreInformation";

  final formKey = GlobalKey<FormState>();
  String owner = "";
  String hint_owner = "";
  TextEditingController _ownerController = TextEditingController();

  String address = "";
  String hint_address = "";

  TextEditingController _addressController = TextEditingController();

  String phone = "";
  String hint_phone = "";
  TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    getOwnerName();
    getAddress();
    getPhoneNumber();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(
            color: kPrimaryColor,
          ),
          title: const Text('Store Information'),
          titleTextStyle: const TextStyle(
              color: kPrimaryColor,
              fontSize: 18,
              fontFamily: 'Laila',
              fontWeight: FontWeight.w700),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    const Text('BeBeauty',
                        style: TextStyle(
                            fontFamily: 'AH-Little Missy', fontSize: 80)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                                child: TextFormField(
                                  controller: _ownerController,
                                  onChanged: (value) {
                                    setState(() {
                                      owner = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    filled: true,
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
                                    prefixIcon: const Icon(Icons.person,
                                        color: Colors.black),
                                    hintText: hint_owner,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                                child: TextFormField(
                                  controller: _phoneController,
                                  onChanged: (value) {
                                    setState(() {
                                      phone = value;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    filled: true,
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
                                    prefixIcon: const Icon(Icons.phone,
                                        color: Colors.black),
                                    hintText: phone,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                                child: TextFormField(
                                  controller: _addressController,
                                  onChanged: (value) {
                                    setState(() {
                                      address = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    filled: true,
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
                                    prefixIcon: Icon(
                                      Icons.edit_location,
                                      color: Colors.black,
                                    ),
                                    hintText: hint_address,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    onPressed: () {
                                      if (owner != "") {
                                        _firestore
                                            .collection(collection)
                                            .doc('BeBeauty')
                                            .update({'owner': owner});
                                        setState(() {
                                          hint_owner = owner;
                                          owner = "";
                                        });
                                      }

                                      if (phone != "") {
                                        _firestore
                                            .collection(collection)
                                            .doc('BeBeauty')
                                            .update({'phone': phone});
                                        setState(() {
                                          hint_phone = phone;
                                          phone = "";
                                        });
                                      }

                                      if (address != "") {
                                        _firestore
                                            .collection(collection)
                                            .doc('BeBeauty')
                                            .update({'address': address});
                                        setState(() {
                                          hint_address = address;
                                          address = "";
                                        });
                                      }

                                      _ownerController.text = "";
                                      _addressController.text = "";
                                      Fluttertoast.showToast(
                                          msg:
                                              "Updated BeBeauty's information successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM);
                                    },
                                    color: kPrimaryColor,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Text(
                                      "SAVE",
                                      style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 2.2,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              )
                            ]),
                      ),
                    ),
                  ],
                ))));
  }

  Future<void> getOwnerName() async {
    await _firestore
        .collection(collection)
        .doc('BeBeauty')
        .get()
        .then((result) {
      if (result.exists) {
        setState(() {
          hint_owner = result.get('owner');
        });
      }
    });
  }

  Future<void> getPhoneNumber() async {
    await _firestore
        .collection(collection)
        .doc('BeBeauty')
        .get()
        .then((result) {
      if (result.exists) {
        setState(() {
          phone = result.get('phone');
        });
      }
    });
  }

  Future<void> getAddress() async {
    await _firestore
        .collection(collection)
        .doc('BeBeauty')
        .get()
        .then((result) {
      if (result.exists) {
        setState(() {
          hint_address = result.get('address');
        });
      }
    });
  }
}
