import 'dart:io';

import 'package:class12chatapp/auth/firebase_auth.dart';
import 'package:class12chatapp/models/usermodel.dart';
import 'package:class12chatapp/page/login_page.dart';
import 'package:class12chatapp/providers/user_providers.dart';
import 'package:class12chatapp/widgets/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class profilePage extends StatefulWidget {
  static const String routeName = 'profile';

  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  final txtController = TextEditingController();

  @override
  void dispose() {
    txtController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Text('Profile Page'),
        actions: [
          IconButton(
              onPressed: () {
                AuthService.logout();
                Navigator.pushReplacementNamed(context, loginPage.routeName);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Consumer<Userprovider>(
          builder: (context, provider, _) => StreamBuilder<
                  DocumentSnapshot<Map<String, dynamic>>>(
              stream: provider.getUserBYId(AuthService.user!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userModel = UserModel.fromMap(snapshot.data!.data()!);
                  return ListView(
                    children: [
                      Center(
                        child: userModel.image == null
                            ? Image.asset(
                                'images/person.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                userModel.image!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _showBottomSheet,
                          icon: Icon(Icons.camera_alt),
                          label: const Text('Update Image'),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        height: 30,
                      ),
                      ListTile(
                        title: Text(userModel.name ?? 'NO Display name'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showInputDialog(
                                title: 'Display Name',
                                value: userModel.name,
                                onSaved: (value) async {
                                  provider.updateprofile(
                                      AuthService.user!.uid, {'name': value});
                                  await AuthService.updateDisplayName(value);
                                });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(userModel.email),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showInputDialog(
                                title: 'Email',
                                value: userModel.email,
                                onSaved: (value) async {
                                  await AuthService.updateEmail(value);
                                  await provider.updateprofile(
                                      AuthService.user!.uid, {'email': value});
                                });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(userModel.mobile ?? 'NO Mobile Number'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showInputDialog(
                                title: 'Mobile Number',
                                value: userModel.mobile,
                                onSaved: (value) {
                                  provider.updateprofile(
                                      AuthService.user!.uid, {'mobile': value});
                                });
                          },
                        ),
                      )
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return const Text('Failed to fetch Data');
                }
                return const CircularProgressIndicator();
              }),
        ),
      ),
    );
  }

  // void _getImage() async{
  //   final xFile = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 75);
  //   if(xFile != null){
  //     final downloadUrl = await Provider
  //         .of<Userprovider>(context,listen: false)
  //         .updateImage(File(xFile.path));
  //     await Provider
  //         .of<Userprovider>(context,listen: false)
  //         .updateprofile(AuthService.user!.uid, {'image':downloadUrl});
  //     await AuthService.updatePhotoUrl(downloadUrl);
  //   }
  // }
  showInputDialog(
      {required String title,
      String? value,
      required Function(String) onSaved}) {
    txtController.text = value ?? "";
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: txtController,
                  decoration: InputDecoration(hintText: 'Enter $title'),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    onSaved(txtController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('UPDATE'),
                ),
              ],
            ));
  }

  _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 5.0, bottom: 10),
            children: [
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(100, 120)),
                      onPressed: () async {
                        final xFile = await ImagePicker().pickImage(
                            source: ImageSource.camera, imageQuality: 75);
                        if (xFile != null) {
                          final downloadUrl = await Provider.of<Userprovider>(
                                  context,
                                  listen: false)
                              .updateImage(File(xFile.path));
                          await Provider.of<Userprovider>(context,
                                  listen: false)
                              .updateprofile(AuthService.user!.uid,
                                  {'image': downloadUrl});
                        }
                      },
                      child: Image.asset('images/camera.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(100, 120)),
                      onPressed: () async {
                        final xFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 75);
                        if (xFile != null) {
                          final downloadUrl = await Provider.of<Userprovider>(
                                  context,
                                  listen: false)
                              .updateImage(File(xFile.path));
                          await Provider.of<Userprovider>(context,
                                  listen: false)
                              .updateprofile(AuthService.user!.uid,
                                  {'image': downloadUrl});
                        }
                      },
                      child: Image.asset('images/add_image.png')),
                ],
              )
            ],
          );
        });
  }
  void img(){
    
  }
}
