//clase encargada de hacer las peticiones http

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class WalkersService extends ChangeNotifier {
  final String _baseUrl = 'buckswalkers-db-default-rtdb.firebaseio.com';

  final List<Walker> walkers = [];
  final List<WalkerService> walkersServices = [];
  final List<PetService> services = [];
  final List<ServiceFrequency> frequencies = [];
  final List<Person> persons = [];

  File? newPictureFile;
  bool isLoading = true;
  bool isSaving = false;

  Walker? selectedWalker;

  WalkersService() {
    this.loadWalkers();
    this.loadWalkersServices();
    this.loadServices();
    this.loadServiceFrequency();
    this.loadPersons();
    // this.loadFilter(this.servicePreference);
  }
  int totalService = 0;
  List<Walker> loadFilter(PetService servicePreference) {
//obtengo los paseadores que cumplan con la calification
    List<Walker> walkersQualification = walkers
        .where((element) =>
            element.qualification == servicePreference.qualification)
        .toList();

//obtengo id de los servicios que cumplen con la calificacion
    List<WalkerService> wServices = [];
    walkersQualification.forEach((wq) {
      wServices = walkersServices.where((ws) => ws.idWalkers == wq.id).toList();
    });

    for (var i = 0; i < wServices.length; i++) {
      for (var j = 0; j < walkersQualification.length; j++) {
        //si el id del servicio se corresponde con el paseador entonces...
        if (wServices[i].idWalkers == walkersQualification[j].id) {
          //busco el/los servici2o y lo inserto en el paseador

          PetService newServ = services
              .where((serv) => serv.id == wServices[i].idServices)
              .single;

          var frequency =
              frequencies.where((freq) => newServ.id == freq.idService).first;
          newServ.frequency = frequency;

          walkersQualification[j].services = [];
          walkersQualification[j].services!.add(newServ);
          totalService += 1;
        }
      }
    }

    //aplico filtros del service preference a los servicios de paseadores filtrados
    List<Walker> walkersFiltered = [];
    for (var j = 0; j < walkersQualification.length; j++) {
      //si tiene servicios entonces...
      if (walkersQualification[j].services != null) {
        for (var i = 0; i < walkersQualification[j].services!.length; i++) {
          if ((walkersQualification[j].services![i].vicinity ==
                  servicePreference.vicinity) &&
              ((walkersQualification[j].services![i].isGroup ==
                  servicePreference.isGroup))) {
            //TODO: agregar el resto de los filtros y corroborar que este llegando el objeto completo, y agregar busqueda de frequenia
            walkersFiltered.add(walkersQualification[j]);
          }
        }
      }
    }

    walkersFiltered.forEach((wf) {
      wf.services!.forEach((serv) {
        var pers =
            this.persons.where((person) => person.id == wf.idPersons).single;
        serv.nameWalker = pers.name;
      });
    });

    return walkersFiltered;
  }

  Future<List<Person>> loadPersons() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'persons.json');
    final resp = await http.get(url);

    final Map<String, dynamic> personsMap = json.decode(resp.body);

    personsMap.forEach((key, value) {
      final tempPerson = Person.fromMap(value);
      tempPerson.id = key;
      this.persons.add(tempPerson);
    });

    this.isLoading = false;
    notifyListeners();

    return this.persons;
  }

  Future<List<Walker>> loadWalkers() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'walkers.json');
    final resp = await http.get(url);

    final Map<String, dynamic> walkersMap = json.decode(resp.body);

    walkersMap.forEach((key, value) {
      final tempWalker = Walker.fromMap(value);
      tempWalker.id = key;
      this.walkers.add(tempWalker);
    });

    this.isLoading = false;
    notifyListeners();

    return this.walkers;
  }

  Future<List<WalkerService>> loadWalkersServices() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'walkers_services.json');
    final resp = await http.get(url);

    final Map<String, dynamic> walkersServicesMap = json.decode(resp.body);

    walkersServicesMap.forEach((key, value) {
      final tempWalkerService = WalkerService.fromMap(value);
      // tempWalkerService.idServices = key;
      this.walkersServices.add(tempWalkerService);
    });

    this.isLoading = false;
    notifyListeners();

    return this.walkersServices;
  }

  Future<List<PetService>> loadServices() async {
    this.isLoading = true;

    final url = Uri.https(_baseUrl, 'Service.json');
    final resp = await http.get(url);

    final Map<String, dynamic> servicesMap = json.decode(resp.body);

    servicesMap.forEach((key, value) {
      final tempService = PetService.fromMap(value);
      tempService.id = key;
      this.services.add(tempService);
    });

    this.isLoading = false;

    return this.services;
  }

  Future<List<ServiceFrequency>> loadServiceFrequency() async {
    this.isLoading = true;

    final url = Uri.https(_baseUrl, 'service_frequency.json');
    final resp = await http.get(url);

    final Map<String, dynamic> frequencyMap = json.decode(resp.body);

    frequencyMap.forEach((key, value) {
      final tempFrequency = ServiceFrequency.fromMap(value);
      tempFrequency.id = key;
      this.frequencies.add(tempFrequency);
    });

    this.isLoading = false;

    return this.frequencies;
  }
}
