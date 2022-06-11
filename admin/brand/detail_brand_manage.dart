import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MBrand.dart';

import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/preference_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/admin/brand/add_brand_screen.dart';
import 'package:bebeautyapp/ui/admin/brand/edit_brand_screen.dart';
import 'package:bebeautyapp/ui/admin/product/detail_product_manage.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class DetailsBrandManage extends StatefulWidget {
  final MBrand brand;
  final List<MProduct> allProductsFromBrand;

  const DetailsBrandManage(
      {Key? key, required this.brand, required this.allProductsFromBrand})
      : super(key: key);
  @override
  _DetailsBrandManage createState() => new _DetailsBrandManage();
}

class _DetailsBrandManage extends State<DetailsBrandManage> {
  @override
  Widget build(BuildContext context) {
    final preferenceServices = new PreferenceServices();
    final productProvider = Provider.of<ProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final editButtonController = RoundedLoadingButtonController();
    final productServices = new ProductServices();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(
          color: kPrimaryColor,
        ),
        title: Text(widget.brand.name),
        titleTextStyle: const TextStyle(
            color: kPrimaryColor,
            fontSize: 18,
            fontFamily: 'Laila',
            fontWeight: FontWeight.w700),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditBrand(brand: widget.brand),
              ),
            ),
            icon: const Icon(
              Icons.edit,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 153,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: GridView.builder(
                          itemCount: widget.allProductsFromBrand.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: kDefaultPadding,
                            crossAxisSpacing: kDefaultPadding,
                            childAspectRatio: 0.5,
                          ),
                          itemBuilder: (context, index) => ProductCard(
                            rating: false,
                            product: widget.allProductsFromBrand[index],
                            press: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsProductManageScreen(
                                      product:
                                          widget.allProductsFromBrand[index],
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
