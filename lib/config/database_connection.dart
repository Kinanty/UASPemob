import 'package:mysql1/mysql1.dart';

class DatabaseConnection {
  static DatabaseConnection? _instance;
  MySqlConnection? _connection;

  DatabaseConnection._internal();

  static DatabaseConnection getInstance() {
    _instance ??= DatabaseConnection._internal();
    return _instance!;
  }

  Future<MySqlConnection> getConnection() async {
    if (_connection == null) {
      _connection = await MySqlConnection.connect(
        ConnectionSettings(
          host: '10.10.2.62',
          // host: '192.168.56.1',
          port: 3306,
          user: 'administrator',
          db: 'amgala',
          password: 'admin123',
        ),
      );
    }
    return _connection!;
  }

  Future<void> closeConnection() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }
  }
}
