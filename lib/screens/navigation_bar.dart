import 'package:car_call/screens/home_screen.dart';
import 'package:car_call/screens/profile.dart';
import 'package:car_call/screens/requests_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../globals.dart';
import 'chat.dart';
import 'notifications/alerts.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {

  final PageController _pageController = PageController();
  final List<Widget> _screens =[
    const MyHomePage(), const ChatScreen(), const RequestsScreen(),
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

  int _selectedIndex = 0;

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
          // backgroundColor: green11,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                  color: _selectedIndex==0 ? Colors.white : Colors.black),
                title: Text("Home",
                    style:TextStyle(color: _selectedIndex==0 ? Colors.white : Colors.black))),
            BottomNavigationBarItem(icon: Icon(Icons.chat,
                color: _selectedIndex==1 ? Colors.white : Colors.black),
                title: Text("Chat",
                    style:TextStyle(color: _selectedIndex==1 ? Colors.white : Colors.black))),
            BottomNavigationBarItem(icon: Icon(Icons.menu,
                color: _selectedIndex==2 ? Colors.white : Colors.black),
                title: Text("Requests",
                    style:TextStyle(color: _selectedIndex==2 ? Colors.white : Colors.black))),
            BottomNavigationBarItem(icon: Icon(Icons.notifications,
                color: _selectedIndex==3 ? Colors.white : Colors.black),
                title: Text("Notifications",
                    style:TextStyle(color: _selectedIndex==3 ? Colors.white : Colors.black))),
            BottomNavigationBarItem(icon: Icon(Icons.person,
                color: _selectedIndex==4 ? Colors.white : Colors.black),
                title: Text("Profile",
                    style:TextStyle(color: _selectedIndex==4 ? Colors.white : Colors.black))),
          ],),
      ),
    );
  }
}

