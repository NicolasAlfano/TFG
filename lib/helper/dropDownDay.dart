import 'package:flutter/material.dart';

import '../models/models.dart';

class DropDownDay extends StatefulWidget {
  const DropDownDay({Key? key, required this.pet}) : super(key: key);
  final Pet pet;

  @override
  State<DropDownDay> createState() => _DropDownDayState();
}

class _DropDownDayState extends State<DropDownDay> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.pet.service!.day();

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
          if (newValue == "Mañana") {
            widget.pet.service!.typology = "M";
          } else {
            widget.pet.service!.typology = "T";
          }
        });
      },
      items: <String>['Mañana', 'Tarde']
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
