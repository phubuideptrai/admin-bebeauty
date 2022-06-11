import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/authentication_services.dart';
import 'package:bebeautyapp/repo/services/brand_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/admin/Brand/brand_manage.dart';
import 'package:bebeautyapp/ui/admin/Product/product_manage.dart';
import 'package:bebeautyapp/ui/admin/change_infoStore.dart';
import 'package:bebeautyapp/ui/admin/chat/chat_room.dart';
import 'package:bebeautyapp/ui/admin/order/order_manage_screen.dart';
import 'package:bebeautyapp/ui/authenication/login/login_screen.dart';

import 'package:bebeautyapp/ui/profile/profile_screen.dart';
import 'package:bebeautyapp/ui/profile/widgets/change_infomation.dart';
import 'package:bebeautyapp/ui/profile/widgets/change_password.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

class HomeAdmin extends StatelessWidget {
  HomeAdmin({Key? key}) : super(key: key);
  final productServices = new ProductServices();
  final brandServices = new BrandServices();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("BE BEAUTY MANAGEMENT"),
        titleTextStyle: const TextStyle(
            color: kPrimaryColor,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(userProvider.user.getAvatarUri()),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen()),
                  );
                },
              ),
            ),
          )
        ],
      ),
      backgroundColor: Color(0xffc1c2c6).withOpacity(0.2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileMenu(
                text: "Brand",
                icon: "assets/icons/brand.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BrandManage()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "Product ",
                icon: "assets/icons/package.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductManage()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "Order ",
                icon: "assets/icons/orders.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderManageScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "Chat",
                icon: "assets/icons/chat.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatRoomAdmin()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "Information",
                icon: "assets/icons/settings.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeInformationScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "Settings",
                icon: "assets/icons/settings.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "Log Out",
                icon: "assets/icons/log_out.svg",
                press: () {
                  signOutDrawer(context);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

void signOutDrawer(BuildContext context) {
  final authServices = new AuthenticationServices();
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      isDismissible: false,
      context: context,
      builder: (context) {
        return Container(
          height: 150.0,
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Are you sure you want Logout ?',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("NO",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  MaterialButton(
                    onPressed: () {
                      authServices.signOut();
                      Fluttertoast.showToast(
                          msg: 'Logged out successfully.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    color: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "YES",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      });
}
