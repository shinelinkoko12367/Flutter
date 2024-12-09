// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_bloc_crud/UserScreen.dart';
import 'package:map_bloc_crud/bloc/User/data_bloc.dart';
import 'package:map_bloc_crud/bloc/User/data_event.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => DataBloc()..add(FetchData()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserPage(),
    );
  }
}
