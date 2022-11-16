import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:MusicFindApp/repository/MusicRepository.dart';

class SongIdentifier with ChangeNotifier {
  AudDAPIRepository apiRepo = new AudDAPIRepository();
  final List<dynamic> _songsList = [];
  List<dynamic> get getSongsList => _songsList;

  dynamic _selectedSong = null;
  dynamic get getSelectedSong => _selectedSong;

  bool _animacion = false;
  bool get getAnimacion => _animacion;

  bool _found = false;
  bool get getFound => _found;

  Record _audio = Record();

  void notFound() {
    _found = false;
    notifyListeners();
  }

  void changeAnimacion() {
    _animacion = !_animacion;
    notifyListeners();
  }

  void setSelectedSong(dynamic song) {
    _selectedSong = song;
    notifyListeners();
  }

  void noSelectedSong() {
    _selectedSong = null;
    notifyListeners();
  }

  Future<dynamic> recording() async {
    Directory? dir = await getTemporaryDirectory();
    if (await _audio.hasPermission()) {
      await _audio.start(
        path: '${dir.path}/maybeASong.m4a',
      );
    }

    bool isRecording = await _audio.isRecording();
    if (isRecording) {
      Timer(Duration(seconds: 6), () async {
        String? filePath = await _audio.stop();
        File audioFile = File(filePath!);
        Uint8List audioBytes = audioFile.readAsBytesSync();
        String audioBinary = base64Encode(audioBytes);
        var response = await apiRepo.postToAudd(audioBinary);
        if (response.statusCode == 200) {
          try {
            var res = jsonDecode(response.body)["result"];
            setSelectedSong({
              "image": res["spotify"]["album"]["images"][0]["url"],
              "title": res["title"],
              "album": res["apple_music"]["albumName"],
              "artist": res["artist"],
              "release_date": res["release_date"],
              "spotify": res["spotify"]["external_urls"]["spotify"],
              "podcast": res["song_link"],
              "apple_music": res["apple_music"]["url"]
            });
            _found = true;
            notifyListeners();
          } catch (e) {
            return;
          }
        }
      });
    }
  }
}
