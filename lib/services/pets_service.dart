//clase encargada de hacer las peticiones http

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class PetsService extends ChangeNotifier {
  final String _baseUrl = 'buckswalkers-db-default-rtdb.firebaseio.com';
  final List<Pet> pets = [];
  List<PetService> services = [];
  final List<ServiceFrequency> frequencies = [];

  File? newPictureFile;
  bool isLoading = true;
  bool isSaving = false;

  Pet? selectedPet;
  PetService? selectedService;
  ServiceFrequency? selectedServiceFrequency;

  PetsService() {
    this.loadServiceFrequency();
    this.loadServices();
    services.forEach((serv) {
      serv.frequency = frequencies
          .where((frequency) => frequency.idService == serv.id)
          .single;
    });
    this.loadPets();
  }

  Future<List<Pet>> loadPets() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'pets.json');
    final resp = await http.get(url);

    final Map<String, dynamic> petsMap = json.decode(resp.body);

    petsMap.forEach((key, value) {
      final tempPet = Pet.fromMap(value);
      tempPet.id = key;
      this.pets.add(tempPet);
    });

    this.isLoading = false;
    notifyListeners();

    return this.pets;
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

  Future saveOrCreatePet(Pet pet) async {
    isSaving = true;
    notifyListeners();
    if (pet.id == null) {
      //es necerasrio crear
      await this.createPet(pet);
      await this.createService(pet.service!);
      await this.createServiceFrequency(pet.service!);
    } else {
      // es necesario actualizar
      await this.updatePet(pet);
      await this.updateService(pet.service!);
      await this.updateFrequency(pet.service!.frequency!);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updatePet(Pet pet) async {
    final url = Uri.https(_baseUrl, '/pets/${pet.id}.json');
    final resp = await http.put(url, body: pet.toJson());
    final decodedDate = resp.body;

    final index = this.pets.indexWhere((element) => pet.id == element.id);
    this.pets[index] = pet;

    return pet.id!;
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

  Future<String> createPet(Pet pet) async {
    final url = Uri.https(_baseUrl, '/pets.json');
    final resp = await http.post(url, body: pet.toJson());
    final decodedDate = json.decode(resp.body);
    pet.id = decodedDate['name'];
    pet.service!.idPet = pet.id!;
    this.pets.add(pet);

    return pet.id!;
  }

  Future<String> createService(PetService petService) async {
    final url = Uri.https(_baseUrl, 'Service.json');
    final resp = await http.post(url, body: petService.toJson());
    final decodedDate = json.decode(resp.body);

    petService.id = decodedDate['name'];

    this.services.add(petService);

    return petService.id!;
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

  void updatePetSelectedImage(String path) {
    this.selectedPet!.photo = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving == true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dpmte5yzt/image/upload?upload_preset=tmvqkolo');
    final imageUploadRequest = http.MultipartRequest('Post', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }
    print(resp.body);

    this.newPictureFile = null;

    final decodedData = json.decode(resp.body);

    isSaving == false;
    notifyListeners();
    return decodedData['secure_url'];
  }
}
