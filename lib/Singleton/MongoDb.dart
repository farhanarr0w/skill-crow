// import 'dart:async';

// import 'package:mongo_dart/mongo_dart.dart';

// const MONGO_URL =
//     "mongodb+srv://admin:abc123ef@cluster0.hq1ekox.mongodb.net/SkillCrow?retryWrites=true&w=majority";

// class MongoDb {
//   static final MongoDb _instance = MongoDb._internal();
//   static Db? _mongoDb;

//   // Private constructor
//   MongoDb._internal();

//   factory MongoDb() {
//     return _instance;
//   }

//   static Future<Db> getInstance() async {

//     if(!_mongoDb!.isConnected){
//       _mongoDb ??= await Db.create(MONGO_URL) as Db?;
//       _mongoDb!.open();
//     }
//     return _mongoDb!;
//   }
// }

// // void main() async {
// //   var dbInstance = MongoDb().getInstance();
// //   await dbInstance.open();
// //   print('Connected to the database');
// // }
