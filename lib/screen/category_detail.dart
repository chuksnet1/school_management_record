import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_record_address/provider/student_provider.dart';
import 'package:school_record_address/screen/detail_student_list.dart';

class CategoryDetail extends StatelessWidget {
  static const routeName = 'cat-detail';
  const CategoryDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final catName = ModalRoute.of(context)!.settings.arguments;
    final studData = Provider.of<StudentProvider>(context)
        .item
        .where(
          (eCateg) => eCateg.categoryName == catName,
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text('${catName.toString()}    STUDENTS')),
      body: studData.isEmpty
          ? const Center(
              child: Text(
                'YOu Dont Have Any Student Added Yet',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: studData.length,
              itemBuilder: (context, index) =>
                  disContainer(
                    context,
                    studData[index].image,
                    studData[index].id,
                    studData[index].name,
                    ),
                    
            ),
    );
  }

  Widget disContainer(BuildContext context, File image, String studentId, String name) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(
            DEtailStudentList.routeName,
            arguments: studentId,
          );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(backgroundImage: FileImage(image)),
          title: Text(name),
        ),
      ),
    );
  }
}
