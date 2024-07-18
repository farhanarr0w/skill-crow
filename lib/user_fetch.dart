import 'package:mongo_dart/mongo_dart.dart';
import 'package:project_skillcrow/server.dart';

class fetching {
  // static var chatdataget;
  //
  // static List<Map<String, dynamic>> chatData = [
  //   {'data': 'd 1'},
  //   {'data': 'd 2'},
  //   {'data': 'd 3'},
  // ];
  //
  // List<Map<String, dynamic>> getchatinfo() {
  //   return chatData;
  // }
  //
  // static Future<List<Map<String, dynamic>>> getChatDataBySession(
  //     String session) async {
  //   final db = await Db.create(MONGO_URL);
  //   await db.open();
  //   print("Fetching chat data by session from DB");
  //
  //   final collection = db.collection(CHAT_COLLECTION);
  //
  //   final query = where.eq('Session', session);
  //   final cursor = await collection.findOne(query);
  //   print("Fetching chat data by session complete");
  //   chatdataget = cursor;
  //
  //   await db.close();
  //
  //   return chatData;
  // }
  //
  // static Future<List<Map<String, dynamic>>> getChatDataByFreelancer(
  //     String freelancername) async {
  //   final db = await Db.create(MONGO_URL);
  //   await db.open();
  //   print("Fetching chat data by session from DB");
  //
  //   final collection = db.collection(CHAT_COLLECTION);
  //
  //   final query = where.eq('FreelancerName', freelancername);
  //   final cursor = await collection.find(query);
  //   print("Fetching chat data by session complete");
  //   chatdataget = await cursor.toList();
  //
  //   await db.close();
  //
  //   return chatData;
  // }
}
