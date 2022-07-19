import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class CustomDuration extends StatefulWidget {
  CustomDuration({Key? key, required this.duration, required this.pet})
      : super(key: key);
  final Duration duration;
  final Pet pet;

  @override
  State<CustomDuration> createState() => _DuracionState();
}

class _DuracionState extends State<CustomDuration> {
  Duration _duration = Duration();

  @override
  Widget build(BuildContext context) {
    _duration = widget.pet.service!.duration();
    return Center(
      child: DurationPicker(
        duration: _duration,
        onChange: (val) {
          setState(() => widget.pet.service!.minutes = val.inMinutes);
        },
        snapToMins: 30.0,
        baseUnit: BaseUnit.minute,
      ),
    );
  }
}
