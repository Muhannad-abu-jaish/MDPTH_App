import 'package:diaa_pth/widget/dialog/dialog_payments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../controller/patients_query.dart';
import '../model/databse_main.dart';
import '../model/patient.dart';

class Payments extends StatefulWidget {
  final DataBaseMain dataBaseMain;
  const Payments({super.key, required this.dataBaseMain});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles();
  List<Patient> patientsData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Hiiiiiiiii i am in Payments screen");
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: screenHeight * 0.009, // نسبة مختلفة من الارتفاع
            right: screenWidth * 0.09,
            child: Tooltip(
              message: "تهيئة حالة المواعيد",
              child: FloatingActionButton(
                onPressed: () async {
                  bool result = await patientsQueryHandles.updateAppointmentStatus(widget.dataBaseMain) ;

                  if(result)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم تحديث حالة المواعيد بنجاح'),
                        duration: Duration(seconds: 4),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('حدثت مشكلةأثناء التحديث, حاول مرة أخرى'),
                        duration: Duration(seconds: 4),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  }
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.remove , color: Colors.white,),

              ),
            ),
          ),
        ],
      ),
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
                            "المدفوعات",
                            style: TextStyle(
                                fontSize: 29.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(height: 30.h),
              FutureBuilder<List<Patient>>(
                  future: patientsQueryHandles.getAllDebts(widget.dataBaseMain),
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
                        patientsData = snapshot.data!;
                        //List<Patient> displayListPatients = _filteredItems.isEmpty? patientsData : _filteredItems;
                        print("i am inside the has data444444444444444444");
                        return patientsData.isEmpty? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9, // عرض الأنيميشن (اختياري)
                              height: MediaQuery.of(context).size.height * 0.4, // ارتفاع الأنيميشن (اختياري)
                              child: Lottie.asset( //#
                                'assets/animations/dj_party.json', // مسار الملف
                                fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16.h),
                              padding: EdgeInsets.all(7.w),
                              alignment: Alignment.center,
                              child: Text(
                                "تهانيا لك... لا يوجد ديون متبقية ",
                                style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.teal
                                ),
                              ),

                            ),
                            Container(
                              padding: EdgeInsets.all(7.w),
                              alignment: Alignment.center,
                              child: Text(
                                "عيش الحياة يا معلم",
                                style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.teal
                                ),
                              ),

                            )

                          ],
                        ):
                        ListView.builder(
                            itemCount: patientsData.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {

                              String debts = NumberFormat('#,##0', 'en_US').format(patientsData[i].paymentStill);
                              String payed = NumberFormat('#,##0', 'en_US').format(patientsData[i].paymentGot);
                              return Padding(
                                padding:  EdgeInsets.all(10.0.h),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0.h),
                                  ),
                                  elevation: 20.h,
                                  shadowColor: Colors.teal.withOpacity(0.7),
                                  // إضافة تأثير الظل الخفيف
                                  color: Colors.white,
                                  // لون الخلفية البيضاء
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16.0.h),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 16.w,),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  //Name
                                                  Text(
                                                    patientsData[i].name,
                                                    style: TextStyle(
                                                      fontSize: 23.sp, // تكبير حجم النص
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors
                                                          .teal[700], // لون داكن أكثر للنص
                                                    ),
                                                  ),
                                                  Text(
                                                    "( ${patientsData[i].nickName} )",
                                                    style: TextStyle(
                                                      fontSize: 23.sp, // تكبير حجم النص
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors
                                                          .teal[700], // لون داكن أكثر للنص
                                                    ),
                                                  ),
                                                  SizedBox(height: 15.h),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 90.w,
                                                        child: Text(
                                                          'المبلغ المدفوع:  ',
                                                          style: TextStyle(
                                                              color: Colors.grey[700],
                                                              // نفس لون النص الثانوي
                                                              fontSize: 15.sp,
                                                              // تكبير حجم النص قليلاً
                                                              fontWeight: FontWeight.w900),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 40.w,
                                                      ),
                                                      Container(
                                                        width: 100.w,
                                                        height: 35.h,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: Colors.teal[100],
                                                            borderRadius: BorderRadius.circular(7.h)
                                                        ),
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            payed,
                                                            style: TextStyle(
                                                                color: Colors.grey[700],
                                                                // نفس لون النص الثانوي
                                                                fontSize: 15.sp,
                                                                // تكبير حجم النص قليلاً
                                                                fontWeight: FontWeight.w900),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(height: 15.h),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 90.w,
                                                        child: Text(
                                                          'المبلغ المتبقي:',
                                                          style: TextStyle(
                                                              color: Colors.grey[700],
                                                              // نفس لون النص الثانوي
                                                              fontSize: 15.sp,
                                                              // تكبير حجم النص قليلاً
                                                              fontWeight: FontWeight.w900),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 40.w,
                                                      ),
                                                      Container(
                                                        width: 100.w,
                                                        height: 35.h,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: Colors.teal,
                                                            borderRadius: BorderRadius.circular(7.h)
                                                        ),
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            debts,
                                                            style: TextStyle(
                                                                color: Colors.grey[700],
                                                                // نفس لون النص الثانوي
                                                                fontSize: 15.sp,
                                                                // تكبير حجم النص قليلاً
                                                                fontWeight: FontWeight.w900),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //اشارة الاكس
                                      Positioned(
                                        top: 10,
                                        left: 4, // تغيير الموضع إلى الزاوية اليمنى
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white, // لون خلفية الزر
                                            borderRadius: BorderRadius.circular(
                                                50), // جعل الشكل دائرياً
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.add_circle_rounded,
                                              color: Colors.teal,
                                              size: 30.w,
                                            ),
                                            // أيقونة إكس باللون الأحمر
                                            onPressed: () async {
                                              bool? result = await  showCustomDialogPayments(context, patientsData[i].patientID! , widget.dataBaseMain , patientsData[i].paymentStill! , patientsData[i].paymentGot!);
                                              if(result == null)
                                              {

                                                print("The null is on") ;
                                              }else if(result ==true){
                                                if(mounted)
                                                {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('تمت العملية بنجاح'),
                                                      duration: Duration(seconds: 2),
                                                      backgroundColor: Colors.teal,
                                                    ),
                                                  );
                                                }
                                                setState(() {
                                                });
                                              }else{
                                                if(mounted)
                                                {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('حدثت مشكلة أثناء التنفيذ, حاول مرة أخرى'),
                                                      duration: Duration(seconds: 2),
                                                      backgroundColor: Colors.teal,
                                                    ),
                                                  );
                                                }
                                              }

                                              // قم بتنفيذ أي إجراء عند الضغط على الزر
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
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
                                      fontSize: 22.sp,
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
                                "حدث خطأ أثناء تحميل الديون, حاول مرة أخرى",
                                style: TextStyle(
                                  fontSize: 20.sp,
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

  Future<bool?> showCustomDialogPayments(BuildContext context , int patientID , DataBaseMain db , double debts ,double paid) async{
    return await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 1500),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0.h),
            child: Align(
              alignment: Alignment.center,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0.w),

                ),

                child: DialogPayments(patientID: patientID , dataBaseMain: db, paidMoney: paid, debtsMoney: debts,),

              ),
            ),
          ),

        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.easeOutQuint;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = anim1.drive(tween);

        var fadeAnimation = anim1.drive(Tween(begin: 0.0, end: 1.0));

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
