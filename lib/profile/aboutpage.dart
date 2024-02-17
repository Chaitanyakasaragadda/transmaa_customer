import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leadingWidth: 150,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo_removebg.png',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      body: Center(
        child:
        Column(
          children: [
            Text('Transmaa provides a wide range of services, such as load management, upfront pricing, on-time delivery, insurance and guarantee, and support for global logistics to provide smooth transportation solutions everywhere.'),
            Text('Load', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.deepOrange),),
            Text('Transmaa effective load management, which offers a range of services from logistics planning to real-time tracking, guarantees safe and timely delivery.'),
            Text('Vehicle Buy & Sell', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.deepOrange),),
            Text('Transmaa simplifies ethical transactions by promoting transparent connections in a productive marketplace for buying and selling.'),
            Text('Insurance', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.deepOrange),),
            Text('With our all-inclusive insurance, which covers every stage of transportation and successfully reduces risks for asset protection, you can feel safe.'),
            Text('Finance', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.deepOrange),),
            Text('Transmaa drives transportation industry growth by providing specialized financial services ranging from working capital to fleet expansion support.'),
            Text('Fuel', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.deepOrange),),
            Text('Transmaa new fuel Services provide ease and accessibility by cooperating with all fuel pumps across India for smooth fueling experiences.'),

          ],

        ),
      ),
    );
  }
}

