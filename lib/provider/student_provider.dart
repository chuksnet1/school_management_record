import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:school_record_address/Helper/db_helper.dart';
import 'package:school_record_address/Helper/location_helper.dart';
import 'package:school_record_address/model/student_data.dart';
import 'package:http/http.dart' as http;

//
//
//
//provider for category
class CategoryProvider with ChangeNotifier {
  final List<Category> _catItem = [
    Category(
      id: DateTime.now().toString(),
      name: 'SS1',
      imagename: 'assets/image/ss1.jpeg',
    ),
    Category(
      id: DateTime.now().toString(),
      name: 'SSS2',
      imagename: 'assets/image/ss2.jpeg',
    ),
    Category(
      id: DateTime.now().toString(),
      name: 'SS3',
      imagename: 'assets/image/ss3.jpeg',
    ),
  ];

  List<Category> get catItem {
    return [..._catItem];
  }
}

//
//
//
//
//provider for the student
class StudentProvider with ChangeNotifier {
  List<StudentData> _item = [];

  List<StudentData> get item {
    return [..._item];
  }

  final String authToken;
  final String userId;

  StudentProvider(
    this._item,
    this.authToken,
    this.userId,
  );


  Future<void> addStudent(String catName, String name, File image,
      PlaceLocation pickedLocation) async {
    final getAdressData = await LocationHelper.getPlaceAddress(
      pickedLocation.latitude,
      pickedLocation.longitude,
    );

    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: getAdressData);

    final newStudent = StudentData(
      id: DateTime.now().toString(),
      categoryName: catName,
      image: image,
      name: name,
      location: updatedLocation,
    );
    _item.add(newStudent);
    notifyListeners();

    //to add to database on device
    DBHelper.insert(
      'school_record',
      {
        'id': newStudent.id,
        'name': newStudent.name,
        'category': newStudent.categoryName,
        'image': newStudent.image.path,
        'loc_lat': newStudent.location!.latitude,
        'loc_lng': newStudent.location!.longitude,
        'address': newStudent.location!.address.toString(),
      },
    );
    notifyListeners();

    //to add and send and save data on server
    final url = Uri.parse(
        'https://school-record-d648a-default-rtdb.firebaseio.com/StudentRecord.json?auth=$authToken');
    await http.post(url,
        body: json.encode({
          'id': newStudent.id,
          'name': newStudent.name,
          'category': newStudent.categoryName,
          'image': newStudent.image.path,
          'loc_lat': newStudent.location!.latitude,
          'loc_lng': newStudent.location!.longitude,
          'address': newStudent.location!.address.toString(),
        }));

        notifyListeners();
  }

//
  //to fetch Data from database
  Future<void> fetchData() async {
    final getDataList = await DBHelper.getData('school_record');

    _item = getDataList
        .map((eData) => StudentData(
            id: eData['id'],
            categoryName: eData['category'],
            image: File(eData['image']),
            name: eData['name'],
            location: PlaceLocation(
                latitude: eData['loc_lat'],
                longitude: eData['loc_lng'],
                address: eData['address'])))
        .toList();

    //
    //
    //to fetch data from the server
    final url = Uri.parse(
        'https://school-record-d648a-default-rtdb.firebaseio.com/StudentRecord.json?auth=$authToken');
    final response = await http.get(url);
    final extractStuData = json.decode(response.body);

    if (extractStuData == null) {
      return;
    }
    final List<StudentData> loadedStudents = [];
    print(extractStuData);

    extractStuData.forEach(
      (studId, studData) {
        loadedStudents.add(
          StudentData(
              id: studId,
              categoryName: studData['category'],
              image: File(studData['image']),
              name: studData['name'],
              location: PlaceLocation(
                latitude: studData['loc_lat'],
                longitude: studData['loc_lng'],
                address: studData['address'],
              )),
        );
      },
    );
    _item = loadedStudents;

    notifyListeners();
  }

//getting value based on id
  StudentData finById(String id) {
    return _item.firstWhere((studId) => studId.id == id);
  }
}
