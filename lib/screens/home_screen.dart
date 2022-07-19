import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';

import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);
    final petService = Provider.of<PetsService>(context);

    if (userService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        //TODO: seleccionar el usuario acorde a la pantalla.
        title: Text('Mascota de ' + userService.users[1].nickName.toString()),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: petService.pets.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  var servicio = petService.services
                      .where((serv) => serv.idPet == petService.pets[index].id)
                      .single;
                  var frequency = petService.frequencies
                      .where((freq) => servicio.id == freq.idService)
                      .single;
                  petService.selectedPet =
                      petService.pets[index].copy(servicio.copy(frequency));
                  Navigator.pushNamed(context, CreatePetScreen.routeName);
                },
                child: _DogCard(pet: petService.pets[index]),
              )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          petService.selectedPet = new Pet(
              service: PetService(
                address: "",
                idFrequency: '',
                idPet: '',
                isGroup: false,
                minutes: 30,
                qualification: 5,
              ),
              breed: '',
              gender: '',
              name: '',
              photo: '',
              year: 1),
          Navigator.pushNamed(context, CreatePetScreen.routeName),
        },
      ),
    );
  }
}

class _DogCard extends StatelessWidget {
  const _DogCard({
    Key? key,
    required this.pet,
  }) : super(key: key);

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureImage(pet: pet),
        //TODO: alertas de llegada, regresando, etc
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 15),
        //   child: Container(
        //     color: Colors.yellow,
        //     width: double.infinity,
        //     height: 20,
        //     child: Text('A 10 metros'),
        //   ),
        // ),
        DogButton()
      ],
    );
  }
}
