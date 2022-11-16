import 'package:MusicFindApp/pages/here_you_go.dart';
import 'package:MusicFindApp/providers/firebase_provider.dart';
import 'package:MusicFindApp/providers/song_identifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteItem extends StatelessWidget {
  final dynamic song;
  const FavoriteItem({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        height: 325,
        width: 300,
        child: MaterialButton(
          onPressed: () {
            context.read<SongIdentifier>().setSelectedSong(song);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HereYouGo()));
          },
          child: Stack(children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.network(
                song["image"],
                height: 325,
                width: 300,
                alignment: Alignment.center,
              ),
            ),
            Positioned(
              top: 7,
              left: 15,
              child: IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        title: Text("Eliminar de favoritos"),
                        content: Text(
                            "¿Quieres eliminar esta canción a tus favoritos?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await context.read<FirebaseDB>().removeSong(song);
                              Navigator.of(context).pop();
                            },
                            child: Text("Eliminar"),
                          ),
                        ],
                      );
                    }),
                  );
                },
                icon: Icon(Icons.favorite, color: Colors.redAccent),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  width: 300,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(33, 149, 243, 0.452),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(children: [
                    Text(
                      "${song["title"]}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${song["artist"]}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ]),
                ))
          ]),
        ));
  }
}
