import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class FinanceAndInsurance extends StatefulWidget {
  @override
  _FinanceAndInsuranceState createState() => _FinanceAndInsuranceState();
}

class _FinanceAndInsuranceState extends State<FinanceAndInsurance> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  TextEditingController textField1Controller = TextEditingController();
  TextEditingController textField2Controller = TextEditingController();
  TextEditingController textField3Controller = TextEditingController();
  TextEditingController textField4Controller = TextEditingController();
  TextEditingController textField5Controller = TextEditingController();

  String displayedText = '';
  bool isFinanceSelected = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(5.0),
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.grey.shade500;
                          }
                          return Colors.orangeAccent;
                        }),
                  ),
                  onPressed: () {
                    setState(() {
                      isFinanceSelected = true;
                      _controller.reset();
                      _controller.forward();
                    });
                  },
                  child: Text('Finance' ,style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(5.0),
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.grey.shade500;
                          }
                          return Colors.orangeAccent;
                        }),
                  ),
                  onPressed: () {
                    setState(() {
                      isFinanceSelected = false;
                      _controller.reset();
                      _controller.forward();
                    });
                  },
                  child: Text('Insurance', style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ],
            ),
            SizedBox(height: 10),
            buildAnimatedTextFields(),
            SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(5.0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(double.maxFinite, 35),
                  ),
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.grey.shade500;
                      }
                      return Colors.orangeAccent;
                    },
                  ),
                ),
                onPressed:(){

                }, child: Text('Confirm',style: TextStyle(color: Colors.black, fontSize: 20),))

          ],
        ),
      ),
    );
  }

  Widget buildAnimatedTextFields() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - _animation.value)),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          if (isFinanceSelected)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: textField1Controller,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')), // Allow only numbers
                  // Limit length to 10 characters
                ],

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),

          if (!isFinanceSelected)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: textField3Controller,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')), // Allow only numbers
                  // Limit length to 10 characters
                ],

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: textField5Controller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                // Limit length to 10 characters
              ],

              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone NUmber',
              ),
            ),

          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: textField5Controller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')), // Allow only numbers
                // Limit length to 10 characters
              ],

              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Vechile Number',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: textField5Controller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')), // Allow only numbers
                // Limit length to 10 characters
              ],

              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Vechile Model',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: textField5Controller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')), // Allow only numbers
                // Limit length to 10 characters
              ],

              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'RC No',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
