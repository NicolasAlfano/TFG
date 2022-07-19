import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/models.dart';

import 'package:http/http.dart' as http;

class CreateWSService extends ChangeNotifier {
  final String _baseUrl = 'buckswalkers-db-default-rtdb.firebaseio.com';
  List<PetService> services = [];
  final List<ServiceFrequency> frequencies = [];
  final List<WalkerService> walkersServices = [];

  bool isLoading = true;
  bool isSaving = false;

  PetService? selectedService;
  ServiceFrequency? selectedServiceFrequency;

  CreateWSService() {
    this.loadServices();
    this.loadWalkersServices();
    this.loadServiceFrequency();
    // this.loadWalkerServicesId('IDWS1');
  }

  List<PetService> loadWalkerServicesId(String id) {
    List<PetService> wsId = [];

    //filtros a los services con id IDWS1
    List<WalkerService> ids = [];
    this.walkersServices.forEach((ws) {
      if (ws.idWalkers == id) {
        ids.add(ws);
      }
    });
    //busco servicios y frequencias de IDWS1
    this.services.forEach((serv) {
      ids.forEach((idServ) {
        if (idServ.idServices == serv.id) {
          this.frequencies.forEach((freq) {
            if (freq.idService == serv.id) {
              serv.frequency = freq;
              wsId.add(serv);
            }
          });
        }
      });
    });

    return wsId;
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

  Future<String> updateService(PetService petService) async {
    final url = Uri.https(_baseUrl, 'Service/${petService.id}.json');
    final resp = await http.put(url, body: petService.toJson());
    final decodedDate = resp.body;

    final index =
        this.services.indexWhere((element) => petService.id == element.id);
    this.services[index] = petService;

    return petService.id!;
  }

  Future<String> updateFrequency(ServiceFrequency frequency) async {
    final url = Uri.https(_baseUrl, 'service_frequency/${frequency.id}.json');
    final resp = await http.put(url, body: frequency.toJson());
    final decodedDate = resp.body;

    final indexServicio = this
        .services
        .indexWhere((element) => frequency.idService == element.id);
    this.services[indexServicio].frequency = frequency;

    final indexFrequencies =
        this.frequencies.indexWhere((element) => frequency.id == element.id);
    this.frequencies[indexFrequencies] = frequency;

    return frequency.id!;
  }

  Future saveOrCreateService(PetService service) async {
    isSaving = true;
    notifyListeners();
    if (service.id == null) {
      await this.createService(service!);
      await this.createServiceFrequency(service!);
    }
    //TODO: update servicio
    isSaving = false;
    notifyListeners();
  }

  Future<String> createService(PetService petService) async {
    final url = Uri.https(_baseUrl, 'Service.json');
    final resp = await http.post(url, body: petService.toJson());
    final decodedDate = json.decode(resp.body);

    petService.id = decodedDate['name'];

    this.services.add(petService);
    //TO DO: obtener id walker de la sesion
    final ws = WalkerService(idServices: petService.id!, idWalkers: 'IDW1');
    createWalkerService(ws);

    return petService.id!;
  }

  createWalkerService(WalkerService walkersService) async {
    final url = Uri.https(_baseUrl, 'walkers_services.json');
    final resp = await http.post(url, body: walkersService.toJson());
    final decodedDate = json.decode(resp.body);
  }

  Future<String> createServiceFrequency(PetService petService) async {
    final frequency = petService.frequency;
    frequency!.idService = petService.id;

    final url = Uri.https(_baseUrl, 'service_frequency.json');
    final resp = await http.post(url, body: frequency.toJson());
    final decodedDate = json.decode(resp.body);

    frequency.id = decodedDate['name'];

    final index = this
        .services
        .indexWhere((element) => frequency.idService == element.id);

    this.services[index].frequency = frequency;

    this.frequencies.add(frequency);

    return frequency.id!;
  }
}
