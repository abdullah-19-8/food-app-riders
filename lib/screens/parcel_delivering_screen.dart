import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_riders_app/screens/splash_screen.dart';

import '../assistant_methods/get_current_location.dart';
import '../maps/maps_utils.dart';
import '../models/global.dart';
import '../widgets/my_padding.dart';

// ignore: must_be_immutable
class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerId;
  String? getOrderId;

  ParcelDeliveringScreen({
    Key? key,
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.sellerId,
    this.getOrderId,
  }) : super(key: key);

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {
  String orderTotalAmount = "";
  confirmOrderHasBeenDelivered(getOrderId, sellerId, purchaserId,
      purchaserAddress, purchaserLat, purchaserLng) {
    String riderNewTotalEarningAmount = (double.parse(previousRiderEarnings) +
            double.parse(perParcelDeliveryAmount))
        .toString();
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "ended",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "earning": perParcelDeliveryAmount,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("riders")
          .doc(sharedPreferences!.getString("uid"))
          .update({
        "earning": riderNewTotalEarningAmount,
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(widget.sellerId)
          .update({
        "earning": (double.parse(orderTotalAmount) +
                (double.parse(previousSellerEarnings)))
            .toString(),
      }).then((value) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(purchaserId)
            .collection("orders")
            .doc(getOrderId)
            .update({
          "status": "ended",
          "riderUID": sharedPreferences!.getString("uid"),
        });
      });
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const SplashScreen()));
  }

  getOrderTotalAmount() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.getOrderId)
        .get()
        .then((snap) {
      orderTotalAmount = snap.data()!["totalAmount"].toString();
      widget.sellerId = snap.data()!["sellerUID"].toString();
    }).then((value) {
      getSellerData();
    });
  }

  getSellerData() {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((snap) {
      previousSellerEarnings = snap.data()!["earnings"].toString();
    });
  }

  @override
  void initState() {
    super.initState();

    UserLocation().getCurrentLocation();
    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/confirm2.png",
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              MapUtils.lunchMapFromSourceToDestination(
                position!.latitude,
                position!.longitude,
                widget.purchaserLat,
                widget.purchaserLng,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/restaurant.png",
                  width: 50,
                ),
                const SizedBox(height: 7),
                Column(
                  children: const [
                    SizedBox(height: 12),
                    Text(
                      "Show Delivery Drop-off Location",
                      style: TextStyle(
                        fontFamily: "Signatra",
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          MyPadding(
            text: "Order has been Delivered - Confirmed",
            onTab: () {
              UserLocation().getCurrentLocation();
              confirmOrderHasBeenDelivered(
                widget.getOrderId,
                widget.sellerId,
                widget.purchaserId,
                widget.purchaserAddress,
                widget.purchaserLat,
                widget.purchaserLng,
              );
            },
          ),
        ],
      ),
    );
  }
}
