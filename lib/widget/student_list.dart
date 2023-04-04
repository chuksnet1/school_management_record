import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_record_address/model/student_data.dart';
import 'package:school_record_address/provider/student_provider.dart';
import 'package:school_record_address/screen/detail_student_list.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

   

  Future studentDataFuture (BuildContext context){
    return Provider.of<StudentProvider>(context, listen: false).fetchData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  

  @override
  Widget build(BuildContext context) {
    final studnDat = Provider.of<StudentProvider>(context, listen: false);
    return FutureBuilder(
      future: studentDataFuture(context),
      builder: (context, snapshot) => 
       RefreshIndicator(
        onRefresh: ()=> studentDataFuture(context),
         child: ListView.builder(
          itemCount: studnDat.item.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                DEtailStudentList.routeName,
                arguments: studnDat.item[index].id,
              );
            },
            child: ListContainer(
              studnDat.item[index].image,
              studnDat.item[index].name,
              studnDat.item[index].categoryName,
              studnDat.item[index].location!.address.toString(),
            ),
          ),
         )
       )
    );
  }
}

Widget ListContainer(File image, String name, String clasi, String address) {
  return Card(
    child: ListTile(
      leading: CircleAvatar(
        backgroundImage: FileImage(image),
      ),
      title: Row(
        children: [
          Text('Name: ${name}'),
          SizedBox(
            width: 20,
          ),
          Text('| Class:  ${clasi}')
        ],
      ),
      subtitle: 
          Text(address as String,),
       
    ),
  );
}
