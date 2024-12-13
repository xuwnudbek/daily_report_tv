import 'package:daily_report_tv/ui/home_page.dart';
import 'package:daily_report_tv/ui/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return GetMaterialApp(
          title: 'Kunlik hisobot',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "Montserrat",
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFE5E5E5),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
          home: ChangeNotifierProvider(
            create: (context) => MainProvider(),
            builder: (context, _) {
              return const HomePage();
            },
          ),
        );
      },
    );
  }
}
