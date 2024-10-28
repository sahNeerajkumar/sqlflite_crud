import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  DBHelper._();
  static final DBHelper getInstance = DBHelper._();
  static String TABLE_NOTE = 'note';
  static String COLUMN_NOTE_SNO = 's_no';
  static String  COLUMN_NOTE_TITLE = 'title';
  static  String COLUMN_NOTE_DESC = 'desc';
  Database? myDB;




  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
    // if (myDB != null) {
    //   return myDB!;
    // } else {
    //   myDB = await openDB();
    //   return myDB!;
    // }
  }
  Future<Database> openDB() async {
    Directory dirPath = await getApplicationDocumentsDirectory();
    String dbPath = join(dirPath.path,'noteDB.db');
    return await openDatabase(dbPath, onCreate: (db, version) {
      db.execute(
        'create table $TABLE_NOTE($COLUMN_NOTE_SNO integer primary key,$COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC INTEGER)',
      );
    }, version: 1);
  }

 Future<bool> addNote({required String title, required String desc}) async{
 var db = await getDB();
 int rowsEffect = await db.insert(
     TABLE_NOTE, {
     COLUMN_NOTE_TITLE:title,
     COLUMN_NOTE_DESC:desc
 });
 return rowsEffect>0;
}
///get insert data
Future<List<Map<String, dynamic>>> getAllNotes() async{
  var db = await getDB();
  List<Map<String,dynamic>> mData = await db.query(TABLE_NOTE, columns:[COLUMN_NOTE_TITLE,COLUMN_NOTE_DESC,COLUMN_NOTE_SNO]);
  return mData;
}

//update data
Future<bool> updateNote({required String name, required String age,required int id })async {
    var db = await getDB();
     int rowsEffected = await db.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: name,
      COLUMN_NOTE_DESC:age
    }, where:'$COLUMN_NOTE_SNO=$id');
    return rowsEffected>0;
}

//delete data
Future<bool> deleteNote({required int id}) async {
    var db = await getDB();
   int rowsEffected = await db.delete(TABLE_NOTE,where:'$COLUMN_NOTE_SNO = ?', whereArgs: ['$id']);
    return rowsEffected >0;
}




}
