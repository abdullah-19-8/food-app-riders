import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_riders_app/models/global.dart';

import '../assistant_methods/assistant_methods.dart';
import '../widgets/order_cart.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_app_bar.dart';

class HistoryScreen extends StatefulWidget {

  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const SimpleAppBar(title: "History"),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("riderUID", isEqualTo: sharedPreferences!.getString("uid"))
              .where("status", isEqualTo: "ended")
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
