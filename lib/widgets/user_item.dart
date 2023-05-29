import 'package:class12chatapp/models/usermodel.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final UserModel userModel;
  const UserItem({Key? key,required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: userModel.image == null
          ? AssetImage('images/person.png')
          : NetworkImage(userModel.image!) as ImageProvider<Object>,
        ),
      title: Text(userModel.name?? userModel.email),
      subtitle: Text(userModel.available? 'online':'offline',
      style: TextStyle(
        color: userModel.available ? Colors.green : Colors.grey
      ),),
    );
  }
}
