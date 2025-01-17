import 'dart:convert';

import 'package:amgala/helper/helper.dart';
import 'package:amgala/models/volunteer_activity.dart';
import 'package:amgala/screens/activity_detail_screen.dart';
import 'package:amgala/service/volunteer_activity_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activity {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final String imageUrl;

  Activity({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}

// screens/activity_list_page.dart
class ActivityListPage extends StatefulWidget {
  const ActivityListPage({Key? key}) : super(key: key);

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  final ActivityService _service = ActivityService();
  List<Activity> activities = [];
  bool isLoading = true;

  String? userId;

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      var userData = json.decode(userDataString);
      setState(() {
        userId = userData['id'];
      });
      _fetchActivities();
    }
  }

  Future<void> _fetchActivities() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await _service.getYourActivity(userId!);
      setState(() {
        activities = data.map((item) {
          return Activity(
            id: item.id.toString(),
            title: item.title,
            date: item.date,
            time: item.time,
            location: item.location,
            description: item.description,
            imageUrl: item.imageUrl,
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch activities: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : activities.isEmpty
              ? _buildEmptyState()
              : _buildActivityList(context),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Your Activity is Empty',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailPage(
                  activity: activities[index],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(activities[index].imageUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activities[index].title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                          DateHelper.formatDateToReadable(activities[index].date),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
