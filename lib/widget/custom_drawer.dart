import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Safdar Hussain'),
            accountEmail: const Text('safdarse063@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/images/profile.jpg'),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              image: DecorationImage(
                  image: AssetImage('assets/images/bgimage.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.5),
            ),
          ),

          ListTile(
              title:
                  const Text('Your Profile', style: TextStyle(fontSize: 18.0)),
              leading: Icon(
                Icons.person_rounded,
                size: 30.0,
              )),
          ListTile(
              title: const Text('Ratings', style: TextStyle(fontSize: 18.0)),
              leading: Icon(
                Icons.rate_review_rounded,
                size: 30.0,
              )),
          ListTile(
              title: const Text('About', style: TextStyle(fontSize: 18.0)),
              leading: Icon(
                Icons.info_outline_rounded,
                size: 30.0,
              )),
          // Add more items to the drawer here if needed
        ],
      ),
    );
  }
}
