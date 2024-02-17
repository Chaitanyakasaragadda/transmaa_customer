import 'package:flutter/material.dart';
import '../login/login_page.dart';
import '../profile/YourProfile.dart';
import '../profile/aboutpage.dart';
import '../profile/help.dart';
import '../profile/notifications.dart';
import 'history.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 15), () {
      setState(() {
        _showAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                buildListItem(
                  icon: Icons.person_outline,
                  title: 'Your Profile',
                  color: Colors.orangeAccent,
                  onTap: () {
                    _navigateToPage(YourProfile());
                  },
                ),
                SizedBox(height: 20),
                buildListItem(
                  icon: Icons.history, // History icon
                  title: 'History', // History title
                  color: Colors.orangeAccent,
                  onTap: () {
                    _navigateToPage(HistoryScreen());
                  },
                ),
                SizedBox(height: 20),
                buildListItem(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  color: Colors.orangeAccent,
                  onTap: () {
                    _navigateToPage(NotificationsPage());
                  },
                ),
                SizedBox(height: 20),
                buildListItem(
                  icon: Icons.help_outline,
                  title: 'Help',
                  color: Colors.orangeAccent,
                  onTap: () {
                    _navigateToPage(HelpPage());
                  },
                ),
                SizedBox(height: 20),
                buildListItem(
                  icon: Icons.info_outline,
                  title: 'About Us',
                  color: Colors.orangeAccent,
                  onTap: () {
                    _navigateToPage(AboutUs());
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5,left: 5,bottom: 5),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(5.0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.orangeAccent;
                      }
                      return Colors.grey.shade500;
                    },
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>LoginScreen(onLogin: () {  },)));
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 800),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: page,
          );
        },
      ),
    );
  }

  Widget buildListItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      height: _showAnimation ? 50 : 0,
      child: ClipPath(
        clipper: ShapeClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade200, Colors.orange.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            onTap: onTap,
            contentPadding: EdgeInsets.only(left: 10),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width - 20, 0.0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
