import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

@RoutePage()
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final ref = FirebaseStorage.instance.ref().child('Profile_Pics');
  String? userImageUrl;

  Future<String?> getImageUrl() async {
    final userImageURL = await ref.child(uid).getDownloadURL();
    setState(() {
      userImageUrl = userImageURL;
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    getImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CircleAvatar(
            radius: 78,
            backgroundColor: Colors.blueAccent,
            child: CircleAvatar(
              radius: 75,
              backgroundImage: userImageUrl == null
                  ? const AssetImage('assets/fake_user_profile.webp')
                  : NetworkImage(userImageUrl!),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListTile(
                leading: Icon(Icons.email_outlined),
                title: Text(
                  'Email : ',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  ' : ',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
