import 'package:amgala/config/database_connection.dart';
import 'package:amgala/models/news_activity.dart';
import 'package:amgala/screens/register_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class DetailInboxPage extends StatefulWidget {
  final NewsActivity activity;

  const DetailInboxPage({Key? key, required this.activity}) : super(key: key);

  @override
  _DetailInboxPageState createState() => _DetailInboxPageState();
}

class _DetailInboxPageState extends State<DetailInboxPage> {
  late Future<List<String>> termsFuture;

  @override
  void initState() {
    super.initState();
    termsFuture = getTerms(widget.activity.id);
  }

  Future<List<String>> getTerms(int activityId) async {
    final db = DatabaseConnection.getInstance();
    MySqlConnection? connection;

    try {
      connection = await db.getConnection();

      final results = await connection.query(
        'SELECT terms FROM terms WHERE event_id = ?',
        [activityId],
      );

      return results.map((row) => row['terms'].toString()).toList();
    } catch (e, stackTrace) {
      print('Error fetching terms: $e');
      print('StackTrace: $stackTrace');
      return ['Error fetching terms.'];
    } finally {
      if (connection != null) {
        // await connection.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Image.network(
                      widget.activity.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 8,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.activity.newsTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Color(0xFF125593), size: 16),
                        SizedBox(width: 8),
                        Text(
                          widget.activity.date,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Color(0xFF125593), size: 16),
                        SizedBox(width: 8),
                        Text(
                          widget.activity.time,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Color(0xFF125593), size: 16),
                        SizedBox(width: 8),
                        Text(
                          widget.activity.location,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.activity.description,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Terms & Condition",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    FutureBuilder<List<String>>(
                      future:
                          termsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          // Menampilkan semua terms dalam daftar
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: snapshot.data!
                                .map((term) => Text(
                                      "• $term",
                                      style: TextStyle(color: Colors.grey),
                                    ))
                                .toList(),
                          );
                        } else {
                          return Text(
                            'No terms available.',
                            style: TextStyle(color: Colors.grey),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationFormPage(
                                  eventId: widget.activity.id,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF125593),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
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
}
