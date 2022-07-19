import 'package:flutter/material.dart';

import '../models/models.dart';

class ServiceFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  PetService petService;

  ServiceFormProvider(this.petService); //petService tienen que ser una copia

  updateGroupRide(bool value) {
    petService.isGroup = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
