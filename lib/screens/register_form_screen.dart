import 'dart:convert';

import 'package:amgala/config/database_connection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationFormPage extends StatefulWidget {
  final int eventId;
  RegistrationFormPage({Key? key, required this.eventId}) : super(key: key);

  @override
  State<RegistrationFormPage> createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  
  String? fullName;
  DateTime? dateOfBirth;
  String? institution;
  String? whatsapp;
  String? reasons;
  String? proofFile;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateOfBirth = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  _checkIfUserAlreadyRegistered() async{

         final conn = await DatabaseConnection.getInstance().getConnection();
final existingCheck = await conn.query(
        'SELECT id FROM event_registration WHERE event_id = ? AND user_id = ?',
        [widget.eventId, userId],
      );

      if (existingCheck.isNotEmpty) {
        _showAlert(
          'Already Registered',
          'You are already registered for this event.',
          true,
        );
        return;
      }

  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final conn = await DatabaseConnection.getInstance().getConnection();
final existingCheck = await conn.query(
        'SELECT id FROM event_registration WHERE event_id = ? AND user_id = ?',
        [widget.eventId, userId],
      );

      if (existingCheck.isNotEmpty) {
        _showAlert(
          'Already Registered',
          'You are already registered for this event.',
          true,
        );
        return;
      }


        final result = await conn.query(
          'INSERT INTO event_registration (event_id, full_name, date_of_birth, institution, whatsapp, reasons, proof_file,user_id) '
          'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
          [
            widget.eventId,
            fullName,
            dateOfBirth?.toIso8601String(),
            institution,
            whatsapp,
            reasons,
           proofFile,
           userId
          ],
        );

        // await conn.close();

        if (result.insertId != null) {
          _showAlert('Registration successful', 'You have successfully registered for the event.', true);
        } else {
          _showAlert('Error', 'Failed to register. Please try again.', false);
        }
      } catch (e) {
        _showAlert('Error', 'An error occurred: $e', false);
      }
    }
  }

  void _showAlert(String title, String message, bool success) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (success) {
                Navigator.popUntil(context, (route) => route.isFirst); // Go to home screen
              } else {
                Navigator.pop(context); // Close alert
              }
            },
            child: Text(success ? 'OK' : 'Try Again'),
          ),
        ],
      ),
    );
  }

   String? userEmail;
  String? username;
  String? fullname;
  String? image;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkIfUserAlreadyRegistered();
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
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Registration Form',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 80,
                  ),
                ),
                const SizedBox(height: 24),

                // Form Fields
                _buildLabel('Fullname *'),
                _buildTextField(
                  hint: 'Enter your full name',
                  onChanged: (value) => fullName = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter your full name' : null,
                ),

                _buildLabel('Date of Birth *'),
                _buildDateField(),

                _buildLabel('Institution *'),
                _buildTextField(
                  hint: 'Enter your institution',
                  onChanged: (value) => institution = value,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter your institution' : null,
                ),

                _buildLabel('No. WhatsApp *'),
                _buildTextField(
                  hint: 'Enter your WhatsApp number',
                  onChanged: (value) => whatsapp = value,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter your WhatsApp number' : null,
                ),

                _buildLabel('Reasons for taking part in this volunteer activity *'),
                _buildTextField(
                  hint: 'Enter your reasons',
                  onChanged: (value) => reasons = value,
                  maxLines: 3,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter your reasons' : null,
                ),

                _buildLabel('Proof of following Amgala\'s Instagram *'),
                _buildUploadButton(),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF1565C0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1565C0)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        hintText: 'Select your date of birth',
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1565C0)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: (value) => dateOfBirth == null ? 'Please select your date of birth' : null,
    );
  }

Widget _buildUploadButton() {
  return TextFormField(
    decoration: InputDecoration(
      hintText: 'Enter the image link',
      hintStyle: TextStyle(color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1565C0)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    onChanged: (value) => proofFile = value,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the image link';
      }
      final urlPattern =
          r'^(http|https):\/\/[^ "]+$';
      if (!RegExp(urlPattern).hasMatch(value)) {
        return 'Please enter a valid URL';
      }
      return null;
    },
    keyboardType: TextInputType.url,
  );
}
}
