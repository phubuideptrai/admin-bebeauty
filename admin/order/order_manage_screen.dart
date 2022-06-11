import 'dart:async';

import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MStatus.dart';
import 'package:bebeautyapp/ui/admin/home_admin.dart';
import 'package:bebeautyapp/ui/admin/order/order_container_manage.dart';
import 'package:bebeautyapp/ui/home/payment/order_checkout/widget/product_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../model/MOrder.dart';
import '../../../../model/MProduct.dart';
import '../../../../repo/providers/product_provider.dart';
import '../../../../repo/services/order_services.dart';

class OrderManageScreen extends StatefulWidget {
  const OrderManageScreen({Key? key}) : super(key: key);

  @override
  _OrderManageScreen createState() => _OrderManageScreen();
}

class _OrderManageScreen extends State<OrderManageScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  Stream<QuerySnapshot>? pendingOrders;
  Stream<QuerySnapshot>? preparingOrders;
  Stream<QuerySnapshot>? shippingOrders;
  Stream<QuerySnapshot>? receivedOrders;
  Stream<QuerySnapshot>? completedOrders;
  Stream<QuerySnapshot>? ratedOrders;
  Stream<QuerySnapshot>? canceledOrders;
  final orderServices = new OrderServices();
  List<Tab> tabs = [];
  List<MStatus> statuses = [];

  @override
  void initState() {
    super.initState();

    getTabs();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.animateTo(2);

    getOrders();
  }

  void getTabs() {
    statuses = orderServices.getAllStatuses();
    for (int i = 0; i < statuses.length; i++) {
      tabs.add(Tab(text: statuses[i].name));
    }
  }

  getOrders() async {
    int status1 = orderServices.getStatusByTabName("Pending");
    await orderServices.getOrderByStatus(status1).then((snapshots) {
      setState(() {
        pendingOrders = snapshots;
      });
    });

    int status2 = orderServices.getStatusByTabName("Preparing");
    await orderServices.getOrderByStatus(status2).then((snapshots) {
      setState(() {
        preparingOrders = snapshots;
      });
    });

    int status3 = orderServices.getStatusByTabName("Shipping");
    await orderServices.getOrderByStatus(status3).then((snapshots) {
      setState(() {
        shippingOrders = snapshots;
      });
    });

    int status4 = orderServices.getStatusByTabName("Received");
    await orderServices.getOrderByStatus(status4).then((snapshots) {
      setState(() {
        receivedOrders = snapshots;
      });
    });

    int status5 = orderServices.getStatusByTabName("Rated");
    await orderServices.getOrderByStatus(status5).then((snapshots) {
      setState(() {
        ratedOrders = snapshots;
      });
    });

    int status6 = orderServices.getStatusByTabName("Completed");
    await orderServices.getOrderByStatus(status6).then((snapshots) {
      setState(() {
        completedOrders = snapshots;
      });
    });

    int status7 = orderServices.getStatusByTabName("Cancelled");
    print(status7);
    await orderServices.getOrderByStatus(status7).then((snapshots) {
      setState(() {
        canceledOrders = snapshots;
      });
    });
  }




  static Widget not_orders = Column(
    children: [
      Container(
        height: 200,
        width: 200,
        child: SvgPicture.asset('assets/icons/not_order.svg'),
      ),
      Text('No Orders Yet'),
    ],
  );

  Widget PendingOrderList(List<MProduct> products) {
    return StreamBuilder<QuerySnapshot>(
        stream: pendingOrders,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.docs.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    MOrder order = new MOrder(
                        snapshot.data!.docs[index]["orderID"],
                        snapshot.data!.docs[index]["userID"],
                        snapshot.data!.docs[index]["voucherCode"],
                        snapshot.data!.docs[index]["discountValue"],
                        snapshot.data!.docs[index]["shippingValue"],
                        snapshot.data!.docs[index]["totalPayment"],
                        snapshot.data!.docs[index]["totalQuantity"],
                        snapshot.data!.docs[index]["numOfProducts"],
                        snapshot.data!.docs[index]["address"],
                        snapshot.data!.docs[index]["latitude"],
                        snapshot.data!.docs[index]["longitude"],
                        snapshot.data!.docs[index]["userName"],
                        snapshot.data!.docs[index]["phone"],
                        snapshot.data!.docs[index]["time"],
                        snapshot.data!.docs[index]["status"]);

                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: ProductContainerManage(
                        order: order,
                        products: products,
                      ),
                    );
                  })
              : Center(child: not_orders);
        });
  }

  Widget PreparingOrderList(List<MProduct> products) {
    return StreamBuilder<QuerySnapshot>(
        stream: preparingOrders,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.docs.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    MOrder order = new MOrder(
                        snapshot.data!.docs[index]["orderID"],
                        snapshot.data!.docs[index]["userID"],
                        snapshot.data!.docs[index]["voucherCode"],
                        snapshot.data!.docs[index]["discountValue"],
                        snapshot.data!.docs[index]["shippingValue"],
                        snapshot.data!.docs[index]["totalPayment"],
                        snapshot.data!.docs[index]["totalQuantity"],
                        snapshot.data!.docs[index]["numOfProducts"],
                        snapshot.data!.docs[index]["address"],
                        snapshot.data!.docs[index]["latitude"],
                        snapshot.data!.docs[index]["longitude"],
                        snapshot.data!.docs[index]["userName"],
                        snapshot.data!.docs[index]["phone"],
                        snapshot.data!.docs[index]["time"],
                        snapshot.data!.docs[index]["status"]);

                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: ProductContainerManage(
                        order: order,
                        products: products,
                      ),
                    );
                  })
              : Center(child: not_orders);
        });
  }

  Widget ShippingOrderList(List<MProduct> products) {
    return StreamBuilder<QuerySnapshot>(
        stream: shippingOrders,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.docs.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    MOrder order = new MOrder(
                        snapshot.data!.docs[index]["orderID"],
                        snapshot.data!.docs[index]["userID"],
                        snapshot.data!.docs[index]["voucherCode"],
                        snapshot.data!.docs[index]["discountValue"],
                        snapshot.data!.docs[index]["shippingValue"],
                        snapshot.data!.docs[index]["totalPayment"],
                        snapshot.data!.docs[index]["totalQuantity"],
                        snapshot.data!.docs[index]["numOfProducts"],
                        snapshot.data!.docs[index]["address"],
                        snapshot.data!.docs[index]["latitude"],
                        snapshot.data!.docs[index]["longitude"],
                        snapshot.data!.docs[index]["userName"],
                        snapshot.data!.docs[index]["phone"],
                        snapshot.data!.docs[index]["time"],
                        snapshot.data!.docs[index]["status"]);

                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: ProductContainerManage(
                        order: order,
                        products: products,
                      ),
                    );
                  })
              : Center(child: not_orders);
        });
  }

  Widget ReceivedOrderList(List<MProduct> products) {
    return StreamBuilder<QuerySnapshot>(
        stream: receivedOrders,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.docs.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    MOrder order = new MOrder(
                        snapshot.data!.docs[index]["orderID"],
                        snapshot.data!.docs[index]["userID"],
                        snapshot.data!.docs[index]["voucherCode"],
                        snapshot.data!.docs[index]["discountValue"],
                        snapshot.data!.docs[index]["shippingValue"],
                        snapshot.data!.docs[index]["totalPayment"],
                        snapshot.data!.docs[index]["totalQuantity"],
                        snapshot.data!.docs[index]["numOfProducts"],
                        snapshot.data!.docs[index]["address"],
                        snapshot.data!.docs[index]["latitude"],
                        snapshot.data!.docs[index]["longitude"],
                        snapshot.data!.docs[index]["userName"],
                        snapshot.data!.docs[index]["phone"],
                        snapshot.data!.docs[index]["time"],
                        snapshot.data!.docs[index]["status"]);

                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: ProductContainerManage(
                        order: order,
                        products: products,
                      ),
                    );
                  })
              : Center(child: not_orders);
        });
  }

  Widget RatedOrderList(List<MProduct> products) {
    return StreamBuilder<QuerySnapshot>(
        stream: ratedOrders,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.docs.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    MOrder order = new MOrder(
                        snapshot.data!.docs[index]["orderID"],
                        snapshot.data!.docs[index]["userID"],
                        snapshot.data!.docs[index]["voucherCode"],
                        snapshot.data!.docs[index]["discountValue"],
                        snapshot.data!.docs[index]["shippingValue"],
                        snapshot.data!.docs[index]["totalPayment"],
                        snapshot.data!.docs[index]["totalQuantity"],
                        snapshot.data!.docs[index]["numOfProducts"],
                        snapshot.data!.docs[index]["address"],
                        snapshot.data!.docs[index]["latitude"],
                        snapshot.data!.docs[index]["longitude"],
                        snapshot.data!.docs[index]["userName"],
                        snapshot.data!.docs[index]["phone"],
                        snapshot.data!.docs[index]["time"],
                        snapshot.data!.docs[index]["status"]);

                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: ProductContainerManage(
                        order: order,
                        products: products,
                      ),
                    );
                  })
              : Center(child: not_orders);
        });
  }

  Widget CompletedOrderList(List<MProduct> products) {
    return StreamBuilder<QuerySnapshot>(
        stream: completedOrders,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.docs.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    MOrder order = new MOrder(
                        snapshot.data!.docs[index]["orderID"],
                        snapshot.data!.docs[index]["userID"],
                        snapshot.data!.docs[index]["voucherCode"],
                        snapshot.data!.docs[index]["discountValue"],
                        snapshot.data!.docs[index]["shippingValue"],
                        snapshot.data!.docs[index]["totalPayment"],
                        snapshot.data!.docs[index]["totalQuantity"],
                        snapshot.data!.docs[index]["numOfProducts"],
                        snapshot.data!.docs[index]["address"],
                        snapshot.data!.docs[index]["latitude"],
                        snapshot.data!.docs[index]["longitude"],
                        snapshot.data!.docs[index]["userName"],
                        snapshot.data!.docs[index]["phone"],
                        snapshot.data!.docs[index]["time"],
                        snapshot.data!.docs[index]["status"]);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: ProductContainerManage(
                        order: order,
                        products: products,
                      ),
                    );
                  })
              : Center(child: not_orders);
        });
  }

  Widget CanceledOrderList(List<MProduct> products) {
    return StreamBuilder<QuerySnapshot>(
        stream: canceledOrders,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.hasData && snapshot.data!.docs.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    MOrder order = new MOrder(
                        snapshot.data!.docs[index]["orderID"],
                        snapshot.data!.docs[index]["userID"],
                        snapshot.data!.docs[index]["voucherCode"],
                        snapshot.data!.docs[index]["discountValue"],
                        snapshot.data!.docs[index]["shippingValue"],
                        snapshot.data!.docs[index]["totalPayment"],
                        snapshot.data!.docs[index]["totalQuantity"],
                        snapshot.data!.docs[index]["numOfProducts"],
                        snapshot.data!.docs[index]["address"],
                        snapshot.data!.docs[index]["latitude"],
                        snapshot.data!.docs[index]["longitude"],
                        snapshot.data!.docs[index]["userName"],
                        snapshot.data!.docs[index]["phone"],
                        snapshot.data!.docs[index]["time"],
                        snapshot.data!.docs[index]["status"]);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: ProductContainerManage(
                        order: order,
                        products: products,
                      ),
                    );
                  })
              : Center(child: not_orders);
        });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelColor: kPrimaryColor,
            unselectedLabelColor: kTextLightColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
            overlayColor:
                MaterialStateColor.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              if (states.contains(MaterialState.focused)) {
                return Colors.transparent;
              } else if (states.contains(MaterialState.hovered)) {
                return Colors.transparent;
              }
              return Colors.transparent;
            }),
            indicatorWeight: 3,
            indicatorColor: kPrimaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            physics: const BouncingScrollPhysics(),
            enableFeedback: true,
            tabs: tabs,
          ),
          leading: IconButton(
            icon: const BackButtonIcon(),
            color: kPrimaryColor,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeAdmin()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
          title: const Text(
            'Order management',
            style: TextStyle(
              fontFamily: "Laila",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          // Uncomment the line below and remove DefaultTabController if you want to use a custom TabController
          // controller: _tabController,
          children: [
            PendingOrderList(productProvider.products),
            PreparingOrderList(productProvider.products),
            ShippingOrderList(productProvider.products),
            ReceivedOrderList(productProvider.products),
            RatedOrderList(productProvider.products),
            CompletedOrderList(productProvider.products),
            CanceledOrderList(productProvider.products),
          ],
        ),
      ),
    );
  }
}
