import 'package:MusicFindApp/auth/bloc/auth_bloc.dart';
import 'package:MusicFindApp/pages/escuchar.dart';
import 'package:MusicFindApp/pages/login.dart';
import 'package:MusicFindApp/providers/firebase_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/song_identifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(VerifyAuthEvent()),
        ),
      ],
      child:  MultiProvider(
        providers: [
            ChangeNotifierProvider<SongIdentifier>(create: (_) => SongIdentifier()),
            ChangeNotifierProvider<FirebaseDB>(create: (_) => FirebaseDB()),
        ],
        child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicFindApp ',
      theme: new ThemeData.dark(),
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Favor de autenticarse"),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return Escuchar();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState) {
            return LoginPage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}