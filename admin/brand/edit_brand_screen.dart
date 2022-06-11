import 'dart:io';

import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MBrand.dart';
import 'package:bebeautyapp/repo/providers/brand_provider.dart';
import 'package:bebeautyapp/repo/services/brand_services.dart';
import 'package:bebeautyapp/repo/services/image_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';
import 'package:bebeautyapp/ui/profile/widgets/sticky_label.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class EditBrand extends StatefulWidget {
  final MBrand brand;
  EditBrand({Key? key, required this.brand}) : super(key: key);

  @override
  _EditBrandState createState() => new _EditBrandState();
}

class _EditBrandState extends State<EditBrand> {
  final formKey = GlobalKey<FormState>();
  final brandServices = new BrandServices();
  final imageServices = new ImageServices();

  final addButtonController = RoundedLoadingButtonController();
  File? imageFile = null;
  String nameBrand = '';
  bool isGetFile = false;
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
        isGetFile = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.brand.name;
  }

  @override
  Widget build(BuildContext context) {
    final brandProvider = Provider.of<BrandProvider>(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text("Brand Manage"),
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
                Column(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            child: isGetFile ?
                            Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                            )
                            :
                            Image.network(
                              widget.brand.imageUri,
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
                  text: 'Update',
                  controller: addButtonController,
                  onPress: () async {
                    addButtonController.start();
                    if (formKey.currentState!.validate()) {
                      bool result1 = await brandServices.updateBrandName(widget.brand);
                      bool result2 = true;
                      if(imageFile != null) {
                        String imageUrl = await imageServices.addImageAndReturnString(imageFile);
                        widget.brand.setImage(imageUrl);
                        result2 = await brandServices.updateBrandImage(widget.brand);
                      }

                      if(result1 == true && result2 == true) {
                        brandProvider.updateBrand(widget.brand);
                        addButtonController.success();
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          addButtonController.stop();
                          Fluttertoast.showToast(msg: 'Update selected brand successfully.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                        });
                      }
                      else {
                        Fluttertoast.showToast(msg: 'Some errors happened when updating.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                      }
                    }
                    else addButtonController.stop();
                  },
                ),
              ]),
            ))));
  }
}
