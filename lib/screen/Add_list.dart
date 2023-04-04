import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:school_record_address/Helper/location_helper.dart';
import 'package:school_record_address/model/student_data.dart';
import 'package:school_record_address/provider/student_provider.dart';
import 'package:location/location.dart';
import 'package:school_record_address/screen/School_list.dart';
import 'package:school_record_address/screen/category_screen.dart';
import 'package:school_record_address/screen/map_screen.dart';
import 'package:school_record_address/widget/home_page.dart';

class AddList extends StatefulWidget {
  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final List<String> _item = ['SS1', 'SSS2', 'SS3'];

  File? _storedImage;
  PlaceLocation? _pickedLocation;
  

  String? dropDownValue;
  final _texfController = TextEditingController();

  @override
  void initState() {
    dropDownValue = _item.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(width: 1)),
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _texfController,
                decoration: const InputDecoration(
                  label: Text('Enter Student Name'),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),

            //value field for input
            DropdownButtonFormField(
                value: dropDownValue,
                items: _item.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Text(value),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    dropDownValue = value as String?;
                  });
                }),
            SizedBox(
              height: 15,
            ),

            //to add image container and button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      color: Color.fromARGB(255, 238, 237, 237)),
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: _storedImage != null
                      ? Image.file(
                          _storedImage!,
                          fit: BoxFit.cover,
                        )
                      : const Text('No Image Yet'),
                ),

                //to take picture from camera and gallery
                TextButton.icon(
                  onPressed: _takeImage,
                  icon: Icon(Icons.camera),
                  label: Text('TakePicture'),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              color: Color.fromARGB(255, 207, 206, 206),
              height: 200,
              width: double.infinity,
              margin: EdgeInsets.all(8),
              child: _mapImagePreview == null
                  ? Text('Select your Location On The Map')
                  : Image.network(_mapImagePreview!),
            ),
            SizedBox(
              height: 20,
            ),

            //to add map
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //to get backgound map on container
                InkWell(
                  onTap: _addBackgroundMap,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: const Text(
                      'Add Map',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                //code to get current location from map
                InkWell(
                  onTap: _getExactUserMapLocatn,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                    ),
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      'Get Location On Map',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: () => _saveInput(),
              child: Container(
                alignment: Alignment.center,
                color: Colors.amber,
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Text(
                  'Add Student',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //function to take picture controller
  Future<void> _takeImage() async {
    final _picker = ImagePicker();
    //showDialog(context: context, builder: builder);
    try {
      //picking the image from the gallery
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('You Are About To Take Image'),
          title: Text('Select How You Wish To Get Image'),
          actions: [
            TextButton.icon(
              onPressed: () async {
                final imagePicked = await _picker.pickImage(
                    source: ImageSource.camera, maxWidth: 600);
                Navigator.of(context).pop();
                if (imagePicked == null) {
                  return;
                }
                setState(() {
                  _storedImage = File(imagePicked.path);
                });
              },
              icon: const Icon(Icons.camera),
              label: const Text('Camera'),
            ),
            TextButton.icon(
              onPressed: () async {
                final imagePicked = await _picker.pickImage(
                    source: ImageSource.gallery, maxWidth: 600);
                Navigator.of(context).pop();
                if (imagePicked == null) {
                  return;
                }
                setState(() {
                  _storedImage = File(imagePicked.path);
                });
              },
              icon: const Icon(Icons.browse_gallery),
              label: const Text('Galery'),
            ),
          ],
        ),
      );

      //print('this ia it : ${_storedImage}');
    } catch (e) {
      throw e;
    }
  }

//to Save image and Input
  void _saveInput() {
    if (_storedImage == null ||
        dropDownValue == null ||
        _texfController.text.isEmpty ||
        _pickedLocation == null
        ) {
      showDialog(
        context: context,
        builder: (cxt) => AlertDialog(
          content: Text('Kindly enter all the field'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK')),
          ],
        ),
      );

      return;
    }
   try{
    Provider.of<StudentProvider>(context, listen: false).addStudent(
      dropDownValue!,
      _texfController.text,
      _storedImage!,
      _pickedLocation!,
   
    );
   }catch(error){
    throw error;
   }
    
    Navigator.of(context).pop();
    
  }

//Add map to the background

  String? _mapImagePreview;

//to take value and preview it on the contianer

  void _showPreview(double lat, double lng) {
    final staticMap = LocationHelper.generateLocation(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _mapImagePreview = staticMap;
    });
  }

//gives value for background map, not current location
  Future<void> _addBackgroundMap() async {
    final locationGetNow = await Location().getLocation();
    _showPreview(locationGetNow.latitude!, locationGetNow.longitude!);
  
  }



  //to get value from the map that was gotten back from map open for real time user location
  Future<void> _getExactUserMapLocatn() async {
    final mapLocate = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (mapLocate == null) {
      return;
    }
    _showPreview(
      mapLocate.latitude,
      mapLocate.longitude,
    );

    _pickedLocation = PlaceLocation(
      latitude: mapLocate.latitude,
      longitude: mapLocate.longitude,
    );
  }
}
