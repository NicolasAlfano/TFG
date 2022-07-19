import 'package:flutter/material.dart';
import 'package:productos_app/ui/input_time.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/providers/providers.dart';
import 'package:productos_app/search/search.dart';

import 'package:productos_app/ui/input_decorations.dart';

import '../helper/helper.dart';
import '../models/models.dart';
import '../services/services.dart';

class CreateServiceScreen extends StatelessWidget {
  static String routeName = 'create_service';
  @override
  Widget build(BuildContext context) {
    final service = Provider.of<CreateWSService>(context);

    return ChangeNotifierProvider(
        create: (_) => ServiceFormProvider(service.selectedService!),
        child: _ServiceScreenBody(service: service));
  }
}

class _ServiceScreenBody extends StatelessWidget {
  const _ServiceScreenBody({
    Key? key,
    required this.service,
  }) : super(key: key);

  final CreateWSService service;

  @override
  Widget build(BuildContext context) {
    final servForm = Provider.of<ServiceFormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Alta Servicio'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          _ServiceForm(),
          SizedBox(
            height: 200,
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          child: service.isSaving
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Icon(Icons.save_outlined),
          onPressed: service.isSaving
              ? null
              : () async {
                  if (!servForm.isValidForm()) return;

                  // final String? imageUrl = await service.uploadImage();
                  // if (imageUrl != null) {
                  //   petForm.pet.photo = imageUrl;
                  // }

                  await service.saveOrCreateService(servForm.petService);

                  // Navigator.pushNamed(context, WalksScreen.routeName);
                }),
    );
  }
}

class _ServiceForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final geolocatorProvider = Provider.of<GeolocatorProvider>(context);
    final servForm = Provider.of<ServiceFormProvider>(context);
    final serv = servForm.petService;
    String zona = '';
    if (geolocatorProvider.getSelectedPlaceName() != '')
      zona = geolocatorProvider.getSelectedPlaceName();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: 670,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: servForm.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              _Zone(zona: zona),
              SizedBox(height: 20),
              Text('Tipo de paseo:',
                  style: TextStyle(color: Colors.black38, fontSize: 16)),
              DropDownServiceRide(service: serv),
              SizedBox(height: 20),
              InputTime(),
              SizedBox(
                height: 15,
              ),
              Text('Indica los dias de la semana que quieres pasear: ',
                  style: TextStyle(fontSize: 15.8, color: Colors.black45)),
              SizedBox(
                height: 15,
              ),
              _BuildCheckBoxDay(),
              SizedBox(
                height: 15,
              ),
              SwitchListTile(
                  activeColor: Colors.deepPurple,
                  title: Text('Paseo en grupo',
                      style: TextStyle(color: Colors.black38, fontSize: 17)),
                  value: serv == null ? false : serv!.isGroup!,
                  onChanged: (value) => servForm.updateGroupRide(value)),
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

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item.toString()));
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
    final servForm = Provider.of<ServiceFormProvider>(context, listen: false);

    final selected = geolocatorProvider.getSelectedPlaceName();
    vicinity = geolocatorProvider.getSelectedVicinity();

    if (selected != '' && selected != zone) {
      setState(() {
        zone = selected;
        txt.text = zone;
        servForm.petService.address = zone;
        servForm.petService.vicinity = vicinity;
      });
    }
    return zone;
  }

  @override
  Widget build(BuildContext context) {
    final geolocatorProvider = Provider.of<GeolocatorProvider>(context);

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

class _BuildCheckBoxDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final servForm = Provider.of<ServiceFormProvider>(context);
    final service = servForm.petService;
    if (service!.frequency == null || service! == null) {
      service!.frequency = ServiceFrequency(
          monday: true,
          tuesday: true,
          wednesday: true,
          thursday: true,
          friday: true);
    }
    final frequency = service!.frequency;
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
