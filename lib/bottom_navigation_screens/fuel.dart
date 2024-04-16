import 'package:flutter/material.dart';

class Fuel extends StatefulWidget {
  const Fuel({super.key});

  @override
  State<Fuel> createState() => _FuelState();
}

class _FuelState extends State<Fuel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Text(' Fuel coming soon',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
      ),
    );
  }
}
