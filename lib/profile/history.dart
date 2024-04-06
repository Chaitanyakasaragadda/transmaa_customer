import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  User? driver;
  late Map<int, bool> isExpandedMap;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    fetchDriverData();
    isExpandedMap = {};
    _scrollController = ScrollController();
  }

  Future<void> fetchDriverData() async {
    // Get the current user
    User? driver = FirebaseAuth.instance.currentUser;

    if (driver != null) {
      setState(() {
        this.driver = driver;
      });
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DriversAcceptedOrders')
          .where('driverPhoneNumber', isEqualTo: driver.phoneNumber)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot driverDoc = querySnapshot.docs.first;

        Map<String, dynamic>? driverData =
        driverDoc.data() as Map<String, dynamic>?;

        if (driverData != null) {
          print('Driver data: $driverData');
        } else {
          print('Driver data is null.');
        }
      } else {
        print('No driver document found for the current user.');
      }
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Delivered':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  void scrollToIndex(int index) {
    _scrollController.animateTo(
      index * 200.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text("History"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('/DriversAcceptedOrders')
                        .where('driverPhoneNumber',
                        isEqualTo:
                        FirebaseAuth.instance.currentUser!.phoneNumber)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.hasData) {
                        List<DocumentSnapshot> docs = snapshot.data!.docs;
                        return Column(
                          children: docs.asMap().entries.map((entry) {
                            int index = entry.key;
                            DocumentSnapshot doc = entry.value;
                            bool isExpanded = isExpandedMap[index] ?? false;
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'From Location:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${doc['fromLocation'] ?? 'Not provided'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'To Location:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${doc['toLocation'] ?? 'Not provided'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 10),
                                    if (isExpanded)
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Date:',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '${doc['selectedDate'] ?? 'Not provided'}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Time:',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '${doc['selectedTime'] ?? 'Not provided'}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Goods Type:',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '${doc['selectedGoodsType'] ?? 'Not provided'}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Truck:',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '${doc['selectedTruck'] ?? 'Not provided'}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(),
                                    Text(
                                      'Status:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: getStatusColor(
                                                doc['status'] ??
                                                    'Not provided'),
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${doc['status'] ?? 'Not provided'}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              isExpandedMap[index] =
                                              !(isExpandedMap[index] ??
                                                  false);
                                              if (isExpandedMap[index]!) {
                                                scrollToIndex(index);
                                              }
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                isExpandedMap[index] ?? false
                                                    ? "View Less"
                                                    : "View More",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: isExpandedMap[index] ??
                                                      false
                                                      ? Colors.red
                                                      : Colors.blue,
                                                  // decoration: TextDecoration.underline,
                                                ),
                                              ),
                                              Icon(
                                                isExpandedMap[index] ?? false
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons.keyboard_arrow_down,
                                                color: isExpandedMap[index] ??
                                                    false
                                                    ? Colors.red
                                                    : Colors.blue,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }

                      return Text('No historical data available');
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


