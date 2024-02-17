import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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

  bool showTextFields = false; // Track whether to show text fields or not
  Color sellButtonColor = Colors.orangeAccent; // Sell button color
  Color byeButtonColor = Colors.orangeAccent; // Bye button color
  bool isDataComplete = false; // Track whether all text fields are filled

  double textFieldFontSize = 14; // Initial font size of text fields

  List<Uint8List?> _images = List.filled(4, null); // Maintain a list to store four images
  Color saveButtonColor = Colors.red; // Save button color

  Future<String> saveUserDataToFirestore() async {
    final CollectionReference users = FirebaseFirestore.instance.collection('Sell_Vechile_infromation');

    // Upload images to Firebase Storage
    List<String> imageUrls = await uploadImagesToStorage();

    // Add user data to Firestore
    await users.add({
      'Name': nameController.text,
      'Phone Number': phoneNumberController.text,
      'Vehicle No': vehicleNoController.text,
      'Vehicle Model': vehicleModelController.text,
      'R C No': rcNoController.text,
      'ImageURLs': imageUrls, // Store image download URLs in Firestore
    });

    // Return the image URLs
    return imageUrls.join(", ");
  }

  Future<List<String>> uploadImagesToStorage() async {
    List<String> imageUrls = [];
    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        // Create a reference to the Firebase Storage path
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('images')
            .child('image_${DateTime.now().millisecondsSinceEpoch}_$i.png');

        // Upload the file to Firebase Storage
        await ref.putData(_images[i]!);

        // Get the download URL
        String downloadURL = await ref.getDownloadURL();
        imageUrls.add(downloadURL);
      }
    }
    return imageUrls;
  }

  // Function to disable image selection after upload
  void disableImageSelection(int index) {
    setState(() {
      _images[index] = Uint8List(0); // Set image to an empty Uint8List
    });
  }

  bool areFieldsValid() {
    return nameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        vehicleNoController.text.isNotEmpty &&
        vehicleModelController.text.isNotEmpty &&
        rcNoController.text.isNotEmpty &&
        _images.any((image) => image != null); // At least one image is selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5,),
              Text(

                'Commercial Vehicles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        showTextFields = false; // Hide text fields
                        byeButtonColor = Colors.green; // Change Bye button color
                        sellButtonColor = Colors.orangeAccent; // Reset Sell button color
                        textFieldFontSize = 20; // Reset font size to default
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
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

                  SizedBox(width: 20,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showTextFields = true; // Show text fields
                        sellButtonColor = Colors.green; // Change Sell button color
                        byeButtonColor = Colors.orangeAccent; // Reset Bye button color
                        textFieldFontSize = 12; // Update font size for smaller text fields
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
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
              SizedBox(height: 10,),
              if (showTextFields) ...[
                Padding(padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: nameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')), // Allow only numbers
                    // Limit length to 10 characters
                  ],
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Reduce padding
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      isDataComplete = areFieldsValid();
                    });
                  },
                ),),

                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child:  TextFormField(
                  controller: phoneNumberController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                    // Limit length to 10 characters
                  ],
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Reduce padding
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone Number is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      isDataComplete = areFieldsValid();
                    });
                  },
                ),),

                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                  child:
                TextFormField(
                  controller: vehicleNoController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')), // Allow only numbers
                     // Limit length to 10 characters
                  ],
                  decoration: InputDecoration(
                    labelText: 'Vehicle No',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Reduce padding
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vehicle No is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      isDataComplete = areFieldsValid();
                    });
                  },
                ),),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.all(10),
                child:
                TextFormField(
                  controller: vehicleModelController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')), // Allow only numbers
                    // Limit length to 10 characters
                  ],
                  decoration: InputDecoration(
                    labelText: 'Vehicle Model',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Reduce padding
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vehicle Model is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      isDataComplete = areFieldsValid();
                    });
                  },
                ),),
                SizedBox(height: 10),
                 Padding(padding: EdgeInsets.all(10),
                 child:TextFormField(
                  controller: rcNoController,
                   inputFormatters: [
                     FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')), // Allow only numbers
                     // Limit length to 10 characters
                   ],
                  decoration: InputDecoration(
                    labelText: 'RC No',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Reduce padding
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'RC No is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      isDataComplete = areFieldsValid();
                    });
                  },
                ),
    ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Text('Upload Images', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
                buildImagePick(), // Add ImagePick widget here
              ],
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: isDataComplete
                    ? () async {
                  // Save user data to Firestore and get the image URLs
                  String imageURLs = await saveUserDataToFirestore();
                  // Change button color to green
                  setState(() {
                    saveButtonColor = Colors.green;
                  });
                  // Disable image selection after upload
                  for (int i = 0; i < _images.length; i++) {
                    if (_images[i] != null) {
                      disableImageSelection(i);
                    }
                  }
                  // Navigate to the next screen

                }
                    : null, // Disable button if data is incomplete
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    // Return the button color based on its state
                    if (states.contains(MaterialState.disabled)) {
                      return saveButtonColor.withOpacity(0.5); // Use opacity for disabled state
                    }
                    return saveButtonColor;
                  }),
                ),
                child: Text('Save Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImagePick() {
    return Row(
      children: List.generate(4, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImagePick(
              onImagePicked: (Uint8List? image) {
                setState(() {
                  _images[index] = image;
                });
              },
              width: 140, // Specify the width
              height: 140, // Specify the height
            ),
          ),
        );
      }),
    );
  }
}

class ImagePick extends StatefulWidget {
  final Function(Uint8List?) onImagePicked;
  final double width;
  final double height;

  ImagePick({
    required this.onImagePicked,
    required this.width,
    required this.height,
  });

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  Uint8List? _image;

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
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Images Selected');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'Front side',
                  style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5,),
              Stack(
                children: [
                  Container(
                    width: 100, // Set the width of the container
                    height: 100, // Set the height of the container
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),// Use rectangle shape
                      //border: Border.all(color: Colors.black), // Add border
                    ),
                    child: _image != null
                        ? Image.memory(
                      _image!,
                      fit: BoxFit.cover,
                      width: double.infinity, // Make the image fill the container width
                      height: double.infinity, // Make the image fill the container height
                    )
                        : Container(), // Replace Image.network with an empty Container
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                    bottom: 30, // Adjust position
                    left: 30, // Adjust position
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}