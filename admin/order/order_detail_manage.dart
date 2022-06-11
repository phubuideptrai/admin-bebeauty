import 'dart:ui';

import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MStatus.dart';
import 'package:bebeautyapp/repo/services/cart_services.dart';
import 'package:bebeautyapp/ui/profile/widgets/sticky_label.dart';

import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

import '../../../../../model/MOrder.dart';
import '../../../../../repo/services/order_services.dart';
import 'order_manage_screen.dart';

class TrackOrderManage extends StatefulWidget {
  const TrackOrderManage({Key? key, required this.order, required this.isAdmin})
      : super(key: key);

  @override
  _TrackOrderManageState createState() => _TrackOrderManageState();
  final MOrder order;

  final bool isAdmin;
}

class _TrackOrderManageState extends State<TrackOrderManage> {
  final orderServices = new OrderServices();
  List<MStatus> statuses = [];

  late int statusId;
  @override
  void initState() {
    super.initState();
    statusId = widget.order.status;
    statuses = orderServices.getStatusesForAdmin(statusId);
  }

  final cartServices = new CartServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: kPrimaryColor),
        title: const Text(
          'Track order',
          style: TextStyle(
            fontFamily: "Laila",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          (widget.order.status == 0 || widget.order.status == 1)
              ? TextButton(
                  onPressed: () async {
                    bool result = await orderServices.updateOrderStatus(
                        widget.order.id, -1);
                    if (result == false) {
                      Fluttertoast.showToast(
                          msg:
                              'Some errors happened when trying to cancel this order.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Cancelled this order successfully.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderManageScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, top: 8.0, right: 16),
              width: 400,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order.getDate(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: kLightColor,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Order ID : ",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: kLightColor,
                            ),
                          ),
                          SelectableText(
                            widget.order.getID(),
                            toolbarOptions: ToolbarOptions(
                                copy: true,
                                selectAll: true,
                                cut: false,
                                paste: false),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: kCopy,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, top: 8.0, right: 16),
              width: 400,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order.getUserName(),
                        style: const TextStyle(
                          fontFamily: 'Popppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(
                        widget.order.getPhone(),
                        style: const TextStyle(
                          fontFamily: 'Popppins',
                          fontSize: 14,
                          color: kTextLightColor,
                        ),
                      ),
                      Text(
                        widget.order.getAddress(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: kTextLightColor,
                        ),
                      ),
                      widget.order.status != 5 &&
                              widget.order.status != -1 &&
                              widget.isAdmin == true
                          ? Column(
                              children: [
                                StickyLabel(
                                    text: 'Status',
                                    textStyle: TextStyle(fontSize: 14)),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 4.0, bottom: 4.0),
                                    child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
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
                                          value: statusId.toString(),
                                          onChanged: (String? newValue) async {
                                            if (statusId !=
                                                int.parse(
                                                    newValue.toString())) {
                                              int newStatus = int.parse(
                                                  newValue.toString());
                                              bool result = await orderServices
                                                  .updateOrderStatus(
                                                      widget.order.id,
                                                      newStatus);

                                              if (result == false) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Some errors happened when trying to update this order's status.",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Updated this order's status successfully.",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM);
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderManageScreen()),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              }
                                            }
                                          },
                                          items: statuses
                                              .map<DropdownMenuItem<String>>(
                                                  (MStatus value) {
                                            return DropdownMenuItem<String>(
                                              value: value.id.toString(),
                                              child: Text(value.getName()),
                                            );
                                          }).toList(),
                                        ))),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Order:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: 'Popppins',
                                    fontSize: 14,
                                    color: kTextColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Delivery:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: 'Popppins',
                                    fontSize: 14,
                                    color: kTextColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Discount:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: 'Popppins',
                                    fontSize: 14,
                                    color: kTextColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                cartServices
                                    .totalValueOfSelectedProductsInCart(
                                        widget.order.productsInCart)
                                    .toStringAsFixed(0)
                                    .toVND(unit: 'đ'),
                                style: const TextStyle(
                                    fontFamily: 'Popppins',
                                    fontSize: 14,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.order
                                    .getShippingValue()
                                    .toStringAsFixed(0)
                                    .toVND(unit: 'đ'),
                                style: const TextStyle(
                                    fontFamily: 'Popppins',
                                    fontSize: 14,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.order
                                    .getDiscountValue()
                                    .toStringAsFixed(0)
                                    .toVND(unit: 'đ'),
                                style: const TextStyle(
                                    fontFamily: 'Popppins',
                                    fontSize: 14,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Divider(
                        color: kTextLightColor,
                        thickness: 1,
                      ),
                      Row(
                        children: [
                          Text(
                            'Total:',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontFamily: 'Popppins',
                                fontSize: 16,
                                color: kTextColor,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Text(
                            widget.order
                                .getTotalPayment()
                                .toStringAsFixed(0)
                                .toVND(unit: 'đ'),
                            style: const TextStyle(
                                fontFamily: 'Popppins',
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.order.getProductsInOrder().length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.network(
                              widget.order
                                  .getProductsInOrder()[index]
                                  .getImage(),
                              height: 80,
                              width: 80,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 12.0),
                              width: 250,
                              child: Text(
                                widget.order
                                    .getProductsInOrder()[index]
                                    .getName(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                                'x${widget.order.getProductsInOrder()[index].getQuantity()}'),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
