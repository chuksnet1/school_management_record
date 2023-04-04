import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_record_address/provider/student_provider.dart';
import 'package:school_record_address/screen/category_detail.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = 'cat-screen';
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catData =
        Provider.of<CategoryProvider>(context, listen: false).catItem;
    return Scaffold(
      
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    CategoryDetail.routeName,
                    arguments: catData[index].name,
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    catData[index].imagename,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  left: 10,
                  bottom: 20,
                  child: Container(
                      width: 50,
                      color: Colors.white,
                      child: Text(
                        catData[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 23),
                      ))),
            ],
          );
          //child: Image.asset('assets/image/ss1.jpeg'),);
        },
      ),
    );
  }
}
