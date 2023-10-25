import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/material.dart';

const MONGO_URL =
    "mongodb+srv://admin:abc123ef@cluster0.hq1ekox.mongodb.net/test?retryWrites=true&w=majority";

const COLLECTION_NAME = "people";

class Server {
  static start() async {
    final db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    final collection = db.collection(COLLECTION_NAME);
  }
}

class CrudFunc {
  static void Insert(String username, String email, String pass) async {
    final db = await Db.create(MONGO_URL);
    await db.open();
    final collection = db.collection(COLLECTION_NAME);

    await collection
        .insertOne({"username": username, "email": email, "password": pass});
    print("Data Inserted!!!");
    await db.close();
  }

  static Future<bool> LoginUser(String username, String pass) async {
    final db = await Db.create(MONGO_URL);
    await db.open();
    final collection = db.collection(COLLECTION_NAME);

    final uf = await collection.findOne(where.eq('username', username));
    print(uf);
    await db.close();

    if (uf != null && uf['password'] == pass) {
      print("s1");
      return Future.value(true);
    } else {
      print("s3");
      return Future.value(false);
    }
  }
}
