import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseDB with ChangeNotifier {
  List<dynamic> _favsSongsList = [];
  List<dynamic> get getFavsList => _favsSongsList;

  bool _inFavs = false;
  bool get isInFavs => _inFavs;
  
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addSong(dynamic song) async {
    try {
      db
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "favoritos": FieldValue.arrayUnion([song])
      });
      getSongs();
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> removeSong(dynamic song) async {
    try {
        db
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "favoritos": FieldValue.arrayRemove([song])
      });
      getSongs();
      notifyListeners();
    } catch(e) {
      notifyListeners();
      return;
    }
  }

    Future<void> getSongs() async {
    try {
        var user = await db
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      _favsSongsList =  user.data()!["favoritos"];
      notifyListeners();
    } catch(e) {
      notifyListeners();
      return;
    }
  }

    bool inFavs(dynamic song) {
      for(var i = 0; i < _favsSongsList.length; i++){
        if(song["tittle"] == _favsSongsList[i]["tittle"] && song["artist"] == _favsSongsList[i]["artist"] && song["release_date"] == _favsSongsList[i]["release_date"]){
          return true;
        }
      }
      return false;
  }
}
