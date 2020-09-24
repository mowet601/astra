import 'dart:io';
import 'package:astra/models/log.dart';
import 'package:astra/resources/local_db/interface/log_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";

class SqliteMethods implements LogInterface {
  Database _db;
  String databaseName =
      "LogDB"; // change it dynamically in future for each user
  String tableName = "Call_Logs";

  // COLUMNS
  String id = "log_id";
  String callerName = "caller_name";
  String callerPic = "caller_pic";
  String receiverName = "receiver_name";
  String receiverPic = "receiver_pic";
  String callStatus = "call_status";
  String timestamp = "timestamp";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    print("db was null, now awaiting it");
    _db = await init();
    return _db;
  }

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path =
        join(dir.path, databaseName); // joins using '/' and makes it accessible
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    // Columns database should have
    String createTableQuery =
        "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timestamp TEXT)";

    await db.execute(createTableQuery);
    print("table created!");
  }

  @override
  addLogs(Log log) async {
    var dbClient = await db;
    await dbClient.insert(tableName, log.toMap(log));
  }

  @override
  deleteLogs(int logId) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: '$id = ?', whereArgs: [logId]);
  }

  updateLogs(Log log) async {
    var dbClient = await db;
    await dbClient.update(
      tableName,
      log.toMap(log),
      where: '$id = ?',
      whereArgs: [log.logId],
    );
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var dbClient = await db;

      List<Map> maps = await dbClient.query(
        tableName,
        columns: [
          id,
          callerName,
          callerPic,
          receiverName,
          receiverPic,
          callStatus,
          timestamp,
        ],
      );

      List<Log> logList = [];

      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(Log.fromMap(map));
        }
      }

      return logList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // not necessary -> db does it for us
  @override
  close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
