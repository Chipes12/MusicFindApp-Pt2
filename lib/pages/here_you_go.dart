import 'package:MusicFindApp/pages/escuchar.dart';
import 'package:MusicFindApp/providers/firebase_provider.dart';
import 'package:MusicFindApp/providers/song_identifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HereYouGo extends StatelessWidget {
  const HereYouGo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(96, 62, 62, 66),
          title: Text("Here you go"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.read<SongIdentifier>().noSelectedSong();
              context.read<SongIdentifier>().notFound();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Escuchar()),
              );
            },
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    if (context.read<FirebaseDB>().inFavs(
                        context.read<SongIdentifier>().getSelectedSong)) {
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
                                  await context.read<FirebaseDB>().removeSong(
                                      context
                                          .read<SongIdentifier>()
                                          .getSelectedSong);
                                  Navigator.of(context).pop();
                                },
                                child: Text("Eliminar"),
                              ),
                            ],
                          );
                        }),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            title: Text("Agregar a favoritos"),
                            content: Text(
                                "¿Quieres agregar esta canción a tus favoritos?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await context.read<FirebaseDB>().addSong(
                                      context
                                          .read<SongIdentifier>()
                                          .getSelectedSong);
                                  Navigator.of(context).pop();
                                },
                                child: Text("Añadir"),
                              ),
                            ],
                          );
                        }),
                      );
                    }
                  },
                  child: Icon(Icons.favorite,
                      color: context.watch<FirebaseDB>().inFavs(
                              context.read<SongIdentifier>().getSelectedSong)
                          ? Colors.redAccent
                          : Colors.white),
                )),
          ],
        ),
        body: ListView(
          children: [
            Image.network(
                "${context.read<SongIdentifier>().getSelectedSong["image"]}"),
            SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Text(
                    "${context.read<SongIdentifier>().getSelectedSong["title"]}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${context.read<SongIdentifier>().getSelectedSong["album"]}",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${context.read<SongIdentifier>().getSelectedSong["artist"]}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]),
                  ),
                  Text(
                    "${context.read<SongIdentifier>().getSelectedSong["release_date"]}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]),
                  ),
                  Divider(
                    color: Colors.grey[900],
                  ),
                  Text("Abrir con:"),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            launchUrl(Uri.parse(
                                "${context.read<SongIdentifier>().getSelectedSong["spotify"]}"));
                          },
                          icon: FaIcon(FontAwesomeIcons.spotify),
                          iconSize: 50,
                          tooltip: "Ver en Spotify",
                        ),
                        IconButton(
                          onPressed: () {
                            launchUrl(Uri.parse(
                                "${context.read<SongIdentifier>().getSelectedSong["podcast"]}"));
                          },
                          icon: FaIcon(FontAwesomeIcons.podcast),
                          iconSize: 50,
                          tooltip: "Ver en podcast",
                        ),
                        IconButton(
                          onPressed: () {
                            launchUrl(Uri.parse(
                                "${context.read<SongIdentifier>().getSelectedSong["apple_music"]}"));
                          },
                          icon: FaIcon(FontAwesomeIcons.apple),
                          iconSize: 50,
                          tooltip: "Ver en Apple music",
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
