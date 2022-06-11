import 'dart:io';

import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MBrand.dart';
import 'package:bebeautyapp/repo/providers/brand_provider.dart';
import 'package:bebeautyapp/repo/services/brand_services.dart';
import 'package:bebeautyapp/repo/services/image_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';
import 'package:bebeautyapp/ui/profile/widgets/sticky_label.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddBrand extends StatefulWidget {
  AddBrand({Key? key}) : super(key: key);

  @override
  _AddBrandState createState() => new _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {
  final formKey = GlobalKey<FormState>();
  final imageServices = new ImageServices();
  final brandServices = new BrandServices();

  final addButtonController = RoundedLoadingButtonController();
  File? imageFile = null;
  String nameBrand = '';
  TextEditingController nameController = TextEditingController();
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandProvider = Provider.of<BrandProvider>(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text("Add Brand"),
          titleTextStyle: const TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: BackButton(color: kPrimaryColor),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
              child: Column(children: [
                StickyLabel(text: 'Name', textStyle: TextStyle(fontSize: 14)),
                TextFormField(
                  onChanged: (value) {
                    nameBrand = value;
                  },
                  cursorColor: kTextColor,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Name is empty';
                    } else
                      return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: kPrimaryColor, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: kDefaultPadding / 2,
                ),
                StickyLabel(text: 'Image', textStyle: TextStyle(fontSize: 14)),
                imageFile == null
                    ? Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.greenAccent,
                              onPressed: () {
                                _getFromGallery();
                              },
                              child: Text("PICK FROM GALLERY"),
                            ),
                            Container(
                              height: 40.0,
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          RaisedButton(
                            color: Colors.greenAccent,
                            onPressed: () {
                              _getFromGallery();
                            },
                            child: Text("PICK FROM GALLERY"),
                          ),
                        ],
                      ),
                CustomRoundedLoadingButton(
                  text: 'Add',
                  controller: addButtonController,
                  onPress: () async {
                    addButtonController.start();
                    if (formKey.currentState!.validate()) {
                      if(imageFile == null) {
                        addButtonController.stop();
                        Fluttertoast.showToast(msg: 'Please add image before adding a new brand.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                      }
                      else {
                        String imageUrl = await imageServices.addImageAndReturnString(imageFile);
                        int newBrandID = brandServices.getNewBrandID(brandProvider.brands);
                        MBrand new_brand = new MBrand(id: newBrandID, name: nameBrand, imageUri: imageUrl, productQuantity: 0, totalSoldOut: 0);
                        bool result = await brandServices.addBrand(new_brand);
                        if(result == false) {
                          addButtonController.stop();
                          Fluttertoast.showToast(msg: 'Some errors happened when adding a new brand.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                        }
                        else {
                          brandProvider.addBrand(new_brand);
                          setState(() {
                            nameController.text = "";
                            nameBrand = "";
                            imageFile = null;
                          });

                          addButtonController.success();
                          Future.delayed(const Duration(milliseconds: 1500), () {
                            addButtonController.stop();
                            Fluttertoast.showToast(msg: 'Add new brand successfully.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);

                          });
                        }
                      }
                    }
                    else addButtonController.stop();
                  },
                ),
              ]),
            ))));
  }
}
