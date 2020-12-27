import 'package:connect_together/Models/User.dart';
import 'package:connect_together/Screens/search_screen.dart';
import 'package:connect_together/Widgets/userCircle.dart';
import 'package:connect_together/utils.dart';
import 'package:flutter/material.dart';
import 'package:connect_together/universalvariables.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.actions,
    @required this.leading,
    @required this.centerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: UniversalVariables.blackColor,
        border: Border(
          bottom: BorderSide(
            color: UniversalVariables.separatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: UniversalVariables.blackColor,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight+10);
}

CustomAppBar customAppBar(BuildContext context,UserModel user){
  return CustomAppBar(
      title: UserCircle(Utils.getInitials(user.name)),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchScreen(user: user)));
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
      leading: IconButton(icon: Icon(Icons.notifications,color: Colors.white,),), centerTitle: true);
}