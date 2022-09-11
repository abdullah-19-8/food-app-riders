import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_riders_app/screens/earnings_screen.dart';
import 'package:foodpanda_riders_app/screens/history_screen.dart';
import 'package:foodpanda_riders_app/screens/new_orders_screen.dart';
import 'package:foodpanda_riders_app/screens/not_yes_delivered_screen.dart';
import 'package:foodpanda_riders_app/screens/parcel_in_progress_screen.dart';

import '../assistant_methods/assistant_methods.dart';
import '../assistant_methods/get_current_location.dart';
import '../models/global.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: (index == 0 || index == 3 || index == 4)
            ? myBoxDecoration(Colors.amber, Colors.cyan)
            : myBoxDecoration(Colors.redAccent, Colors.amber),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              // New Order
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const NewOrdersScreen(),
                ),
              );
            }
            if (index == 1) {
              // New Available Orders
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const ParcelInProgressScreen(),
                ),
              );
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const NotYetDeliveredScreen(),
                ),
              );
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const HistoryScreen(),
                ),
              );
            }
            if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const EarningsScreen(),
                ),
              );
            }
            if (index == 5) {
              // Logout
              firebaseAuth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const AuthScreen(),
                  ),
                );
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getParcelDeliveryAmount();
    getRiderPreviousEarnings();
  }

  getRiderPreviousEarnings(){
    FirebaseFirestore.instance.collection("riders").doc(sharedPreferences!.getString("uid")).get().then((snap){
      previousRiderEarnings = snap.data()!["earning"].toString();
    } );
  }

  getParcelDeliveryAmount(){
    FirebaseFirestore.instance.collection("perDelivery").doc("perDeliveryId").get().then((snap) {
      perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Welcome ${sharedPreferences!.getString('name')}",
          style: const TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontFamily: "Signatra",
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("New Available Orders", Icons.assignment, 0),
            makeDashboardItem("Parcels in Progress", Icons.airport_shuttle, 1),
            makeDashboardItem("Not Yet Delivered", Icons.location_history, 2),
            makeDashboardItem("History", Icons.done_all, 3),
            makeDashboardItem("Total Earnings", Icons.monetization_on, 4),
            makeDashboardItem("Logout", Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
