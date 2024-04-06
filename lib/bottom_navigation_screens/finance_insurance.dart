import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FinanceAndInsurance extends StatefulWidget {
  final String documentId;

  FinanceAndInsurance({required this.documentId});

  @override
  _FinanceAndInsuranceState createState() => _FinanceAndInsuranceState();
}

class _FinanceAndInsuranceState extends State<FinanceAndInsurance> {
  String selectedButton = 'insurance';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController rcNumberController = TextEditingController();
  bool showFields = true;

  Future<void> submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        String collectionName =
        selectedButton == 'finance' ? 'Finance' : 'Insurance';

        await FirebaseFirestore.instance.collection(collectionName).add({
          'name': nameController.text,
          'phoneNumber': phoneNumberController.text,
          'vehicleType': vehicleTypeController.text,
          'rcNumber': rcNumberController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data submitted successfully!'),
          ),
        );

        nameController.clear();
        phoneNumberController.clear();
        vehicleTypeController.clear();
        rcNumberController.clear();
      } catch (error) {
        print('Error submitting data to Firestore: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit data. Please try again later.'),
          ),
        );
      }
    }
  }

  void showFieldsWithDelay(String selected) async {
    setState(() {
      showFields = false;
    });
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      selectedButton = selected;
      showFields = true;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              SizedBox(height: 30),
          Center(
            child: Column(
              children: [
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
              ],
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    showFieldsWithDelay('finance');
                  },
                  child: Text(
                    'Finance',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: selectedButton == 'finance'
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 180,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    showFieldsWithDelay('insurance');
                  },
                  child: Text(
                    'Insurance',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: selectedButton == 'insurance'
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (showFields)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTextField('Name', nameController, 'alphabets'),
                      SizedBox(height: 7),
                      buildTextField('Phone Number', phoneNumberController, 'phone'),
                      SizedBox(height: 7),
                      buildTextField('Type of Vehicle', vehicleTypeController, 'both'),
                      SizedBox(height: 7),
                      buildTextField('RC Number', rcNumberController, 'both'),
                      SizedBox(height: 25),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: submitData,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
              ],
          ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, String inputType) {
    RegExp alphabetsRegex = RegExp(r'^[a-zA-Z]+$');
    RegExp numbersRegex = RegExp(r'^[0-9]+$');

    InputValidation inputValidation = InputValidation(inputFormatter: [], validator: null);

    if (inputType == 'phone') {
      inputValidation = InputValidation(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Phone number is required';
          } else if (!numbersRegex.hasMatch(value)) {
            return 'Enter only numeric characters';
          }
          return null;
        },
        inputFormatter: [FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)],
      );
    } else if (inputType == 'alphabets') {
      inputValidation = InputValidation(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Field is required';
          } else if (!alphabetsRegex.hasMatch(value)) {
            return 'Enter only alphabetic characters';
          }
          return null;
        },
        inputFormatter: [FilteringTextInputFormatter.allow(alphabetsRegex)],
      );
    } else if (inputType == 'both') {
      inputValidation = InputValidation(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Field is required';
          }
          return null;
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              label,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              inputFormatters: inputValidation.inputFormatter,
              validator: inputValidation.validator,
            ),
          ),
        ],
      ),
    );
  }

}

class InputValidation {
  final List<TextInputFormatter>? inputFormatter;
  final String? Function(String?)? validator;

  InputValidation({this.inputFormatter, this.validator});
}