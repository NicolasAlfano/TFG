import 'package:mysql1/mysql1.dart';

class DataBase{

  static String host = 'localhost';
  static String user = 'root';
  static String pass = '24deJuniode1978.';
  static String db = 'localhost';
  static int port = 3306;

  DataBase();

  Future<MySqlConnection> getConnection() async{

    var settings = new ConnectionSettings(
      host: host,
      user: user,
      password: pass,
      db: db,
      port: port
    );
    return await MySqlConnection.connect(settings);
  }
}