import 'dart:async';

import 'package:MusicFindApp/auth/bloc/auth_bloc.dart';
import 'package:MusicFindApp/pages/favorites.dart';
import 'package:MusicFindApp/pages/here_you_go.dart';
import 'package:MusicFindApp/providers/firebase_provider.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MusicFindApp/providers/song_identifier_provider.dart';

class Escuchar extends StatefulWidget {
  const Escuchar({
    Key? key,
  }) : super(key: key);

  @override
  State<Escuchar> createState() => _EscucharState();
}

class _EscucharState extends State<Escuchar> {
  List<String> mensajes = ["Toque para escuchar", "Escuchando"];

  @override
  Widget build(BuildContext context) {
    context.read<FirebaseDB>().getSongs();
    return Scaffold(
        body: ListView(
      children: [
        SizedBox(height: 40),
        Center(
            child: Text(
                context.watch<SongIdentifier>().getAnimacion
                    ? mensajes[1]
                    : mensajes[0],
                style: TextStyle(fontSize: 20))),
        SizedBox(height: 150),
        Center(
            child: AvatarGlow(
          animate: context.read<SongIdentifier>().getAnimacion,
          repeat: true,
          endRadius: 150.0,
          glowColor: Colors.purpleAccent,
          child: MaterialButton(
            onPressed: () async {
              context.read<SongIdentifier>().changeAnimacion();
              await context.read<SongIdentifier>().recording();
              Timer(const Duration(seconds: 8), () async {
                context.read<SongIdentifier>().changeAnimacion();
                if (context.read<SongIdentifier>().getFound) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HereYouGo()),
                  );
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text("No encontramos tu canción :c"),
                      ),
                    );
                  setState(() {});
                }
              });
            },
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/música.png"),
              radius: 80,
            ),
            padding: EdgeInsets.all(10.0),
            shape: CircleBorder(),
          ),
        )),
        SizedBox(height: 40),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Color.fromARGB(245, 245, 245, 255),
                child: IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.favorite, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Favorites()),
                    );
                  },
                  tooltip: "Ver favoritos",
                ),
              ),
              SizedBox(width: 20,),
              CircleAvatar(
                backgroundColor: Color.fromARGB(245, 245, 235, 255),
                child: IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.exit_to_app, color: Colors.black),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                  },
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
