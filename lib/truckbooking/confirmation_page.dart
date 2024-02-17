import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'confirmbooking.dart';
import 'truck.dart';

class ConfirmationPage extends StatelessWidget {
  final String selectedGoodsType;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final Truck selectedTruck;
  final String selectedImageName;
  final String enteredName;
  final String phoneNumber;
  final String fromLocation; // Added parameter for from location
  final String toLocation; // Added parameter for to location

  // Define a custom color for the outlined boxes
  final Color outlinedBoxColor = Colors.orange;
  final Color containerOutlineColor = Colors.white;

  ConfirmationPage({
    required this.selectedGoodsType,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedTruck,
    required this.selectedImageName,
    required this.enteredName,
    required this.phoneNumber,
    required this.fromLocation,
    required this.toLocation,
  });

  void _confirmPickup(BuildContext context) async {
    try {
      // Construct the data to be stored in Firebase
      Map<String, dynamic> pickupData = {
        'selectedGoodsType': selectedGoodsType,
        'selectedDate': selectedDate,
        'selectedTime': selectedTime.toString(),
        'selectedTruck': {
          'name': selectedTruck?.name ?? '',
          'price': selectedTruck?.price ?? 0,
          'weightCapacity': selectedTruck?.weightCapacity ?? 0,
        },
        'enteredName': enteredName, // Include entered name
        'phoneNumber': phoneNumber, // Include phone number
        'fromLocation': fromLocation ?? '',
        'toLocation': toLocation ?? '',
        // Add any other relevant data fields here
      };

      // Store the data in Firebase Firestore
      await FirebaseFirestore.instance
          .collection('pickup_requests')
          .add(pickupData);
      print('Data stored in Firebase successfully');

      // Navigate to the next screen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => confirm()));
    } catch (e) {
      print('Error storing data in Firebase: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('back'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm Details',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Divider(color: outlinedBoxColor),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: containerOutlineColor),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors
                    .transparent, // Transparent color for container to show the outlined border
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image on the left
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Image.asset(
                            selectedImageName,
                            width: 120.0, // Set the desired width
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      // Horizontal line between image and details
                      Container(
                        height: 80.0,
                        width: 1.0,
                        color: outlinedBoxColor, // Set the line color to orange
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      // Selected truck details in a column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${selectedTruck.name}',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '${selectedTruck.weightCapacity} Tons',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '\$${selectedTruck.price}',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(color: outlinedBoxColor),
                  // Divider below the box
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: outlinedBoxColor),
                                borderRadius: BorderRadius.circular(5.0),
                                color: outlinedBoxColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: outlinedBoxColor),
                                borderRadius: BorderRadius.circular(5.0),
                                color: outlinedBoxColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.black,
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      selectedTime.format(context),
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(color: outlinedBoxColor),
                  // Divider below date and time
                  SizedBox(height: 8.0),
                  Text(
                    'From Location:',
                    style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  buildBoxTextFieldWithIcon(fromLocation, Icons.location_on),
                  SizedBox(height: 16.0),
                  Text(
                    'To Location:',
                    style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  buildBoxTextFieldWithIcon(toLocation, Icons.location_on),
                  Divider(color: outlinedBoxColor),
                  // Divider below "to" location
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _confirmPickup(context),
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
          ),
          child: Text(
            'Confirm Pickup',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildBoxTextFieldWithIcon(String labelText, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: outlinedBoxColor),
        borderRadius: BorderRadius.circular(5.0),
        color: outlinedBoxColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Colors.black,
              size: 20.0,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  labelText,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
