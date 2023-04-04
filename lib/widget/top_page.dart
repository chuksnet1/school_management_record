import 'package:flutter/material.dart';
import 'package:school_record_address/widget/pop_menu.dart';
import 'package:school_record_address/widget/search_tab.dart';





class TopPage extends StatelessWidget {
  final String title;

  const TopPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             
              PopMenu(),
              Stack(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                    child: Icon(Icons.notification_add),
                  ),
                  Positioned(
                      top: 3,
                      right: 3,
                      child: Container(
                        height: 10,
                        width: 10,
                        color: Colors.orange,
                      ))
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'WELCOME',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              SizedBox(
                width: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  'https://www.linkpicture.com/q/pexels-photo-1381556.jpeg',
                  fit: BoxFit.cover,
                  height: 40,
                  width: 40,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            showSearch(context: context, delegate: CustomSearch());
          },
          child: Container(
            margin: EdgeInsets.all(15),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 207, 206, 206),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.search),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Search For $title',
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
