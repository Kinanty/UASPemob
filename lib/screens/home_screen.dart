import 'dart:convert';

import 'package:amgala/helper/helper.dart';
import 'package:amgala/models/volunteer_activity.dart';
import 'package:amgala/screens/account_screen.dart';
import 'package:amgala/screens/activity_screen.dart';
import 'package:amgala/screens/inbox_screen.dart';
import 'package:amgala/screens/login_screen.dart';
import 'package:amgala/screens/volunteer_activities_screen.dart';
import 'package:amgala/service/volunteer_activity_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bottom Navbar Example',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ActivityListPage(),
    InboxPage(),
    AccountPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Color(0xFF125593),
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/activity.png')),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/inbox.png')),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/account.png')),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ActivityService _service = ActivityService();
  List<VolunteerActivity> activities = [];
  List<VolunteerActivity> filteredActivities = [];
  bool isLoading = true;

  String? userEmail;
  String? username;
  String? fullname;
  String? image;
  String? userId;
  String searchQuery = '';

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
      });
      _fetchActivities();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _fetchActivities() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await _service.getYourActivity(userId.toString());
      setState(() {
        activities = data;
        filteredActivities = data;
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

  void _searchActivities(String query) {
    setState(() {
      searchQuery = query;
      filteredActivities = activities.where((activity) {
        return activity.title.toLowerCase().contains(query.toLowerCase()) ||
            activity.date.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchActivities,
          child: ListView(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Text(
                      'Activity Categories',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivityPageScreen(
                                    activityType: 'volunteer'),
                              ),
                            );
                          },
                          child: _buildCategoryItem(
                              'Volunteer', 'assets/volunteer_icon.png'),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivityPageScreen(
                                    activityType: 'workshop'),
                              ),
                            );
                          },
                          child: _buildCategoryItem(
                              'Workshop', 'assets/workshop_icon.png'),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ActivityPageScreen(activityType: 'webinar'),
                              ),
                            );
                          },
                          child: _buildCategoryItem(
                              'Webinar', 'assets/webinar_icon.png'),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Your Activity',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : filteredActivities.isEmpty
                            ? Center(
                                child: Text(
                                  "No activities match your search.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: filteredActivities.map((activity) {
                                    return _buildActivityCard(
                                      activity.title,
                                      activity.date,
                                      activity.imageUrl,
                                    );
                                  }).toList(),
                                ),
                              ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Color(0xFF125593),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${fullname}!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Let’s start spreading goodness...',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              Expanded(child: SizedBox(width: 12)),
              CircleAvatar(
                backgroundImage: NetworkImage(image ??
                    "https://cdn.pixabay.com/photo/2017/02/23/13/05/avatar-2092113_1280.png"),
              ),
            ],
          ),
          SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: _searchActivities,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Image.asset(icon),
        ),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildActivityCard(String title, String date, String imagePath) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(imagePath,
                height: 100, width: 200, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(DateHelper.formatDateToReadable(date), style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
