import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  /// make singelton to avoid instanse creation again and again
  /// first make default constructor private
  //
  static const TABLE_NAME = 'note';
  static const Col_SRNO = 'sr_no';
  static const Col_TITLE = 'title';
  static const Col_DESC = 'desc';

  DbHelper._();

  static final DbHelper getInstanse = DbHelper._();

  Database? myDb; // variable of database get from sqflte
  // open db (open if exist else create db)

  Future<Database> getDb() async {
    if (myDb != null) {
      return myDb!;
    } else {
      myDb = await openDb();
      return myDb!;
    }
  }

  Future<Database> openDb() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path + 'noteDB.db');

    return openDatabase(dbPath, onCreate: (db, version) {
      // create tables here

      db.execute(
          'create table $TABLE_NAME ( $Col_SRNO integer primary key autoincrement, $Col_TITLE text, $Col_DESC text)');
    }, version: 1);
  }

// All queries

// insertion operation
  Future<bool> addData({required String mTitle, required String mDesc}) async {
    var db = await getDb();

    var mValues = {Col_TITLE: mTitle, Col_DESC: mDesc};
    int rowsEffected = await db.insert(TABLE_NAME, mValues);
    return rowsEffected > 0;
  }

// Fetch all data
  Future<List<Map<String, dynamic>>> getAllData() async {
    var db = await getDb();
    //work as     select * from tableName
    List<Map<String, dynamic>> mData = await db.query(TABLE_NAME);
    return mData;
  }

// update data
  Future<bool> updateData(
      {required String mTitle, required String mDesc, required int sno}) async {
    var db = await getDb();

    var mValues = {Col_TITLE: mTitle, Col_DESC: mDesc};

    int rowsEffected =
        await db.update(TABLE_NAME, mValues, where: '$Col_SRNO = $sno');

    return rowsEffected > 0;
  }

// delete
  Future<bool> delete({required int id}) async {
    var db = await getDb();

    int rowEffected =
        await db.delete(TABLE_NAME, where: '$Col_SRNO = ?', whereArgs: ['$id']);

    return rowEffected > 0;
  }
}
