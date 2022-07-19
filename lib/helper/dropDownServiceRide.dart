import 'package:flutter/material.dart';

import '../models/models.dart';

class DropDownServiceRide extends StatefulWidget {
  const DropDownServiceRide({Key? key, required this.service})
      : super(key: key);
  final PetService service;

  @override
  State<DropDownServiceRide> createState() => _DropDownServiceRideState();
}

class _DropDownServiceRideState extends State<DropDownServiceRide> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.service!.ride();

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
            widget.service!.rideType = "M";
          } else if (newValue == "Libre") {
            widget.service!.rideType = "L";
          } else {
            widget.service!.rideType = "C";
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
