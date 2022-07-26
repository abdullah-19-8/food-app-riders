import 'package:flutter/material.dart';

class ShipmentScreen extends StatefulWidget {
  final String? purchaserId;
  final String? purchaserAddress;
  final double? purchaserLat;
  final double? purchaserLng;
  final String? sellerId;
  final String? getOrderId;
  const ShipmentScreen({Key? key, this.purchaserId, this.purchaserAddress, this.purchaserLat, this.purchaserLng, this.sellerId, this.getOrderId}) : super(key: key);

  @override
  State<ShipmentScreen> createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<ShipmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
