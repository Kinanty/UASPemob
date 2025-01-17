import 'package:amgala/screens/login_screen.dart';
import 'package:amgala/service/volunteer_activity_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? userEmail;
  String? username;
  String? fullname;
  String? image;
  String? userId;
  bool isEditing = false;

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final ActivityService _volunteerService = ActivityService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      var userData = json.decode(userDataString);
      setState(() {
        userId = userData['id'];
        username = userData['username'];
        userEmail = userData['email'];
        fullname = userData['fullname'];
        image = userData['image'];

        // Initialize controllers
        _fullnameController.text = fullname ?? '';
        _emailController.text = userEmail ?? '';
        _imageController.text = image ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (userId == null) return;

    try {
      await _volunteerService.updateUserProfile(
        userId!,
        _fullnameController.text.trim(),
        _emailController.text.trim(),
        _imageController.text.trim(),
      );

      setState(() {
        fullname = _fullnameController.text.trim();
        userEmail = _emailController.text.trim();
        image = _imageController.text.trim();
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundImage: image != null
                    ? NetworkImage(image!)
                    : AssetImage('assets/no-camera.png') as ImageProvider,
              ),
              if (isEditing) SizedBox(height: 12),
              if (isEditing)
                TextField(
                  controller: _imageController,
                  decoration: InputDecoration(
                    labelText: 'Profile Image URL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              SizedBox(height: 16),
              TextField(
                controller: _fullnameController,
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _emailController,
                enabled: isEditing,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isEditing
                    ? _updateProfile
                    : () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isEditing ? "Save" : "Edit Profile",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
