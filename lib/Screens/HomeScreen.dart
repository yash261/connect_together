import 'package:connect_together/CallScreens/pickupLayout.dart';
import 'package:connect_together/FirebaseRepository.dart';
import 'package:connect_together/Models/User.dart';
import 'package:connect_together/Screens/ChatScreen.dart';
import 'package:connect_together/Widgets/SideBar.dart';
import 'package:connect_together/imageload.dart';
import 'package:connect_together/universalvariables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatefulWidget {
  UserModel user;
  HomeScreen({this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FSBStatus drawerStatus;
  int _pageNumber=0;
  PageController pageController=PageController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return pickupLayout(user: widget.user,body:SafeArea(
        child: Scaffold(
          body: FoldableSidebarBuilder(
            drawerBackgroundColor: Colors.black,
            drawer: CustomDrawer(closeDrawer: (){
              setState(() {
                drawerStatus = FSBStatus.FSB_CLOSE;
              });
            },),
            screenContents: MainHomeScreen(),
            status: drawerStatus,
          ),
        ),
    ));
  }

  Widget MainHomeScreen(){
    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: AppBar(
          leading: FlatButton(onPressed: (){
            setState(() {
              drawerStatus = drawerStatus == FSBStatus.FSB_OPEN ? FSBStatus.FSB_CLOSE : FSBStatus.FSB_OPEN;
            });
          }, child: Icon(Icons.menu)),
          title: Text('Connect Together'),
          centerTitle: true,
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: pageChanged,
          children: [
            Container(child: ChatScreen(currentUser: widget.user,),),
            Center(child: Text('Call Logs',style: TextStyle(color: Colors.white),)),
            Center(child: Text('Contact Screen',style: TextStyle(color: Colors.white),)),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              currentIndex: _pageNumber,
              onTap: navigationTapped,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.chat,color: _pageNumber==0?Colors.blue:Colors.grey,),title: Text('Chats',style: TextStyle(color: _pageNumber==0?Colors.blue:Colors.grey,fontSize: 10),)),
                BottomNavigationBarItem(icon: Icon(Icons.call,color: _pageNumber==1?Colors.blue:Colors.grey,),title: Text('Call',style: TextStyle(color: _pageNumber==1?Colors.blue:Colors.grey,fontSize: 10),)),
                BottomNavigationBarItem(icon: Icon(Icons.contacts,color: _pageNumber==2?Colors.blue:Colors.grey,),title: Text('Contacts',style: TextStyle(color: _pageNumber==2?Colors.blue:Colors.grey,fontSize: 10),)),
              ]),
        )
    );
  }
  void navigationTapped(int page){
    setState(() {
      pageController.jumpToPage(page);
    });
  }
  void pageChanged(int page){
    setState(() {
      _pageNumber=page;
    });
  }
}
