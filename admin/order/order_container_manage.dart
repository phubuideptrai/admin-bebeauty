import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProductInCart.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/ui/admin/order/order_detail_manage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:provider/provider.dart';

import '../../../../../model/MOrder.dart';
import '../../../../../model/MProduct.dart';
import '../../../../../repo/services/cart_services.dart';
import '../../../../../repo/services/order_services.dart';

class ProductContainerManage extends StatefulWidget {
  const ProductContainerManage(
      {Key? key, required this.order, required this.products})
      : super(key: key);

  final MOrder order;
  final List<MProduct> products;

  @override
  _ProductContainerManageState createState() => _ProductContainerManageState();
}

class _ProductContainerManageState extends State<ProductContainerManage> {
  MOrder order =
      new MOrder("", "", "", 0.0, 0.0, 0.0, 0, 0, "", 0.0, 0.0, "", "", 0, 0);

  final cartServices = new CartServices();

  OrderServices orderServices = OrderServices();

  List<MProductInCart> productsInCart = [];

  @override
  void initState() {
    super.initState();
    getProductsInOrder();
  }

  getProductsInOrder() async {
    if (widget.products.length > 0) {
      List<MProductInCart> temp = await orderServices.getProductsInOrder(
          widget.order.id, widget.products);
      setState(() {
        productsInCart = temp;
        order.updateOrder(
            widget.order.id,
            widget.order.userID,
            widget.order.voucherCode,
            widget.order.discountValue,
            widget.order.shippingValue,
            widget.order.totalPayment,
            widget.order.totalQuantity,
            widget.order.numOfProducts,
            widget.order.address,
            widget.order.latitude,
            widget.order.longitude,
            widget.order.userName,
            widget.order.phone,
            widget.order.time,
            widget.order.status);
        order.setProductsInOrder(productsInCart);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackOrderManage(
                      order: order,
                      isAdmin: userProvider.user.role == 0,
                    )),
          );
        },
        child: Container(
          height: 380,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.only(left: 16, top: 8.0, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#' + order.getID().toString(),
                      style: const TextStyle(
                        fontFamily: 'Popppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      order.getNumOfProducts() > 1
                          ? order.getNumOfProducts().toString() + ' items'
                          : order.getNumOfProducts().toString() + ' item',
                      style: const TextStyle(
                        fontFamily: 'Popppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: kTextLightColor,
                  thickness: 1,
                ),
                Text(
                  order.getUserName(),
                  style: const TextStyle(
                    fontFamily: 'Popppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                Text(
                  order.getPhone(),
                  style: const TextStyle(
                    fontFamily: 'Popppins',
                    fontSize: 14,
                    color: kTextLightColor,
                  ),
                ),
                Text(
                  order.getAddress(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: kTextLightColor,
                  ),
                ),
                const Divider(
                  color: kTextLightColor,
                  thickness: 1,
                ),
                Row(
                  children: [
                    Container(
                        height: 80,
                        width: 80,
                        child: order.productsInCart.length > 0
                            ? Image.network(order.productsInCart[0].getImage())
                            : Image.asset('assets/images/loading.png')),
                    const SizedBox(
                      width: 16,
                    ),
                    Container(
                      width: 228,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            order.productsInCart.length > 0
                                ? order.productsInCart[0].getName()
                                : "No information",
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            order.productsInCart.length > 0
                                ? 'x' +
                                    order.productsInCart[0]
                                        .getQuantity()
                                        .toString()
                                : "No information",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: kTextColor,
                                    fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                order.getNumOfProducts() > 1
                    ? Column(
                        children: [
                          Divider(
                            color: kTextLightColor,
                            thickness: 1,
                          ),
                          Text('View more product'),
                          Divider(
                            color: kTextLightColor,
                            thickness: 1,
                          ),
                        ],
                      )
                    : Divider(
                        color: kTextLightColor,
                        thickness: 1,
                      ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order:',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontFamily: 'Popppins',
                              fontSize: 16,
                              color: kTextColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Delivery:',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontFamily: 'Popppins',
                              fontSize: 16,
                              color: kTextColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Discount:',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontFamily: 'Popppins',
                              fontSize: 16,
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
                                  order.productsInCart)
                              .toStringAsFixed(0)
                              .toVND(unit: 'đ'),
                          style: const TextStyle(
                              fontFamily: 'Popppins',
                              fontSize: 16,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          order
                              .getShippingValue()
                              .toStringAsFixed(0)
                              .toVND(unit: 'đ'),
                          style: const TextStyle(
                              fontFamily: 'Popppins',
                              fontSize: 16,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          order
                              .getDiscountValue()
                              .toStringAsFixed(0)
                              .toVND(unit: 'đ'),
                          style: const TextStyle(
                              fontFamily: 'Popppins',
                              fontSize: 16,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
                Divider(
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
                          fontSize: 18,
                          color: kTextColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text(
                      order
                          .getTotalPayment()
                          .toStringAsFixed(0)
                          .toVND(unit: 'đ'),
                      style: const TextStyle(
                          fontFamily: 'Popppins',
                          fontSize: 18,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
