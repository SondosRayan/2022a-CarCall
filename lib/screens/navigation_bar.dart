import 'package:car_call/screens/home_screen.dart';
import 'package:car_call/screens/profile.dart';
import 'package:car_call/screens/requests_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../globals.dart';
import 'chat_screen.dart';
import 'notifications/alerts.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _screens =[
    const MyHomePage(), ChatScreen(), const RequestsScreen(),
    const NotificationsScreen(),const ProfileScreen()
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex){
    // print(selectedIndex);
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: green11), // sets the inactive color of the `BottomNavigationBar`,
        child: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed, // added
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                  color: _selectedIndex==0 ? Colors.white : Colors.black
                ),
                label: 'Home',
                /*title: Text("Home",
                    style:TextStyle(color: _selectedIndex==0 ? Colors.white : Colors.black))*/
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat,
                  color: _selectedIndex==1 ? Colors.white : Colors.black
                ),
                label: 'Chat',
                /*title: Text("Chat",
                    style:TextStyle(color: _selectedIndex==1 ? Colors.white : Colors.black))*/
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu,
                color: _selectedIndex==2 ? Colors.white : Colors.black
              ),
                label: 'Requests',
                /*title: Text("Requests",
                    style:TextStyle(color: _selectedIndex==2 ? Colors.white : Colors.black))*/
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications,
                color: _selectedIndex==3 ? Colors.white : Colors.black
              ),
                label: 'Notifications',
                /*title: Text("Notifications",
                    style:TextStyle(color: _selectedIndex==3 ? Colors.white : Colors.black))*/
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,
                color: _selectedIndex==4 ? Colors.white : Colors.black
              ),
                label: 'Profile',
                /*title: Text("Profile",
                    style:TextStyle(color: _selectedIndex==4 ? Colors.white : Colors.black))*/
            ),
          ],),
      ),
    );
  }
}

