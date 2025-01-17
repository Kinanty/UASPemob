import 'dart:convert';

import 'package:amgala/models/news_activity.dart';
import 'package:amgala/screens/detail_inbox_screen.dart';
import 'package:amgala/service/volunteer_activity_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amgala/models/message_activity.dart';
import 'package:amgala/screens/approved_screen.dart';
import 'package:amgala/screens/declined_screen.dart';

class InboxPage extends StatefulWidget {
  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final ActivityService _service = ActivityService();
  List<MessageActivity> messages = [];
  List<NewsActivity> activities = [];
  bool isLoading = true;
  String? userId;

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      var userData = json.decode(userDataString);
      setState(() {
        userId = userData['id'];
            _fetchMessage();

      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() => isLoading = true);
    try {
      final data = await _service.getNews();
      setState(() {
        activities = data;
        isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  Future<void> _fetchMessage() async {
    setState(() => isLoading = true);
    try {
      final data = await _service.getMessage(userId.toString());
      setState(() {
        messages = data;
        isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  void _showErrorSnackBar(String message) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
               
                  SizedBox(width: 24),
                  Text(
                    "Inbox",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                tabs: [Tab(text: "News"), Tab(text: "Message")],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildNewsTab(),
                    _buildMessageTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsTab() {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (activities.isEmpty) {
      return Center(
        child: Text("No news available", style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailInboxPage(activity: activity)),
            );
          },
          child: _buildNewsItem(
            title: activity.newsTitle,
            description: activity.subtitle,
            imagePath: activity.imageUrl,
          ),
        );
      },
    );
  }

  Widget _buildMessageTab() {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (messages.isEmpty) {
      return Center(
        child: Text("No messages available", style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return GestureDetector(
          onTap: () {
            if (message.approval == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApprovedPage(message: message,)),
              );
            } else if (message.approval == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeclinedPage(message: message,)),
              );
            }
          },
          child: _buildMessageItem(
            title: message.title,
            description: message.description,
            imagePath: message.imageUrl,
          ),
        );
      },
    );
  }

  Widget _buildNewsItem({required String title, required String description, required String imagePath}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(imagePath)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem({required String title, required String description, required String imagePath}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(imagePath)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
