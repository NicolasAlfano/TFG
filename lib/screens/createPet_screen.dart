import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/providers/providers.dart';

import 'package:productos_app/services/services.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/helper/helper.dart';
import 'package:productos_app/widgets/widgets.dart';

import '../models/models.dart';
import '../search/search.dart';

class CreatePetScreen extends StatelessWidget {
  static String routeName = 'pet';
  Widget build(BuildContext context) {
    final petService = Provider.of<PetsService>(context);

    return ChangeNotifierProvider(
        create: (_) => PetFormProvider(petService.selectedPet!),
        child: _PetScreenBody(petService: petService));
  }
}

class _PetScreenBody extends StatelessWidget {
  const _PetScreenBody({
    Key? key,
    required this.petService,
  }) : super(key: key);

  final PetsService petService;

  @override
  Widget build(BuildContext context) {
    final petForm = Provider.of<PetFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(children: [
            Stack(
              children: [
                PetImage(url: petService.selectedPet?.photo),
                Positioned(
                    child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new,
                            size: 30, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop()),
                    top: 60,
                    left: 15),
                Positioned(
                    child: IconButton(
                        icon: Icon(Icons.camera_alt_outlined,
                            size: 30, color: Colors.white),
                        onPressed: () async {
                          final picker = ImagePicker();

                          final XFile? pickedFile = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 100);

                          if (pickedFile == null) {
                            return null;
                          }

                          petService.updatePetSelectedImage(pickedFile.path);
                        }),
                    top: 60,
                    right: 15)
              ],
            ),
            _PetForm(),
            SizedBox(
              height: 50,
            )
          ])),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          child: petService.isSaving
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Icon(Icons.save_outlined),
          onPressed: petService.isSaving
              ? null
              : () async {
                  if (!petForm.isValidForm()) return;

                  final String? imageUrl = await petService.uploadImage();
                  if (imageUrl != null) {
                    petForm.pet.photo = imageUrl;
                  }

                  await petService.saveOrCreatePet(petForm.pet);

                  Navigator.pushNamed(context, WalksScreen.routeName);
                }),
    );
  }
}

class _PetForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final geolocatorProvider = Provider.of<GeolocatorProvider>(context);
    final petForm = Provider.of<PetFormProvider>(context);
    final pet = petForm.pet;
    Duration _duration = pet.service!.duration();
    String zona = pet.service!.address;
    if (geolocatorProvider.getSelectedPlaceName() != '')
      zona = geolocatorProvider.getSelectedPlaceName();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: petForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TextFormField(
                initialValue: pet.name,
                onChanged: (value) => pet.name = value,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'El nombre es obligatorio y debe ser mayor a 3 caracteres';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre', labelText: 'Nombre de la Mascota: '),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: pet.year.toString(),
                onChanged: (value) {
                  if (int.tryParse(value) == null) {
                    pet.year = 0;
                  } else {
                    pet.year = int.parse(value);
                  }
                },
                // validator: (value) {
                //   if (value == null || value.length < 3) {
                //     return 'El nombre es obligatorio y debe ser mayor a 3 caracteres';
                //   }
                // },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Indica la edad de la mascota',
                    labelText: 'Edad: '),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: pet.breed,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Indica la raza de la mascota',
                    labelText: 'Raza: '),
                onChanged: (value) => pet.breed = value,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'El nombre es obligatorio y debe ser mayor a 3 caracteres';
                  }
                },
              ),
              SizedBox(height: 20),
              _Zone(zona: zona), // Zone
              SizedBox(height: 20),
              Text('Tipo de paseo:',
                  style: TextStyle(color: Colors.black38, fontSize: 16)),
              DropDownRide(pet: pet),
              SizedBox(height: 20),
              Text('Indica el tiempo de duración:',
                  style: TextStyle(color: Colors.black38, fontSize: 17)),
              CustomDuration(duration: _duration, pet: pet),
              // CustomDuration(),
              SizedBox(height: 20),
              Text('En que momento del dia:',
                  style: TextStyle(color: Colors.black38, fontSize: 16)),
              DropDownDay(pet: pet),
              SizedBox(height: 20),
              Text('Indica los dias de paseo de tu mascota:',
                  style: TextStyle(color: Colors.black38, fontSize: 17)),
              _BuildCheckBox(),
              SizedBox(
                height: 20,
              ),
              Text('Calificacion del paseador:',
                  style: TextStyle(color: Colors.black38, fontSize: 17)),
              Container(
                width: 200,
                height: 40,
                child: RatingBar.builder(
                  allowHalfRating: false,
                  itemCount: 5,
                  initialRating: pet.service == null
                      ? 0
                      : double.parse(pet.service!.qualification.toString()),
                  itemBuilder: (context, _) {
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  },
                  onRatingUpdate: (raiting) {
                    print(raiting);
                    pet.service!.qualification = raiting;
                  },
                ),
              ),
              SizedBox(height: 20),
              SwitchListTile(
                  activeColor: Colors.deepPurple,
                  title: Text('Paseo en grupo',
                      style: TextStyle(color: Colors.black38, fontSize: 17)),
                  value: pet.service == null ? false : pet.service!.isGroup!,
                  onChanged: (value) => petForm.updateGroupRide(value)),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.05))
          ]);

  DropdownMenuItem<String> _buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item.toString()));
}

class _BuildCheckBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petForm = Provider.of<PetFormProvider>(context);

    if (petForm.pet.service!.frequency == null ||
        petForm.pet.service! == null) {
      petForm.pet.service!.frequency = ServiceFrequency(
          monday: true,
          tuesday: true,
          wednesday: true,
          thursday: true,
          friday: true);
    }
    final frequency = petForm.pet.service!.frequency;
    return Container(
      child: Center(
        child: Column(children: [
          CustomCheckBox(
            isChecked: frequency != null ? frequency.monday : true,
            title: 'Lunes',
            day: Day.monday,
            frequency: frequency!,
          ),
          CustomCheckBox(
            isChecked: frequency != null ? frequency.tuesday : true,
            title: 'Martes',
            day: Day.tuesday,
            frequency: frequency,
          ),
          CustomCheckBox(
            isChecked: frequency != null ? frequency.wednesday : true,
            title: 'Miercoles',
            day: Day.wednesday,
            frequency: frequency,
          ),
          CustomCheckBox(
            isChecked: frequency != null ? frequency.thursday : true,
            title: 'Jueves',
            day: Day.thursday,
            frequency: frequency,
          ),
          CustomCheckBox(
            isChecked: frequency != null ? frequency.friday : true,
            title: 'Viernes',
            day: Day.friday,
            frequency: frequency,
          ),
        ]),
      ),
    );
  }
}

class _Zone extends StatefulWidget {
  const _Zone({
    Key? key,
    required this.zona,
  }) : super(key: key);

  final String zona;

  @override
  State<_Zone> createState() => _ZoneState();
}

class _ZoneState extends State<_Zone> {
  String zone = '';
  String vicinity = '';
  TextEditingController txt = TextEditingController();
  bool isNewZone = false;

  Future<String> _selectZone(BuildContext context) async {
    final geolocatorProvider =
        Provider.of<GeolocatorProvider>(context, listen: false);
    // final servForm = Provider.of<ServiceFormProvider>(context, listen: false);
    final petForm = Provider.of<PetFormProvider>(context, listen: false);

    final selected = geolocatorProvider.getSelectedPlaceName();
    vicinity = geolocatorProvider.getSelectedVicinity();

    if (selected != '' && selected != zone) {
      setState(() {
        zone = selected;
        txt.text = zone;
        petForm.pet.service!.address = zone;
        petForm.pet.service!.vicinity = vicinity;
      });
    }
    // else {
    //   setState(() {
    //     txt.text = widget.zona;
    //   });
    // }
    return zone;
  }

  @override
  Widget build(BuildContext context) {
    // final geolocatorProvider = Provider.of<GeolocatorProvider>(context);

    return isNewZone
        ? TextField(
            decoration: InputDecorations.authInputDecoration(
                hintText: 'Indica la Zona donde vas a prestar el servicio',
                labelText: 'Zona: ',
                suffixIcon: Icons.search),
            controller: txt,
            onTap: () async {
              await showSearch(
                  context: context, delegate: SearchPlacesDelegate());
              _selectZone(context);
              isNewZone = true;
            },
          )
        : TextFormField(
            readOnly: true,
            initialValue: widget.zona,
            decoration: InputDecorations.authInputDecoration(
                hintText: 'Indica la Zona donde vas a prestar el servicio',
                labelText: 'Zona: ',
                suffixIcon: Icons.search),
            onTap: () async {
              await showSearch(
                  context: context, delegate: SearchPlacesDelegate());
              _selectZone(context);
              isNewZone = true;
            },
          );
  }
}
