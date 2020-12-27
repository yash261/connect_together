import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_together/CallScreens/callScreen.dart';
import 'package:connect_together/FirebaseRepository.dart';
import 'package:connect_together/Models/User.dart';
import 'package:connect_together/Screens/ImageScreen.dart';
import 'package:connect_together/Widgets/CustomAppBar.dart';
import 'package:connect_together/Widgets/custom_tile.dart';
import 'package:connect_together/callUtilities.dart';
import 'package:connect_together/imageload.dart';
import 'package:connect_together/permissions.dart';
import 'package:connect_together/universalvariables.dart';
import 'package:connect_together/utils.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'ChatScreen.dart';
class Chat extends StatefulWidget {
  UserModel user,currentuser;
  Chat({this.user,this.currentuser});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final picker=ImagePicker();
  bool showemoji=false;
  UserModel currentUser;
  ScrollController scrollController=ScrollController();
  FirebaseRepository _firebaseRepository=FirebaseRepository();
  TextEditingController msg = TextEditingController();
  bool writing=false;
  FocusNode keyboard=FocusNode();
   ImageUploadProvider _imageUploadProvider;
   void getCurrentUser() {
       _firebaseRepository.fetchCurrentUser().then((value){
         print(value);
         setState(() {
           currentUser=value;
         });
       });
   }
   @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageUploadProvider>(
      create: (context)=>ImageUploadProvider(),
      child: Builder(
        builder: (BuildContext newcontext){
          _imageUploadProvider=Provider.of<ImageUploadProvider>(newcontext);
          return Scaffold(
          appBar: CustomAppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
              Navigator.pop(context);
            },),
            actions: [
              IconButton(icon: Icon(Icons.call), onPressed: () {
              },),
              IconButton(icon: Icon(Icons.video_call), onPressed: () async {
                if(await Permissions.cameraAndMicrophonePermissionsGranted()) {
                  CallUtils.dial(from: currentUser, to: widget.user,context: context);
                }
                else{
                  print("permissions error!!!!!!!!!!!!");
                }
              },),
            ],
            centerTitle: false,
            title: Text(widget.user.name, style: TextStyle(fontSize: 20),),),
          body: Column(
            children: [
              Expanded(
              child: messageList(),
            ),
              if(_imageUploadProvider.getViewState==ViewState.LOADING)
                Container(
                    margin: EdgeInsets.all(8),
                    alignment: Alignment.centerRight,
                    child: CircularProgressIndicator()),
              messagecontroller(),
              if(showemoji)
                ShowEmojiBoard(),
            ],
          ),
        );},
      ),
    );
  }
 Widget messageList(){
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('messages').doc(widget.currentuser.uid).collection(widget.user.uid).orderBy("timestamp",descending: true).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snap) {
          if(snap.data==null){
             return CircularProgressIndicator();
            }
          return ListView.builder(
            reverse: true,
              controller: scrollController,
              itemCount: snap.data.docs.length, itemBuilder: (context, index) {
            return chatMessage(snap.data.docs[index]);
          });
        }
    );
 }
 Widget chatMessage(DocumentSnapshot snapshot){
   return Container(
     margin: EdgeInsets.symmetric(vertical: 15),
     child: Container(
       alignment: snapshot['senderId']==widget.currentuser.uid ?Alignment.centerRight:Alignment.centerLeft,
       child: snapshot['senderId']==widget.currentuser.uid?senderLayout(snapshot):receiverLayout(snapshot),
     ),
   );

 }
  Widget senderLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);
    return snapshot['type']=='image'?GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ImageScreen(url:snapshot['message']);}));
        },
      child: Hero(
        tag: snapshot['message'],
        child: Container(
            constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65), child:
        CachedNetworkImage(imageUrl: snapshot['message'],placeholder: (context,url)=>CircularProgressIndicator(),)
      ),
    ))
        : Container(
          margin: EdgeInsets.only(top: 12),
           constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
         decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          snapshot['message'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);
    return snapshot['type']=='image'?GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ImageScreen(url:snapshot['message']);}));
        },
        child: Hero(
          tag: snapshot['message'],
          child: Container(
              constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65), child:
          CachedNetworkImage(imageUrl: snapshot['message'],placeholder: (context,url)=>CircularProgressIndicator(),)
          ),
        )):Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
      BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          snapshot['message'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  Widget messagecontroller() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.shade100,Colors.blue.shade300])
        ),
        child: Row(
            children: [
              SizedBox(width: 5,),
              GestureDetector(
                onTap: () => addMediaModal(context),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    gradient: UniversalVariables.fabGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add),
                ),
              ),
              Expanded(child: TextField(
                focusNode: keyboard,
                onTap: (){
                  keyboard.requestFocus();
                  setState(() {
                    showemoji=false;
                  });
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                  //contentPadding: EdgeInsets.symmetric(vertical: 30,horizontal:5),
                  fillColor: UniversalVariables.separatorColor,
                  hintText: 'Enter Message',
                  hintStyle: TextStyle(color: Colors.black)
                ),
                controller: msg,onChanged: (val){
                setState(() {
                  writing=val.length>0?true:false;
                });
              },)),
              SizedBox(width: 5,),
              IconButton(icon: Icon(Icons.face),onPressed: (){
                keyboard.unfocus();
                setState(() {
                  showemoji=!showemoji;
                });
              },),
              SizedBox(width: 5,),
              if(writing)
                IconButton(icon: Icon(Icons.arrow_forward_ios,color: Colors.black,),onPressed: (){
                  sendmessage();
                },color: Colors.blue,)
              else
                IconButton(icon: Icon(Icons.insert_photo),onPressed: (){},)
            ],
          ),
      ),
    );
  }
  addMediaModal(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: UniversalVariables.blackColor,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.close,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and tools",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ModalTile(
                      title: "Media",
                      subtitle: "Share Photos and Video",
                      icon: Icons.image,
                      onTap: pickImage,
                    ),
                    ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab),
                    ModalTile(
                        title: "Contact",
                        subtitle: "Share contacts",
                        icon: Icons.contacts),
                    ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location),
                    ModalTile(
                        title: "Schedule Call",
                        subtitle: "Arrange a skype call and get reminders",
                        icon: Icons.schedule),
                    ModalTile(
                        title: "Create Poll",
                        subtitle: "Share polls",
                        icon: Icons.poll)
                  ],
                ),
              ),
            ],
          );
        });
  }
  File _image;
  pickImage() async{
    print('print');
    File img=await Utils.pickImage();
    Navigator.pop(context);
    _firebaseRepository.uploadImage(img,widget.user.uid,_imageUploadProvider);
  }
  sendmessage(){
    _firebaseRepository.addchat(msg.text,widget.user,widget.currentuser);
    msg.clear();
  }
  Widget ShowEmojiBoard() {
    return Container(
      child: EmojiPicker(
          bgColor: UniversalVariables.separatorColor,
          indicatorColor: UniversalVariables.blueColor,
          rows: 3,
          columns: 7,
          onEmojiSelected: (emoji, category) {
            setState(() {
              writing=true;
            });
            msg.text=msg.text+emoji.emoji;
          }),
    );
  }

}


class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  Function onTap;

  ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: onTap,
        child: CustomTile(
          mini: false,
          leading: Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: UniversalVariables.receiverColor,
            ),
            padding: EdgeInsets.all(10),
            child: Icon(
              icon,
              color: UniversalVariables.greyColor,
              size: 38,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: UniversalVariables.greyColor,
              fontSize: 14,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}