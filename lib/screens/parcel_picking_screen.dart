import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_riders_app/assistant_methods/get_current_location.dart';
import 'package:foodpanda_riders_app/maps/maps_utils.dart';
import 'package:foodpanda_riders_app/models/global.dart';
import 'package:foodpanda_riders_app/screens/parcel_delivering_screen.dart';
import 'package:foodpanda_riders_app/widgets/my_padding.dart';

class ParcelPickingScreen extends StatefulWidget {
  final String? purchaserId;
  final String? purchaserAddress;
  final double? purchaserLat;
  final double? purchaserLng;
  final String? sellerId;
  final String? getOrderId;

  const ParcelPickingScreen(
      {Key? key,
      this.purchaserId,
      this.purchaserAddress,
      this.purchaserLat,
      this.purchaserLng,
      this.sellerId,
      this.getOrderId})
      : super(key: key);

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {
  double? sellerLat, sellerLng;

  getSellerData() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((DocumentSnapshot) {
      sellerLat = DocumentSnapshot.data()!["lat"];
      sellerLng = DocumentSnapshot.data()!["lng"];
    });
  }

  @override
  void initState() {
    super.initState();
    getSellerData();
  }

  confirmOrderHasBeenPicked(getOrderId, sellerId, purchaserId, purchaserAddress,
      purchaserLat, purchaserLng) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "delivering",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => ParcelDeliveringScreen(
                  purchaserId: purchaserId,
                  purchaserAddress: purchaserAddress,
                  purchaserLat: purchaserLat,
                  purchaserLng: purchaserLng,
                  sellerId: sellerId,
                  getOrderId: getOrderId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/confirm1.png",
            width: 350,
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              MapUtils.lunchMapFromSourceToDestination(
                position!.latitude,
                position!.longitude,
                sellerLat,
                sellerLng,
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
                      "Show Caffe/Restaurant Location",
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
            text: "Order has been Picked - Confirmed",
            onTab: () {
              UserLocation().getCurrentLocation();
              confirmOrderHasBeenPicked(
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
