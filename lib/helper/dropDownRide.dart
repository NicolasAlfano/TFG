import 'package:flutter/material.dart';

import '../models/models.dart';

class DropDownRide extends StatefulWidget {
  const DropDownRide({Key? key, required this.pet}) : super(key: key);
  final Pet pet;

  @override
  State<DropDownRide> createState() => _DropDownRideState();
}

class _DropDownRideState extends State<DropDownRide> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.pet.service!.ride();

    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 17),
      underline: Container(
        height: 1,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          this.dropdownValue = newValue!;
          if (newValue == "Mixto") {
            widget.pet.service!.rideType = "M";
          } else if (newValue == "Libre") {
            widget.pet.service!.rideType = "L";
          } else {
            widget.pet.service!.rideType = "C";
          }
        });
      },
      items: <String>['Mixto', 'Libre', 'Con Correa']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

// Implementar en donde se intancie la clase
  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item.toString()));
}
