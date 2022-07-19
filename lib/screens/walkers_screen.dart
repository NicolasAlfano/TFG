import 'package:flutter/material.dart';

import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';

import 'package:provider/provider.dart';
import 'package:productos_app/widgets/widgets.dart';

import '../models/models.dart';

class WalksScreen extends StatelessWidget {
  static String routeName = 'walks';
  @override
  Widget build(BuildContext context) {
    final petService = Provider.of<PetsService>(context);
    final walksService = Provider.of<WalkersService>(context);

    List<Walker> walkersFiltered =
        walksService.loadFilter(petService.selectedPet!.service!);

    List<PetService> serviceFiltered = [];

    walkersFiltered.forEach((walker) {
      walker.services!.forEach((service) {
        service.idPet = petService.selectedPet!.service!.idPet;
        serviceFiltered.add(service);
      });
    });

    if (walksService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Prestadores'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (_, int index) =>
            ServiceCard(service: serviceFiltered[index]),
        itemCount: serviceFiltered.length,
      ),
    );
  }
}
