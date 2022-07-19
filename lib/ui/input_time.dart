import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import 'input_decorations.dart';

class InputTime extends StatefulWidget {
  const InputTime({
    Key? key,
  }) : super(key: key);

  @override
  State<InputTime> createState() => _InputTimeState();
}

class _InputTimeState extends State<InputTime> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTimeStart = TimeOfDay.now();
  TimeOfDay selectedTimeEnd = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTimeStart = false;
  bool showTimeEnd = false;
  bool showDateTime = false;
  TextEditingController txtStart = TextEditingController();
  TextEditingController txtEnd = TextEditingController();

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  Duration _selectDuration() {
    var inicio = getTimeStart(selectedTimeStart);
    var fin = getTimeStart(selectedTimeEnd);

    String inicioLimpio = '';
    // final inicio = "19/56565-D4";
    if (inicio.toString().contains('PM')) {
      inicioLimpio = inicio.toString().replaceAll("PM", "").replaceAll(" ", "");
    } else {
      inicioLimpio = inicio.toString().replaceAll("AM", "").replaceAll(" ", "");
    }

    String finLimpio = '';
    // final inicio = "19/56565-D4";
    if (inicio.toString().contains('PM')) {
      finLimpio = fin.toString().replaceAll("PM", "").replaceAll(" ", "");
    } else {
      finLimpio = fin.toString().replaceAll("AM", "").replaceAll(" ", "");
    }
    String fechaInicio = '1969-07-20 0' + inicioLimpio.toString() + ':00Z';
    String fechaFin = '1969-07-20 0' + finLimpio.toString() + ':00Z';

    DateTime start = DateTime.parse(fechaInicio);
    DateTime end = DateTime.parse(fechaFin);

    Duration tiempo = end.difference(start);
    return tiempo;
  }

// Select for Time
  Future<TimeOfDay> _selectTimeStart(BuildContext context) async {
    final servForm = Provider.of<ServiceFormProvider>(context, listen: false);

    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTimeStart,
    );
    if (selected != null && selected != selectedTimeStart) {
      setState(() {
        selectedTimeStart = selected;
        txtStart.text = getTimeStart(selectedTimeStart);
        servForm.petService.startTime = getTimeStart(selectedTimeStart);
        final duration = _selectDuration();
        servForm.petService.minutes = duration.inMinutes;
      });
    }
    return selectedTimeStart;
  }

  Future<TimeOfDay> _selectTimeEnd(BuildContext context) async {
    final servForm = Provider.of<ServiceFormProvider>(context, listen: false);

    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTimeEnd,
    );
    if (selected != null && selected != selectedTimeEnd) {
      setState(() {
        selectedTimeEnd = selected;
        txtEnd.text = getTimeEnd(selectedTimeEnd);
        servForm.petService.endTime = getTimeEnd(selectedTimeEnd);
        final duration = _selectDuration();
        servForm.petService.minutes = duration.inMinutes;
      });
    }
    return selectedTimeEnd;
  }
  // select date time picker

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    if (date == null) return;

    final time = await _selectTimeStart(context);

    if (time == null) return;
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String getDate() {
    // ignore: unnecessary_null_comparison
    if (selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('MMM d, yyyy').format(selectedDate);
    }
  }

  String getDateTime() {
    // ignore: unnecessary_null_comparison
    if (dateTime == null) {
      return 'select date timer';
    } else {
      return DateFormat('yyyy-MM-dd HH: ss a').format(dateTime);
    }
  }

  String getTimeStart(TimeOfDay tod) {
    final now = DateTime.now();

    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  String getTimeEnd(TimeOfDay tod) {
    final now = DateTime.now();

    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    // final txt = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //TODO: validation y deduccion de si es por la tarde o por la mañana
        Container(
          width: double.infinity,
          child: showTimeStart != false
              ? TextField(
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Indique el horario',
                      labelText: 'Horario Inicio',
                      suffixIcon: Icons.more_time),
                  controller: txtStart,
                  readOnly: true,
                  onTap: () async {
                    await _selectTimeStart(context);
                    showTimeStart = true;
                  })
              : TextFormField(
                  readOnly: true,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Indique el horario',
                      labelText: 'Horario Inicio',
                      suffixIcon: Icons.more_time),
                  onTap: () async {
                    await _selectTimeStart(context);
                    showTimeStart = true;
                  },
                ),
        ),
        Container(
          width: double.infinity,
          child: showTimeEnd != false
              ? TextField(
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Indique el horario',
                      labelText: 'Horario Fin',
                      suffixIcon: Icons.more_time),
                  controller: txtEnd,
                  readOnly: true,
                  onTap: () async {
                    await _selectTimeEnd(context);
                    showTimeEnd = true;
                  })
              : TextFormField(
                  readOnly: true,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Indique el horario',
                      labelText: 'Horario Fin',
                      suffixIcon: Icons.more_time),
                  onTap: () async {
                    await _selectTimeEnd(context);
                    showTimeEnd = true;
                  },
                ),
        ),
      ],
    );
  }
}
