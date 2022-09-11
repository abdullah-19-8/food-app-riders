import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../assistant_methods/assistant_methods.dart';
import '../models/global.dart';
import '../widgets/order_cart.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_app_bar.dart';

class ParcelInProgressScreen extends StatefulWidget {
  const ParcelInProgressScreen({Key? key}) : super(key: key);

  @override
  State<ParcelInProgressScreen> createState() => _ParcelInProgressScreenState();
}

class _ParcelInProgressScreenState extends State<ParcelInProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const SimpleAppBar(title: "Order In Progress"),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("riderUID", isEqualTo: sharedPreferences!.getString("uid"))
              .where("status", isEqualTo: "picking")
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (c, index) {
                  return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("items")
                          .where("itemId",
                          whereIn: separateOrderItemIDs((snapshot
                              .data!.docs[index]
                              .data()!
                          as Map<String, dynamic>)["productsIDs"]))
                          .orderBy("publishedDate", descending: true)
                          .get(),
                      builder: (c, snap) {
                        return snap.hasData
                            ? OrderCart(
                          itemCount: snap.data!.docs.length,
                          data: snap.data!.docs,
                          orderID: snapshot.data!.docs[index].id,
                          separateQuantitiesList:
                          separateOrderItemQuantities(
                              (snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>)[
                              "productsIDs"]),
                        )
                            : Center(
                          child: circularProgress(),
                        );
                      });
                })
                : Center(
              child: circularProgress(),
            );
          },
        ),
      ),
    );
  }
}
