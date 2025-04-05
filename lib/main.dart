import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'model/databse_main.dart';
import 'widget/home_page.dart';

void main() async{

  //await AndroidAlarmManager.initialize();
  final DataBaseMain databaseMain = DataBaseMain();
  //PatientsQueryHandles.setDailyAlarm(databaseMain);

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.teal, // Set your desired color here.
        statusBarIconBrightness: Brightness.light, // Change the brightness (light or dark icons).
      )
  );
  runApp( MyApp(databaseMain: databaseMain,));
}

class MyApp extends StatelessWidget {
  final DataBaseMain databaseMain;
  const MyApp({super.key, required this.databaseMain});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child){
        return MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', ''), // Arabic, no country code
          ],
          title: 'Flutter Demo',
          locale: const Locale('ar', ''),
          home: HomePagePhysics(dataBaseMain:databaseMain,),
        );
      },
    );
  }
}
