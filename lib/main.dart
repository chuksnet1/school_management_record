import 'package:flutter/material.dart';
import 'package:school_record_address/model/student_data.dart';
import 'package:school_record_address/provider/auth_provider.dart';
import 'package:school_record_address/provider/student_provider.dart';
import 'package:school_record_address/screen/auth_screen.dart';
import 'package:school_record_address/screen/category_detail.dart';
import 'package:school_record_address/screen/category_screen.dart';
import 'package:school_record_address/screen/detail_student_list.dart';
import 'package:school_record_address/widget/home_page.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, StudentProvider>(
          create: (context) => StudentProvider([], '', ''),
          update: (context, auth, previousProductProvider) => StudentProvider(
              (previousProductProvider == null
                  ? []
                  : previousProductProvider.item),
              auth.token.toString(),
              auth.userId.toString()),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.isAuth ? HomePage() : AuthScreen(),
          routes: {
            CategoryScreen.routeName: (context) => const CategoryScreen(),
            DEtailStudentList.routeName: (context) => const DEtailStudentList(),
            CategoryDetail.routeName: (context) => const CategoryDetail(),
          },
        ),
      ),
    );
  }
}
