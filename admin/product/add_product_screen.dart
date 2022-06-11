import 'dart:io';

import 'package:bebeautyapp/model/MBrand.dart';
import 'package:bebeautyapp/model/MCategory.dart';
import 'package:bebeautyapp/model/MGender.dart';
import 'package:bebeautyapp/model/MOrigin.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/MSession.dart';
import 'package:bebeautyapp/model/MSkin.dart';
import 'package:bebeautyapp/model/MStructure.dart';
import 'package:bebeautyapp/repo/providers/brand_provider.dart';
import 'package:bebeautyapp/repo/providers/category_provider.dart';
import 'package:bebeautyapp/repo/providers/origin_provider.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/services/gender_services.dart';
import 'package:bebeautyapp/repo/services/image_services.dart';
import 'package:bebeautyapp/repo/services/session_services.dart';
import 'package:bebeautyapp/repo/services/skin_services.dart';
import 'package:bebeautyapp/repo/services/structure_services.dart';
import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';

import 'package:bebeautyapp/ui/profile/widgets/sticky_label.dart';
import 'package:flutter/material.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../repo/services/product_services.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({
    Key? key,
  }) : super(key: key);
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _engNameController = TextEditingController();
  final TextEditingController _guideLineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _popularSearchTitleController =
      TextEditingController();

  final TextEditingController _marketPriceController = TextEditingController();
  final TextEditingController _importPriceController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountRateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _chemicalCompositionController =
      TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final editButtonController = RoundedLoadingButtonController();

  final skinServices = SkinServices();
  final sessionServices = SessionServices();
  final structureServices = StructureServices();
  final genderServices = GenderServices();
  final imageServices = new ImageServices();
  final productServices = new ProductServices();

  final ImagePicker imagePicker = ImagePicker();
  List<File> fileImageArray = [];
  List<Asset> images = [];

  List<MSkin> skins = [];
  List<MSession> sessions = [];
  List<MGender> genders = [];
  List<MStructure> structures = [];

  late int brandId,
      categoryId,
      genderId,
      originId,
      skinId,
      structureId,
      sessionId;
  String name = "";
  String engName = "";
  double price = 0;
  double marketPrice = 0;
  double importPrice = 0;
  int discountRate = 0;
  int quantity = 0;
  String chemicalComposition = "";
  String guideLine = "";
  String description = "";
  String popularSearchTitle = "";

  @override
  void initState() {
    super.initState();
    brandId = 1;
    categoryId = 1;
    genderId = 1;
    originId = 1;
    skinId = 1;
    structureId = 1;
    sessionId = 1;

    skins = skinServices.getSkins();
    sessions = sessionServices.getSessions();
    genders = genderServices.getGenders();
    structures = structureServices.getStructures();
  }

  void selectImages() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Be Beauty",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
    setState(() {
      images = resultList;
      fileImageArray = imageServices.convertAssetListToFileList(resultList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final brandProvider = Provider.of<BrandProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final originProvider = Provider.of<OriginProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(
            color: kPrimaryColor,
          ),
          title: Text('Product'),
          titleTextStyle: const TextStyle(
              color: kPrimaryColor,
              fontSize: 18,
              fontFamily: 'Laila',
              fontWeight: FontWeight.w700),
          centerTitle: true,
        ),
        drawer: Drawer(),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    StickyLabel(
                        text: 'Name', textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      controller: _nameController,
                      cursorColor: kTextColor,
                      maxLines: 2,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Name is empty';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    StickyLabel(
                        text: 'English Name',
                        textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      onChanged: (value) {
                        engName = value;
                      },
                      controller: _engNameController,
                      maxLines: 2,
                      cursorColor: kTextColor,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'English Name is empty';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    StickyLabel(
                        text: 'Category', textStyle: TextStyle(fontSize: 14)),
                    Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Select"),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16,
                              ),
                              underline: SizedBox(),
                              value: categoryId.toString(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  categoryId = int.parse(newValue.toString());
                                });
                              },
                              items: categoryProvider.categories
                                  .map<DropdownMenuItem<String>>(
                                      (MCategory value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.getName()),
                                );
                              }).toList(),
                            ))),
                    StickyLabel(
                        text: 'Brand', textStyle: TextStyle(fontSize: 14)),
                    Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Select"),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16,
                              ),
                              underline: SizedBox(),
                              value: brandId.toString(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  brandId = int.parse(newValue.toString());
                                });
                              },
                              items: brandProvider.brands
                                  .map<DropdownMenuItem<String>>(
                                      (MBrand value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.getName()),
                                );
                              }).toList(),
                            ))),
                    StickyLabel(
                        text: 'Origin', textStyle: TextStyle(fontSize: 14)),
                    Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Select"),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16,
                              ),
                              underline: SizedBox(),
                              value: originId.toString(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  originId = int.parse(newValue.toString());
                                });
                              },
                              items: originProvider.origins
                                  .map<DropdownMenuItem<String>>(
                                      (MOrigin value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.getName()),
                                );
                              }).toList(),
                            ))),
                    StickyLabel(
                        text: 'Skin', textStyle: TextStyle(fontSize: 14)),
                    Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Select"),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16,
                              ),
                              underline: SizedBox(),
                              value: skinId.toString(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  skinId = int.parse(newValue.toString());
                                });
                              },
                              items: skins
                                  .map<DropdownMenuItem<String>>((MSkin value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.getName()),
                                );
                              }).toList(),
                            ))),
                    StickyLabel(
                        text: 'Session', textStyle: TextStyle(fontSize: 14)),
                    Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Select"),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16,
                              ),
                              underline: SizedBox(),
                              value: sessionId.toString(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  sessionId = int.parse(newValue.toString());
                                });
                              },
                              items: sessions.map<DropdownMenuItem<String>>(
                                  (MSession value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.getName()),
                                );
                              }).toList(),
                            ))),
                    StickyLabel(
                        text: 'Gender', textStyle: TextStyle(fontSize: 14)),
                    Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Select"),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16,
                              ),
                              underline: SizedBox(),
                              value: genderId.toString(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  genderId = int.parse(newValue.toString());
                                });
                              },
                              items: genders.map<DropdownMenuItem<String>>(
                                  (MGender value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.getName()),
                                );
                              }).toList(),
                            ))),
                    StickyLabel(
                        text: 'Structure', textStyle: TextStyle(fontSize: 14)),
                    Padding(
                        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Select"),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16,
                              ),
                              underline: SizedBox(),
                              value: structureId.toString(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  structureId = int.parse(newValue.toString());
                                });
                              },
                              items: structures.map<DropdownMenuItem<String>>(
                                  (MStructure value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.getName()),
                                );
                              }).toList(),
                            ))),
                    StickyLabel(
                        text: 'Price(đ)', textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        price = double.parse(value);
                        if (_marketPriceController.text != "" &&
                            _priceController.text != "") {
                          double dPrice = double.parse(_priceController.text);
                          double dMarketPrice =
                              double.parse(_marketPriceController.text);

                          int iDiscountRate =
                              100 - (dPrice / dMarketPrice * 100).round();
                          _discountRateController.text =
                              iDiscountRate.toString();
                        }
                      },
                      controller: _priceController,
                      cursorColor: kTextColor,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Price is empty';
                        } else if (_marketPriceController.text != "" &&
                            double.parse(_marketPriceController.text) <
                                double.parse(_priceController.text)) {
                          return 'Price can not be much more than market price';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    StickyLabel(
                        text: 'Market Price(đ)',
                        textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        marketPrice = double.parse(value);
                        if (_marketPriceController.text != "" &&
                            _priceController.text != "") {
                          double dPrice = double.parse(_priceController.text);
                          double dMarketPrice =
                              double.parse(_marketPriceController.text);

                          int iDiscountRate =
                              100 - (dPrice / dMarketPrice * 100).round();
                          _discountRateController.text =
                              iDiscountRate.toString();
                        }
                      },
                      controller: _marketPriceController,
                      cursorColor: kTextColor,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Market Price is empty';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    StickyLabel(
                        text: 'Discount Rate(%)',
                        textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          discountRate = int.parse(value);
                          if (_marketPriceController.text != "" &&
                              _discountRateController.text != "") {
                            int iDiscountRate =
                                int.parse(_discountRateController.text);
                            double dMarketPrice =
                                double.parse(_marketPriceController.text);

                            int iPrice = (dMarketPrice -
                                    (dMarketPrice * iDiscountRate / 100))
                                .round();
                            _priceController.text = iPrice.toString();
                          }
                        });
                      },
                      keyboardType: TextInputType.number,
                      controller: _discountRateController,
                      cursorColor: kTextColor,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Discount Rate is empty';
                        } else if (int.parse(_discountRateController.text) >
                            100) {
                          return 'Discount rate can not be over 100';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    StickyLabel(
                        text: 'Import Price(đ)',
                        textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        importPrice = double.parse(value);
                      },
                      controller: _importPriceController,
                      cursorColor: kTextColor,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Import Price is empty';
                        } else if (_importPriceController.text != "" &&
                            double.parse(_importPriceController.text) >
                                double.parse(_priceController.text)) {
                          return 'Import price can not be exceeded price';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    StickyLabel(
                        text: 'Guideline', textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      onChanged: (value) {
                        guideLine = value;
                      },
                      controller: _guideLineController,
                      maxLines: 4,
                      cursorColor: kTextColor,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Guideline is empty';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    StickyLabel(
                        text: 'Description',
                        textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      onChanged: (value) {
                        description = value;
                      },
                      controller: _descriptionController,
                      maxLines: 8,
                      cursorColor: kTextColor,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Description is empty';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    StickyLabel(
                        text: 'Quantity', textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      onChanged: (value) {
                        quantity = int.parse(value);
                      },
                      keyboardType: TextInputType.number,
                      controller: _quantityController,
                      cursorColor: kTextColor,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Available is empty';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    StickyLabel(
                        text: 'Popular Search Title',
                        textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      onChanged: (value) {
                        popularSearchTitle = value;
                      },
                      controller: _popularSearchTitleController,
                      cursorColor: kTextColor,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Popular Search Title is empty';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    StickyLabel(
                        text: 'Chemical Composition',
                        textStyle: TextStyle(fontSize: 14)),
                    TextFormField(
                      onChanged: (value) {
                        chemicalComposition = value;
                      },
                      controller: _chemicalCompositionController,
                      cursorColor: kTextColor,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Chemical Composition is empty';
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1),
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
                    MaterialButton(
                      color: kPrimaryColor,
                      onPressed: () {
                        selectImages();
                      },
                      child: Text(
                        'Select Images',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 380,
                      child: GridView.count(
                        scrollDirection: Axis.horizontal,
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        children: List.generate(fileImageArray.length, (index) {
                          return Image.file(
                            fileImageArray[index],
                            fit: BoxFit.cover,
                          );
                        }),
                      ),
                    ),
                    CustomRoundedLoadingButton(
                      text: 'Save',
                      controller: editButtonController,
                      onPress: () async {
                        editButtonController.start();
                        if (formKey.currentState!.validate()) {
                          if (fileImageArray.length == 0) {
                            editButtonController.stop();
                            Fluttertoast.showToast(
                                msg:
                                    'Please add at least one image before adding a new product.',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            List<String> imageUrls = await imageServices
                                .addImagesAndReturnStrings(fileImageArray);
                            int newProductID = productServices
                                .getNewProductID(productProvider.products);
                            MProduct new_product = new MProduct(
                                id: newProductID,
                                name: name,
                                engName: engName,
                                brandID: brandId,
                                categoryID: categoryId,
                                originID: originId,
                                skinID: skinId,
                                sessionID: sessionId,
                                genderID: genderId,
                                structureID: structureId,
                                soldOut: 0,
                                totalStarRating: 0,
                                totalRating: 0,
                                marketPrice: marketPrice,
                                importPrice: importPrice,
                                defaultDiscountRate: discountRate,
                                price: price,
                                chemicalComposition: chemicalComposition,
                                guideLine: guideLine,
                                images: imageUrls,
                                userFavorite: [],
                                available: quantity,
                                searchCount: 0,
                                popularSearchTitle: popularSearchTitle,
                                description: description);

                            bool result = await productServices.addProduct(
                                new_product, newProductID);
                            if (result == false) {
                              editButtonController.stop();
                              Fluttertoast.showToast(
                                  msg:
                                      'Some errors happened when adding a new product.',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM);
                            } else {
                              productProvider.addProduct(new_product);
                              brandProvider.updateTotalQuantity(
                                  new_product.getBrandID());
                              setState(() {
                                _nameController.text = "";
                                _engNameController.text = "";
                                _marketPriceController.text = "";
                                _importPriceController.text = "";
                                _discountRateController.text = "";
                                _priceController.text = "";
                                _chemicalCompositionController.text = "";
                                _guideLineController.text = "";
                                _quantityController.text = "";
                                _popularSearchTitleController.text = "";
                                _descriptionController.text = "";
                                images = [];
                                fileImageArray = [];
                              });
                            }
                            editButtonController.success();
                            Future.delayed(const Duration(milliseconds: 1500),
                                () {
                              editButtonController.stop();
                              Fluttertoast.showToast(
                                  msg: 'Add new product successfully.',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM);
                            });
                          }
                        } else
                          editButtonController.stop();
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    )
                  ],
                ),
              )),
        ));
  }
}
