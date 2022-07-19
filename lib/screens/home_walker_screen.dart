import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';

import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../services/services.dart';

class HomeWalkerScreen extends StatelessWidget {
  static String routeName = 'walkers';
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);
    final serviceProv = Provider.of<CreateWSService>(context);
    final services = serviceProv.loadWalkerServicesId('IDW1');

    return Scaffold(
      appBar: AppBar(
        title: Text('Servicio de [Paseador]'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (_, int index) => WalkCard(petService: services[index]),
        itemCount: services.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          serviceProv.selectedService = PetService(
            address: "",
            idFrequency: '',
            idPet: '',
            isGroup: false,
            minutes: 30,
            qualification: 5,
          ),
          Navigator.pushNamed(context, CreateServiceScreen.routeName),
        },
      ),
    );
  }
}
