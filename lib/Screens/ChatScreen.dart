import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_together/Models/User.dart';
import 'package:connect_together/Screens/Chat.dart';
import 'package:connect_together/Widgets/CustomAppBar.dart';
import 'package:connect_together/Widgets/custom_tile.dart';
import 'package:connect_together/universalvariables.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  UserModel currentUser;
  ChatScreen({this.currentUser});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    print(widget.currentUser.uid);
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context,widget.currentUser),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(widget.currentUser),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient,
          borderRadius: BorderRadius.circular(50)),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}


class ChatListContainer extends StatefulWidget {
  UserModel currentUser;

  ChatListContainer(this.currentUser);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  ScrollController scrollController=ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser.uid).collection("contacts").orderBy("added_on",descending: true).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snap) {
          if(snap.data==null){
            return CircularProgressIndicator();
          }
          if(snap.data.docs.length==0){
            return Center(child: Text("No Chats",style: TextStyle(fontSize: 20,color: UniversalVariables.greyColor),));
          }
          return ListView.builder(
              itemCount: snap.data.docs.length, itemBuilder: (context, index) {
                var user=snap.data.docs[index].data();
                UserModel _userModel=UserModel.fromMap(user["contact_id"]);
            return Padding(
            padding: const EdgeInsets.all(10.0),
                child: CustomTile(
                  mini: false,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chat(user: _userModel,currentuser:widget.currentUser)));
                  },
                  title: Text(
                    _userModel.name,
                    style: TextStyle(
                        color: Colors.white, fontFamily: "Arial", fontSize: 19),
                  ),
                  subtitle: Text(
                    "",
                    style: TextStyle(
                      color: UniversalVariables.greyColor,
                      fontSize: 14,
                    ),
                  ),
                  leading: Container(
                    constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          maxRadius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              _userModel.profilePhoto==null?
                              "https://www.ugtabharat.com/wp-content/uploads/2020/05/userphoto.png":_userModel.profilePhoto
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 13,
                            width: 13,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: UniversalVariables.onlineDotColor,
                                border: Border.all(
                                    color: UniversalVariables.blackColor,
                                    width: 2
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            );
          });
        }
    );

  }
}