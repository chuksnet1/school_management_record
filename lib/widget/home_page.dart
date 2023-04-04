import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_record_address/provider/student_provider.dart';
import 'package:school_record_address/screen/Add_list.dart';
import 'package:school_record_address/screen/School_list.dart';
import 'package:school_record_address/screen/category_screen.dart';


import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final _controller = PageController();
  int _selectIndex = 0;

  
  late List<Widget> _pages;

  @override
  void initState() {

    _pages = [
      const SchoolList(),
      const CategoryScreen(),
    ];
    super.initState();
  }


  

  //to select pages when tap
  void onSelectPage(int index){
    setState(() {
      _selectIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onSelectPage,
        items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,color: Colors.black,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          
          icon: Icon(Icons.category, color: Colors.black,),
          label: 'Category', backgroundColor: Colors.black ,
        ),
      ],),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 4,
              blurRadius: 4,
              offset: Offset(-3, 3)
            )
          ],
          border: Border.all(width: 5, color: Color.fromARGB(255, 199, 197, 197)),
          shape: BoxShape.circle),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          elevation: 10,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddList(),));
          },
          child: const Icon(Icons.add),
          
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
