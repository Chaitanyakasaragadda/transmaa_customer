import 'dart:typed_data';
import 'dart:typed_data';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class BuyAndSell extends StatefulWidget {
  @override
  _BuyAndSellState createState() => _BuyAndSellState();
}

class _BuyAndSellState extends State<BuyAndSell> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController vehicleNoController = TextEditingController();
  final TextEditingController vehicleModelController = TextEditingController();
  final TextEditingController rcNoController = TextEditingController();
  final TextEditingController yearsOfVehicleController =
  TextEditingController();

  bool showTextFields = true; // Changed initial state to false
  Color sellButtonColor = Colors.green.shade900;
  Color byeButtonColor = Colors.orangeAccent;
  bool isDataComplete = false;

  double textFieldFontSize = 14;

  List<Uint8List?> _images = List.filled(4, null);
  Color saveButtonColor = Colors.red;

  Future<String> saveUserDataToFirestore() async {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('Sell_Vehicle_information');

    List<String> imageUrls = await uploadImagesToStorage();

    await users.add({
      'Name': nameController.text,
      'Phone Number': phoneNumberController.text,
      'Vehicle No': vehicleNoController.text,
      'Vehicle Model': vehicleModelController.text,
      'R C No': rcNoController.text,
      'Years of Vehicle': yearsOfVehicleController.text,
      'ImageURLs': imageUrls,
    });

    // Reset the _images list after storing data
    setState(() {
      _images = List.filled(4, null);
    });

    // Disable image selection in the ImagePick widgets
    for (int i = 0; i < _imagePickKeys.length; i++) {
      _imagePickKeys[i].currentState?.clearImage(i);
    }

    return imageUrls.join(", ");
  }

  Future<List<String>> uploadImagesToStorage() async {
    List<String> imageUrls = [];
    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images')
            .child('image_${DateTime.now().millisecondsSinceEpoch}_$i.png');

        await ref.putData(_images[i]!);

        String downloadURL = await ref.getDownloadURL();
        imageUrls.add(downloadURL);
      }
    }
    return imageUrls;
  }

  void disableImageSelection(int index) {
    setState(() {
      _images[index] = Uint8List(0);
    });
  }

  bool areFieldsValid() {
    return nameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        vehicleNoController.text.isNotEmpty &&
        vehicleModelController.text.isNotEmpty &&
        rcNoController.text.isNotEmpty &&
        yearsOfVehicleController.text.isNotEmpty &&
        _images.any((image) => image != null);
  }

  late CollectionReference _buyCollection;
  List<Map<String, dynamic>> _buyData = [];

  @override
  void initState() {
    super.initState();
    _buyCollection = FirebaseFirestore.instance.collection('Buycollection');
  }

  Future<void> fetchAndDisplayData() async {
    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await _buyCollection.get();

      // Update the list to store fetched data
      List<Map<String, dynamic>> fetchedData = [];
      querySnapshot.docs.forEach((doc) {
        fetchedData.add({
          'company': doc['Company'],
          'vehicleModel': doc['Vehicle Model'],
          'yearsOfVehicle': doc['Year'],
          'imageURLs': List<String>.from(doc['ImageURLs']),
        });
      });

      // Update state to trigger UI update
      setState(() {
        _buyData = fetchedData;
      });
    } catch (e) {
      print('Error fetching and displaying data: $e');
    }
  }

  Widget _buildBuyDataItem(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 150,
                width: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data['imageURLs'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        data['imageURLs'][index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                children: [
                  Text(
                    " ${data['company']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14),
                  ),
                  Text(
                    'Vehicle Model:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${data['vehicleModel']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14),
                  ),
                  Text(
                    'Years of Vehicle:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    " ${data['yearsOfVehicle']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _showInterestForm(context, data);
                      },
                      child: Text('Interested to buy'))
                ],
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1,
          color: Colors.white,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Commercial Vehicles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                width: 250,
                child: Divider(
                  thickness: 2,
                  color: Colors.brown,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        showTextFields = false;
                        byeButtonColor = Colors.green.shade900;
                        sellButtonColor = Colors.orangeAccent;
                        textFieldFontSize = 20;
                      });
                      fetchAndDisplayData();
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                      decoration: BoxDecoration(
                        color: byeButtonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'BUY',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showTextFields = true;
                        sellButtonColor = Colors.green.shade900;
                        byeButtonColor = Colors.orangeAccent;
                        textFieldFontSize = 12;
                      });
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                      decoration: BoxDecoration(
                        color: sellButtonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SELL',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (showTextFields) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  width: 375,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          child: TextFormField(
                            controller: nameController,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          child: TextFormField(
                            controller: phoneNumberController,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),],
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          child: TextFormField(
                            controller: vehicleNoController,
                            onChanged: (value) {
                              setState(() {
                                // Apply formatting rules
                                String formattedText = '';
                                for (int i = 0; i < value.length; i++) {
                                  if (i < 2) {
                                    // Only allow alphabets for the first five characters
                                    formattedText += value[i].replaceAll(RegExp(r'[^A-Za-z]'), '').toUpperCase();
                                  } else if (i >= 2 && i < 4) {
                                    // Only allow numbers for the next four characters
                                    formattedText += value[i].replaceAll(RegExp(r'[^0-9]'), '');
                                  } else {
                                    // Allow alphabets and numbers for the remaining characters
                                    formattedText += value[i];
                                  }
                                }
                                vehicleNoController.value = vehicleNoController.value.copyWith(
                                  text: formattedText,
                                  selection: TextSelection.collapsed(offset: formattedText.length),
                                  composing: TextRange.empty,
                                ); // Clear the error message when the user starts typing
                              });
                            },
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Vehicle No',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          child: TextFormField(
                            controller: vehicleModelController,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Vehicle Model',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          child: TextFormField(
                            controller: rcNoController,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                            ],
                            decoration: InputDecoration(
                              labelText: 'RC No',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          child: TextFormField(
                            controller: yearsOfVehicleController,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),],

                            decoration: InputDecoration(
                              labelText: 'Year of Vehicle',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Text('Upload Images',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                buildImagePick(),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Check if all fields are valid and all images are uploaded
                    if (areFieldsValid() && allImagesUploaded()) {
                      try {
                        String ImageURLs = await saveUserDataToFirestore();
                        // Inside onPressed callback of ElevatedButton
// Reset text field controllers
                        nameController.clear();
                        phoneNumberController.clear();
                        vehicleNoController.clear();
                        vehicleModelController.clear();
                        rcNoController.clear();
                        yearsOfVehicleController.clear();

// Reset images list
                        setState(() {
                          _images = List.filled(4, null);
                        });

// Clear images from UI
                        _imagePickKeys.asMap().forEach((index, key) {
                          key.currentState?.clearImage(index);
                        });

                        // Show SnackBar for success
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Data stored successfully!'),
                            duration: Duration(seconds: 5), // Optional duration
                          ),
                        );
                      } catch (e) {
                        print('Error storing data: $e');

                        // Show SnackBar for failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text('Failed to store data. Please try again.'),
                            duration: Duration(seconds: 5), // Optional duration
                          ),
                        );
                      }
                    } else {
                      // Show SnackBar for missing images
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Please fill all text fields and upload all images.'),
                          duration: Duration(seconds: 5), // Optional duration
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return saveButtonColor.withOpacity(0.5);
                        }
                        return saveButtonColor;
                      },
                    ),
                  ),
                  child: Text(
                    'Save Data',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
              if (!showTextFields) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 375,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _buyData.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = _buyData[index];
                          return _buildBuyDataItem(data);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<GlobalKey<_ImagePickState>> _imagePickKeys =
  List.generate(4, (index) => GlobalKey<_ImagePickState>());

  Widget buildImagePick() {
    return Row(
      children: List.generate(4, (index) {
        String containerName;
        switch (index) {
          case 0:
            containerName = 'Front side';
            break;
          case 1:
            containerName = 'Back side';
            break;
          case 2:
            containerName = 'Right side';
            break;
          case 3:
            containerName = 'Left side';
            break;
          default:
            containerName = '';
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImagePick(
              key: _imagePickKeys[index],
              onImagePicked: (Uint8List? image) {
                setState(() {
                  _images[index] = image;
                });
              },
              width: 140,
              height: 140,
              containerName: containerName,
            ),
          ),
        );
      }),
    );
  }

  bool allImagesUploaded() {
    // Check if all images are uploaded
    for (int i = 0; i < _images.length; i++) {
      if (_images[i] == null) {
        return false;
      }
    }
    return true;
  }
}

void _showInterestForm(BuildContext context, Map<String, dynamic> data) {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  // Retrieve current user details
  User? user = FirebaseAuth.instance.currentUser;
  String? currentUserDisplayName = user?.displayName;
  String? currentUserPhoneNumber = user?.phoneNumber;

// Pre-fill the form with current user details if available
  nameController.text = currentUserDisplayName ?? '';
  phoneNumberController.text = currentUserPhoneNumber ?? '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Interested to Buy"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _addToInterestedCollection(
                data,
                nameController.text,
                phoneNumberController.text,
              );
              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}

Future<void> _addToInterestedCollection(
    Map<String, dynamic> data, String name, String phoneNumber) async {
  try {
    await FirebaseFirestore.instance.collection('Interestedtobuy').add({
      'Company': data['company'],
      'VehicleModel': data['vehicleModel'],
      'Year': data['yearsOfVehicle'],
      'ImageURLs': data['imageURLs'],
      'CustomerName': name,
      'CustomerPhoneNumber': phoneNumber,
      'UserID': FirebaseAuth.instance.currentUser?.uid,
      // Optionally store user ID
    });
  } catch (e) {
    print('Error adding to InterestedCollection: $e');
  }
}
class ImagePick extends StatefulWidget {
  final Function(Uint8List?) onImagePicked;
  final double width;
  final double height;
  final String containerName; // Added container name property

  ImagePick({
    required this.onImagePicked,
    required this.width,
    required this.height,
    required this.containerName, // Added container name parameter
    required GlobalKey<_ImagePickState> key,
  });

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  Uint8List? _image;

  void clearImage(int i) {
    setState(() {
      _image = null;
    });
    widget.onImagePicked(null);
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
      widget.onImagePicked(_image);
    }
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    print('No Images Selected');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clearImage( widget.onImagePicked(4 as Uint8List?));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      widget.containerName, // Use container name here
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.brown,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _image != null
                              ? Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                              : Container(),
                        ),
                        Positioned(
                          child: IconButton(
                            onPressed: selectImage,
                            icon: Icon(Icons.add_a_photo),
                          ),
                          bottom: 30,
                          left: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
