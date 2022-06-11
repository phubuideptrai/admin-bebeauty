import 'dart:io';

import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/providers/brand_provider.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/admin/Brand/detail_brand_manage.dart';
import 'package:bebeautyapp/ui/admin/brand/add_brand_screen.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/brand/brand_card.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class BrandManage extends StatefulWidget {
  BrandManage({Key? key}) : super(key: key);

  @override
  _BrandManageState createState() => new _BrandManageState();
}

class _BrandManageState extends State<BrandManage> {
  final productServices = new ProductServices();
  late File? imageFile = null;
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
    final productProvider = Provider.of<ProductProvider>(context);
    final brandProvider = Provider.of<BrandProvider>(context);
    final _formKey = GlobalKey<FormState>();
    final addButtonController = RoundedLoadingButtonController();
    String name = '';
    String url = '';
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
        leading: BackButton(
          color: kPrimaryColor,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBrand(),
              ),
            ),
            icon: const Icon(
              Icons.add,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: GridView.builder(
                  itemCount: brandProvider.brands.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: kDefaultPadding,
                    crossAxisSpacing: kDefaultPadding,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) => SpecialOfferCard(
                    category: brandProvider.brands[index].getName(),
                    image: brandProvider.brands[index].getImage(),
                    numOfBrands: brandProvider.brands[index].productQuantity,
                    press: () {
                      List<MProduct> allProductsFromBrand =
                          productServices.getAllProductsFromBrand(
                              productProvider.products,
                              brandProvider.brands[index].id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsBrandManage(
                              brand: brandProvider.brands[index],
                              allProductsFromBrand: allProductsFromBrand,
                            ),
                          ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
