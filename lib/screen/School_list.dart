import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_record_address/provider/student_provider.dart';
import 'package:school_record_address/screen/category_screen.dart';
import 'package:school_record_address/widget/student_list.dart';
import 'package:school_record_address/widget/top_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SchoolList extends StatefulWidget {
  const SchoolList({super.key});

  @override
  State<SchoolList> createState() => _SchoolListState();
}

class _SchoolListState extends State<SchoolList> {
  final _controller = PageController();


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        children: [
          Container(
            height: 170,
            child: TopPage(title: 'Seach For Student'),
          ),
          SizedBox(
            child: SmoothPageIndicator(
              controller: _controller,
              count: 2,
              effect: JumpingDotEffect(offset: 1.4),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 450,
            child: PageView(
              //Fetch data here
              controller: _controller,
              children: [
                CategoryScreen(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StudentList(),
                ),
                
                
              ],
            ),
          ),
        ],
      )),
    );
  }
}
