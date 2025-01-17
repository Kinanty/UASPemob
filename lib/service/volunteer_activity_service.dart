import 'dart:convert';

import 'package:amgala/config/database_connection.dart';
import 'package:amgala/models/message_activity.dart';
import 'package:amgala/models/news_activity.dart';
import 'package:amgala/models/volunteer_activity.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityService {
  Future<List<VolunteerActivity>> getActivities(String type) async {
    final db = DatabaseConnection.getInstance();
    MySqlConnection? connection;

    try {
      connection = await db.getConnection();
    
      final results = await connection.query(
        'SELECT * FROM events WHERE type = ?',
        [type],
      );

      return results.map((row) {
        print('ID: ${row['id']}');
        print('Title: ${row['title']}');
        print('Image: ${row['image']} (Type: ${row['image'].runtimeType})');

        return VolunteerActivity(
          id: row['id'],
          title: row['title'],
          date: row['date'].toString(),
          time: row['time'].toString(),
          type: row['type'],
          description: row['description'].toString(),
          imageUrl: row['image'].toString(),
          location: row['location'].toString(),
        );
      }).toList();
    } catch (e, stackTrace) {
      print('Error fetching activities: $e');
      print('StackTrace: $stackTrace');

      return [];
    } finally {
      if (connection != null) {
        // await connection.close();
      }
    }
  }

  Future<List<String>> getTerms(int eventId) async {
    final db = DatabaseConnection.getInstance();
    MySqlConnection? connection;

    try {
      connection = await db.getConnection();

      final results = await connection.query(
        'SELECT terms FROM terms WHERE event_id = ?',
        [eventId],
      );

      return results.map((row) => row['terms'].toString()).toList();
    } catch (e, stackTrace) {
      print('Error fetching terms: $e');
      print('StackTrace: $stackTrace');
      return [];
    } finally {
      if (connection != null) {
        // await connection.close();
      }
    }
  }

  Future<bool> registerUser(
      String username, String email, String password, String fullname) async {
    final db = DatabaseConnection.getInstance();
    MySqlConnection? connection;

    try {
      connection = await db.getConnection();

      final emailCheck = await connection.query(
        'SELECT COUNT(*) as count FROM users WHERE email = ?',
        [email],
      );

      if (emailCheck.first['count'] > 0) {
        throw Exception("Email already registered");
      }

      await connection.query(
        'INSERT INTO users (username, fullname, email, password) VALUES (?, ?, ?, ?)',
        [username, fullname, email, password],
      );

      return true;
    } catch (e) {
      print("Error registering user: $e");
      return false;
    }
  }

  Future<List<VolunteerActivity>> getYourActivity(String userId) async {
    final conn = await DatabaseConnection.getInstance().getConnection();
    try {
      final result = await conn.query(
        'SELECT events.location, events.id, events.title, events.date, events.time, events.type, events.description, events.image '
        'FROM event_registration e '
        'JOIN users ON e.user_id = users.id '
        'JOIN events ON events.id = e.event_id '
        'WHERE e.approval = 1 '
        'AND users.id = ?'
        ,
        [userId],
      );
      // await conn.close();
      print(userId);
      print(result.toString());
      List<VolunteerActivity> activities = [];
      for (var row in result) {
        activities.add(VolunteerActivity(
          id: row['id'],
          location: row['location'].toString(),
          title: row['title'],
          date: row['date'].toString(),
          time: row['time'].toString(),
          type: row['type'],
          description: row['description'].toString(),
          imageUrl: row['image'].toString(),
        ));
      }
      return activities;
    } catch (e) {
      throw Exception('Failed to load activities: $e');
    } finally {
      if (conn != null) {
        // await conn.close();
      }
    }
  }

  Future<List<NewsActivity>> getNews() async {
    final conn = await DatabaseConnection.getInstance().getConnection();
    try {
      final result = await conn.query(
          'SELECT events.id, events.title, events.location, news.title as newsTitle, news.subtitle, events.date, events.time, events.type, events.description, events.image '
          'FROM news '
          'JOIN events ON events.id = news.event_id');

      // await conn.close();
      print(result.toString());
      List<NewsActivity> activities = [];
      for (var row in result) {
        activities.add(NewsActivity(
          id: row['id'],
          location: row['location'].toString(),
          title: row['title'],
          date: row['date'].toString(),
          time: row['time'].toString(),
          type: row['type'],
          description: row['description'].toString(),
          imageUrl: row['image'].toString(),
          subtitle: row['subtitle'].toString(),
          newsTitle: row['newsTitle'].toString(),
        ));
      }
      return activities;
    } catch (e) {
      throw Exception('Failed to load activities: $e');
    } finally {
      if (conn != null) {
        // await conn.close();
      }
    }
  }

  Future<void> updateUserProfile(
      String userId, String fullname, String email, String imageUrl) async {
    final conn = await DatabaseConnection.getInstance().getConnection();

    try {
      await conn.query(
        'UPDATE users SET fullname = ?, email = ?, image = ? WHERE id = ?',
        [fullname, email, imageUrl, userId],
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('user_data');

      if (userDataString != null) {
        Map<String, dynamic> userData = json.decode(userDataString);
        userData['fullname'] = fullname;
        userData['email'] = email;
        userData['image'] = imageUrl;
        await prefs.setString('user_data', json.encode(userData));
      }
    } catch (e) {
      throw Exception("Failed to update user profile: $e");
    }
  }

  Future<List<MessageActivity>> getMessage(String userId) async {
    final conn = await DatabaseConnection.getInstance().getConnection();
    try {
      final result = await conn.query(
        'SELECT e.notes, e.approval, events.location, events.id, events.title, events.date, '
        'events.time, events.type, events.description, events.image '
        'FROM event_registration e '
        'JOIN users ON e.user_id = users.id '
        'JOIN events ON events.id = e.event_id '
        'WHERE e.approval IS NOT NULL '
        'AND users.id = ?',
        [userId],
      );
      // await conn.close();
      print(userId);
      print(result.toString());
      List<MessageActivity> activities = [];
      for (var row in result) {
        activities.add(MessageActivity(
          id: row['id'],
          location: row['location'].toString(),
          title: row['title'],
          date: row['date'].toString(),
          time: row['time'].toString(),
          type: row['type'],
          description: row['description'].toString(),
          imageUrl: row['image'].toString(),
          approval: row['approval'],
          notes: row['notes'].toString(),
        ));
      }
      return activities;
    } catch (e) {
      throw Exception('Failed to load activities: $e');
    } finally {
      if (conn != null) {
        // await conn.close();
      }
    }
  }
}
