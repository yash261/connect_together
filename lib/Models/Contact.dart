import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_together/Models/User.dart';

class Contact  {
  UserModel user;
  Timestamp addedOn;

  Contact({
    this.user,
    this.addedOn,
  });

  Map toMap(Contact contact) {
    var data = Map<String, dynamic>();
    data['contact_id'] = contact.user.toMap(contact.user);
    data['added_on'] = contact.addedOn;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    this.user = UserModel.fromMap(mapData['contact_id']);
    this.addedOn = mapData["added_on"];
  }
}