import 'package:car_call/screens/home_screen.dart';
import 'package:car_call/screens/profile.dart';
import 'package:car_call/screens/requests_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../globals.dart';
import 'chat_screens/chat_screen.dart';
import 'notifications/alerts.dart';

class MyNavigationBar extends StatefulWidget {
  int index;
  MyNavigationBar({Key? key, required this.index}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState(selectedIndex: index);
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  _MyNavigationBarState({Key? key, required this.selectedIndex});
  //int index =0;
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //setState(() {
    //  selectedIndex = index;
    //});
  }
  //final PageController _pageController = PageController();
  final List<Widget> _screens =[
    const MyHomePage(), ChatScreen(), const RequestsScreen(),
    const NotificationsScreen(),const ProfileScreen()
  ];

  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onItemTapped(int index){
    // print(selectedIndex);
    setState(() {
      selectedIndex = index;
    });
    //_pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens.elementAt(selectedIndex),
      ),
      //body: PageView(
      //  controller: _pageController,
      //  children: _screens,
      //  onPageChanged: _onPageChanged,
      //  physics: const NeverScrollableScrollPhysics(),
      //),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: green11), // sets the inactive color of the `BottomNavigationBar`,
        child: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed, // added
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: selectedIndex==0 ? Colors.white : Colors.black
              ),
              label: 'Home',
              /*title: Text("Home",
                    style:TextStyle(color: _selectedIndex==0 ? Colors.white : Colors.black))*/
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat,
                  color: selectedIndex==1 ? Colors.white : Colors.black
              ),
              label: 'Chat',
              /*title: Text("Chat",
                    style:TextStyle(color: _selectedIndex==1 ? Colors.white : Colors.black))*/
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu,
                  color: selectedIndex==2 ? Colors.white : Colors.black
              ),
              label: 'Requests',
              /*title: Text("Requests",
                    style:TextStyle(color: _selectedIndex==2 ? Colors.white : Colors.black))*/
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications,
                  color: selectedIndex==3 ? Colors.white : Colors.black
              ),
              label: 'Notifications',
              /*title: Text("Notifications",
                    style:TextStyle(color: _selectedIndex==3 ? Colors.white : Colors.black))*/
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: selectedIndex==4 ? Colors.white : Colors.black
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

