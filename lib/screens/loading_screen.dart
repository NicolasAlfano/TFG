import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cargando Mascotas . . .'),
      ),
      body: Center(
        child: CircularProgressIndicator(color: Colors.deepPurple,),
      ),
    );
  }
}