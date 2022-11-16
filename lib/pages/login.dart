import 'package:MusicFindApp/pages/escuchar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MusicFindApp/auth/bloc/auth_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage("assets/GIFs/giphy.gif"))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/música.png"),
                radius: 100,
              ),
              SizedBox(height: 200),
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MaterialButton(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FaIcon(FontAwesomeIcons.google),
                      Text(
                        "Iniciar con Google",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  color: Color(0xff33133b),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
