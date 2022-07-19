import 'package:flutter/material.dart';

import '../models/models.dart';

class PetFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Pet pet;

  PetFormProvider(this.pet); //pet tiene que ser una copia

  updateGroupRide(bool value) {
    pet.service!.isGroup = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
