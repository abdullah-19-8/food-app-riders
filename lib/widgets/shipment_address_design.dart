import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_riders_app/screens/parcel_picking_screen.dart';
import '../assistant_methods/get_current_location.dart';
import '../models/global.dart';
import '../screens/splash_screen.dart';

import '../models/address.dart';
import '../widgets/my_padding.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;
  final String? orderId;
  final String? sellerId;
  final String? orderByUser;


  const ShipmentAddressDesign({Key? key, this.model, this.orderStatus, this.orderId, this.sellerId, this.orderByUser})
      : super(key: key);

  confirmParcelShipment(BuildContext context, String getOrderId,
      String sellerId, String purchaserId) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "riderUID": sharedPreferences!.getString("uid"),
      "riderName": sharedPreferences!.getString("name"),
      "status": "picking",
      "lat": position!.latitude,
      "lng": position!.longitude,
      "address": completeAddress,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => ParcelPickingScreen(
          purchaserId: purchaserId,
          purchaserAddress: model!.fullAddress,
          purchaserLat: model!.lat,
          purchaserLng: model!.lng,
          sellerId: sellerId,
          getOrderId: getOrderId
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Shipping Details:',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.name!),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.phoneNumber!),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),
        orderStatus == "ended"
            ? Container()
            : MyPadding(
                text: "Confirm - To Deliver this Parcel",
                onTab: () {
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();
                  
                  confirmParcelShipment(context, orderId!, sellerId!, orderByUser!);
                },
              ),
        MyPadding(
          text: "Go Back",
          onTab: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const SplashScreen()));
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
