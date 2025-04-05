
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller/patients_query.dart';
import '../model/databse_main.dart';
import '../model/patient.dart';

class Percent extends StatefulWidget {
  final DataBaseMain dataBaseMain;
  const Percent({super.key, required this.dataBaseMain});

  @override
  State<Percent> createState() => _PercentState();
}

class _PercentState extends State<Percent>  with SingleTickerProviderStateMixin {

 PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles();
  //List<int> percentData = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  late int numberOfApps ;

  //Here should i but the colors for each day
  final List<Color> colorList = [
    Colors.blue[400]!,
    Colors.purple[300]!,
    Colors.green[400]!,
    Colors.amber[300]!,
    Colors.red,
    Colors.cyan[400]!,
    Colors.black,
   ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Hiiiiiiiii i am in Percent screen");
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // زمن الأنيميشن
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

 // جلب البيانات من القاعدة
 Future<Map<String, double>> fetchData() async {
   // استبدل هذا بالمنطق الحقيقي لجلب البيانات
   final data = await patientsQueryHandles.getPercentDaysApps(widget.dataBaseMain);
   Map<String, double> result = {
     'الأحد   ${data[1]}': data[1]?.toDouble() ?? 0.0,
     'الأثنين   ${data[2]}': data[2]?.toDouble() ?? 0.0,
     'الثلاثاء   ${data[3]}': data[3]?.toDouble() ?? 0.0,
     'الأربعاء   ${data[4]}': data[4]?.toDouble() ?? 0.0,
     'الخميس   ${data[5]}': data[5]?.toDouble() ?? 0.0,
     'الجمعة   ${data[6]}': data[6]?.toDouble() ?? 0.0,
     'السبت   ${data[7]}': data[7]?.toDouble() ?? 0.0,
   };
   numberOfApps = data[1]! + data[2]! + data[3]! + data[4]! + data[5]! + data[6]! + data[7]! ;
    return result;
 }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async {
          setState(() {

          });
        },
        child: Container(
          padding: EdgeInsets.all(3.w),
          child: ListView(
            children: [
              Row(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin:  EdgeInsets.only(top: 27.h, right: 40.w),
                        padding:  EdgeInsets.all(10.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.w),
                            gradient: LinearGradient(
                                colors: [Colors.grey.shade600, Colors.tealAccent],
                                tileMode: TileMode.repeated)),
                        height: 55.h,
                        width: 264.w,
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "النسب المئوية",
                            style: TextStyle(
                                fontSize: 29.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(height: 15.h,),
              FutureBuilder<Map<String, double>>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    //This is for the waiting
                    print("i am before the waiting11111111111111");
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      //replace it with the waiting cards
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    print("i am after the waiting222222222222222");
                    if (snapshot.connectionState == ConnectionState.done) {
                      print("i am inside the done333333333333");
                      if (snapshot.hasData) {
                        final dataMap = snapshot.data!;
                        final gotData = dataMap.values.any((value) => value > 0);
                        print("i am inside the has data444444444444444444");
                        return !gotData? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9, // عرض الأنيميشن (اختياري)
                              height: MediaQuery.of(context).size.height * 0.4, // ارتفاع الأنيميشن (اختياري)
                              child: Lottie.asset( //#
                                'assets/animations/Search_move_no_data.json', // مسار الملف
                                fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16.h),
                              padding: EdgeInsets.all(7.w),
                              alignment: Alignment.center,
                              child: Text(
                                "لا يوجد مواعيد لعرض نسبها.. ",
                                style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.teal
                                ),
                              ),

                            ),

                          ],
                        ):
                        Center(
                          child: Container(
                            width: 500.w,
                            height: 600.h,
                            color: Colors.white10,
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: screenHeight *0.7,
                                      child: PieChart(
                                        dataMap: dataMap,
                                        animationDuration: Duration(milliseconds: 5200),
                                        chartLegendSpacing: 32,
                                        chartRadius: screenWidth/1.1,
                                        colorList: colorList,
                                        initialAngleInDegree: 0,
                                        chartType: ChartType.disc,
                                        ringStrokeWidth: 62,
                                        legendOptions: LegendOptions(
                                          showLegendsInRow: false,
                                          legendPosition: LegendPosition.bottom,
                                          showLegends: true,
                                          legendShape: BoxShape.circle,
                                          legendTextStyle: TextStyle(
                                              fontSize: 20.sp,fontWeight: FontWeight.w900
                                          ),
                                        ),
                                        chartValuesOptions: ChartValuesOptions(
                                          showChartValueBackground: false,
                                          showChartValues: true,
                                          showChartValuesInPercentage: true,
                                          showChartValuesOutside: false,
                                          decimalPlaces: 1,
                                          chartValueStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                          ),
                                        ),

                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              margin:  EdgeInsets.only(top: 17.h, right: 40.w),
                                              padding:  EdgeInsets.all(10.h),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20.w),
                                                 color: Colors.black
                                              ),
                                              height: 55.h,
                                              width: 264.w,
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "العدد الكلي  $numberOfApps",
                                                  style: TextStyle(
                                                      fontSize: 29.sp, fontWeight: FontWeight.bold , color: Colors.white),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ),
                        );
                      }
                      print("i am before the error");
                      if (snapshot.hasError) {
                        print("i am inside the error");
                        //Here replace it with icon on the errors
                        return Center(
                          //Animation for error #
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9, // عرض الأنيميشن (اختياري)
                                  height: MediaQuery.of(context).size.height * 0.4, // ارتفاع الأنيميشن (اختياري)
                                  child: Lottie.asset( //#
                                    'assets/animations/Search_move_no_data.json', // مسار الملف
                                    fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16.h, right: 33.w),
                                  padding: EdgeInsets.all(7.w),
                                  height: 55.h,
                                  width: 264.w,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "حدث خطأ أثناء تحميل الديون, حاول مرة أخرى",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                )
                              ],
                            )
                        );
                      }
                    }
                    print("i am after the get data");
                    //Here but an icon for fail
                    return  Center(
                      //The connection has fail one #
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9, // عرض الأنيميشن (اختياري)
                              height: MediaQuery.of(context).size.height * 0.4, // ارتفاع الأنيميشن (اختياري)
                              child: Lottie.asset(
                                'assets/animations/Search_move_no_data.json', // مسار الملف
                                fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16.h, right: 33.w),
                              padding: EdgeInsets.all(7.w),
                              height: 55.h,
                              width: 264.w,
                              alignment: Alignment.center,
                              child:Text(
                                "حدث خطأ أثناء تحميل النسب, حاول مرة أخرى",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
