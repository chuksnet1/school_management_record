import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_record_address/provider/student_provider.dart';
import 'package:school_record_address/screen/map_screen.dart';


class DEtailStudentList extends StatelessWidget {
  static const routeName = 'detail-student';
  const DEtailStudentList({super.key});

  @override
  Widget build(BuildContext context) {
    final studId = ModalRoute.of(context)!.settings.arguments;
    final studData = Provider.of<StudentProvider>(context, listen: false).finById(studId.toString());
    return Scaffold(
      appBar: AppBar(title: Text(studData.name.toString()),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: ClipRRect(child: Image.file(studData.image, fit: BoxFit.cover,),),
        ),
        const SizedBox(height: 20,),
         Padding(
          padding:  EdgeInsets.all(8.0),
          child: Text('Student Name:  ${studData.name}'),
        ),
         Padding(
          padding:  EdgeInsets.all(8.0),
          child: Text('Address:  ${studData.location!.address}'),
        ),
        Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(border: Border.all(width: 1)),
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: MapScreen( 
            
                  initialLocation: studData.location!,
                  isSelecting: false,
                ),
        )
      ],),
    );
  }
}