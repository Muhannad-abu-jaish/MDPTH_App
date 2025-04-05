import 'package:diaa_pth/widget/personal_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:diaa_pth/widget/dialog/warning_dialog.dart';
import 'package:lottie/lottie.dart';

import '../controller/patients_query.dart';
import '../model/appointment_model.dart';
import '../model/databse_main.dart';
import '../model/patient.dart';
import 'days_persent.dart';

class DaysCircleDialog extends StatefulWidget {
  final DataBaseMain dataBaseMain;
  const DaysCircleDialog({super.key, required this.dataBaseMain});

  @override
  State<DaysCircleDialog> createState() => _DaysCircleDialogState();
}

class _DaysCircleDialogState extends State<DaysCircleDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Hiiiiiiiii i am in circular screen");
  }

  List<String> daysOfWeek = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت'
  ];
  List<int> daysOfWeekNumbers = [] ;

  Map<String, int> dayNameToNumber = {
    'الأحد': 1,
    'الاثنين': 2,
    'الثلاثاء': 3,
    'الأربعاء': 4,
    'الخميس': 5,
    'الجمعة': 6,
    'السبت': 7,
  };

  List<Patient> patientsData = [];
  List<AppointmentModel> appointmentPatientData = [] ;
  PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles();

  List items = [
    {
      "icon": Icons.account_balance,
      "title": "محمد سالم ابو زيد",
      "subtitle": "الشارع الشمالي",
      "price": "كسر قدم"
    },
    {
      "icon": Icons.account_balance,
      "title": "احمد النواصرة",
      "subtitle": "ابطع الشارع الاوسط",
      "price": "خلع كتف"
    },
    {
      "icon": Icons.account_balance,
      "title": "صفوان احمد",
      "subtitle": "لا يوجد عنوان",
      "price": "علاج عام"
    },
    {
      "icon": Icons.account_balance,
      "title": "تيسير الصفدي",
      "subtitle": "شارع الحديد",
      "price": "تمزق اربطة"
    },
    {
      "icon": Icons.account_balance,
      "title": "تيم حسن",
      "subtitle": "مقابل طلال ابوعون",
      "price": "مشاكل عمود فقري"
    },
    {
      "icon": Icons.account_balance,
      "title": "باسل خياط",
      "subtitle": "بجانب الصدلية المركزية",
      "price": "مشاكل رقبة"
    },
    {
      "icon": Icons.account_balance,
      "title": "قصي خولي",
      "subtitle": "دوار داعل",
      "price": "حجامة"
    },
    {
      "icon": Icons.account_balance,
      "title": "كرستيانو رونالدو",
      "subtitle": "مشاكل عائلية",
      "price": " طفس- جامع الحسن-"
    },
    {
      "icon": Icons.account_balance,
      "title": "نغولو كانتي",
      "subtitle": "شمال لندن",
      "price": "منشطات"
    },
    {
      "icon": Icons.account_balance,
      "title": "حكيم زياش",
      "subtitle": "هولندا-أياكس-",
      "price": "اربطة الكتف"
    }
  ];

  // هذه الدالة تُرجع الأيام مرتبة بداية من اليوم التالي
  List<String> getOrderedDays() {
    String today = DateFormat('EEEE', 'ar').format(DateTime.now());
    print("The day is $today ");
    int todayIndex = daysOfWeek.indexOf(today);
    print("The index of the day is $todayIndex ");
    List<String> orderedDays = [ //ترتيب الأيام بناء على اليوم الحالي مثلا اليوم الاحد(ترتب الايام من الاثنين للسبت والأحد يضاف كآخر يوم ويعرض)
      ...daysOfWeek.sublist(todayIndex + 1),
      ...daysOfWeek.sublist(0, todayIndex + 1)
    ];

    print("The list of the days is $orderedDays");

    daysOfWeekNumbers = orderedDays.map((day) => dayNameToNumber[day] ?? 0).toList();
    print("The list of the day numbers is $daysOfWeekNumbers");
    return orderedDays;
  }

  @override
  Widget build(BuildContext context) {
    List<String> orderedDays = getOrderedDays();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async{
          setState(() {

          });
        },
        child: Container(
          padding: EdgeInsets.all(3.w),
          child: ListView(
            children: [

              //Title Appointments
              Row(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onLongPress: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                //Here should i add the patient ID #
                                Percent(dataBaseMain: widget.dataBaseMain)
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 30, right: 35),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  colors: [Colors.grey.shade600, Colors.tealAccent],
                                  tileMode: TileMode.repeated)),
                          height: 55.h,
                          width: 264.w,
                          alignment: Alignment.center,
                          child: const Text(
                            "المواعيد",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(height: 20.h),

              //Circle appointment the whole week
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.290,
                child: ListView.builder(
                  itemCount: orderedDays.length - 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: EdgeInsets.only(right: 13.w),
                      child: Column(
                        children: [

                          //Circle icons of shown days of week
                          Container(
                            width: MediaQuery.of(context).size.width * 0.21,
                            height: MediaQuery.of(context).size.width * 0.21,
                            decoration: BoxDecoration(
                              /*color:(i % 2 == 0) ? Colors.teal : Colors.grey[200],*/
                                borderRadius: BorderRadius.circular(100),
                                gradient: LinearGradient(
                                  colors: (i % 2 == 0)
                                      ? [
                                    Colors.grey.shade600,
                                    Colors.tealAccent
                                  ]
                                      : [
                                    Colors.tealAccent,
                                    Colors.grey.shade600
                                  ],
                                )),
                            padding: EdgeInsets.all(10.h),
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RefreshIndicator(
                                      onRefresh: () async {
                                        setState(() {

                                        });
                                      },
                                      child: AlertDialog(
                                        title: Text(
                                          'قائمة المواعيد',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 30.sp),
                                        ),

                                        content: FutureBuilder<List<Patient>>(
                                            future: patientsQueryHandles.getDayAppointment(daysOfWeekNumbers[i],widget.dataBaseMain),
                                            builder: (context, snapshot) {
                                              //This is for the waiting
                                              print("i am before the waiting11111111111111 circle");
                                              if(snapshot.connectionState == ConnectionState.waiting) {
                                                //replace it with the waiting cards
                                                return const Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }

                                              print("i am after the waiting222222222222222 circle");
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                print("i am inside the done333333333333 circle");
                                                if (snapshot.hasData) {
                                                  patientsData = snapshot.data!;
                                                  //List<Patient> displayListPatients = _filteredItems.isEmpty? patientsData : _filteredItems;
                                                  print("i am inside the has data444444444444444444");
                                                  return patientsData.isEmpty? Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        child: Lottie.asset( //#
                                                          'assets/animations/Search_move_no_data.json', // مسار الملف
                                                          fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 16.h),
                                                        padding: EdgeInsets.all(7.w),
                                                        height: 55.h,
                                                        width: 264.w,
                                                        alignment: Alignment.center,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            "لا يوجد مرضى لعرضهم...",
                                                            style: TextStyle(
                                                                fontSize: 28.sp,
                                                                fontWeight: FontWeight.w900,
                                                                color: Colors.teal
                                                            ),
                                                          ),
                                                        ),
                                                      )

                                                    ],
                                                  ):
                                                  SizedBox(
                                                    width: double.maxFinite,
                                                    height: 400,
                                                    child: ListView(
                                                        children: [
                                                          ListView.builder(
                                                            itemCount: patientsData.length,
                                                            physics:
                                                            const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemBuilder: (context, z) {
                                                              return Padding(
                                                                  padding: EdgeInsets.all(0.h),
                                                                  child: Card(
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          15.0),
                                                                    ),
                                                                    elevation: 10,
                                                                    shadowColor: Colors.black
                                                                        .withOpacity(0.2),
                                                                    // إضافة تأثير الظل الخفيف
                                                                    color: Colors.white,
                                                                    // لون الخلفية البيضاء
                                                                    child: Padding(
                                                                      padding: EdgeInsets.all(
                                                                          10.0.h),
                                                                      child: Row(
                                                                        children: [
                                                                          SizedBox(width: 16.w),
                                                                          Expanded(
                                                                            child: Column(
                                                                              crossAxisAlignment:
                                                                              CrossAxisAlignment
                                                                                  .start,
                                                                              children: [
                                                                                SizedBox(
                                                                                    height:
                                                                                    12.h),
                                                                                Text(
                                                                                  patientsData[z].name,
                                                                                  style: TextStyle(
                                                                                      fontSize: 23.sp,
                                                                                      // تكبير حجم النص
                                                                                      fontWeight: FontWeight.w900,
                                                                                      //color: Colors.black87, // لون داكن أكثر للنص
                                                                                      color: Colors.teal),
                                                                                ),

                                                                                Text(
                                                                                  '( ${patientsData[z].nickName} )',
                                                                                  style: TextStyle(
                                                                                      fontSize: 23.sp,
                                                                                      // تكبير حجم النص
                                                                                      fontWeight: FontWeight.w900,
                                                                                      //color: Colors.black87, // لون داكن أكثر للنص
                                                                                      color: Colors.black),
                                                                                ),

                                                                                SizedBox(
                                                                                    height:
                                                                                    12.h),
                                                                                Text(
                                                                                  patientsData[z].address,
                                                                                  style:
                                                                                  TextStyle(
                                                                                    color: Colors
                                                                                        .black87,
                                                                                    // لون أكثر رمادية للنص الثانوي
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w900,
                                                                                    fontSize: 16
                                                                                        .sp, // تكبير حجم النص قليلاً
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                    height:
                                                                                    12.h),
                                                                                Text(
                                                                                  patientsData[z].status,
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w900,
                                                                                    color: Colors
                                                                                        .grey[
                                                                                    700],
                                                                                    // نفس لون النص الثانوي
                                                                                    fontSize: 15
                                                                                        .sp, // تكبير حجم النص قليلاً
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                    height:
                                                                                    12.h),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ));
                                                            },
                                                          ),
                                                        ]),
                                                  );
                                                }
                                                print("i am before the error circle");
                                                if (snapshot.hasError) {
                                                  print("i am inside the error circle");
                                                  print(snapshot.error);
                                                  //Here replace it with icon on the errors
                                                  return Center(
                                                    //Animation for error #
                                                      child:  Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            child: Lottie.asset( //#
                                                              'assets/animations/Search_move_no_data.json', // مسار الملف
                                                              fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: 16.h),
                                                            padding: EdgeInsets.all(7.w),
                                                            height: 70.h,
                                                            width: 264.w,
                                                            alignment: Alignment.center,
                                                            child:Text(
                                                              "حدث خطأ أثناء تحميل البيانات, حاول مرة أخرى...",
                                                              style: TextStyle(
                                                                  fontSize: 20.sp,
                                                                  fontWeight: FontWeight.w900,
                                                                  color: Colors.teal
                                                              ),
                                                            ),

                                                          )

                                                        ],
                                                      )
                                                  );
                                                }
                                              }
                                              print("i am after the get data circle");
                                              //Here but an icon for fail
                                              return  Center(
                                                //The connection has fail one #
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        child: Lottie.asset( //#
                                                          'assets/animations/Search_move_no_data.json', // مسار الملف
                                                          fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 16.h),
                                                        padding: EdgeInsets.all(7.w),
                                                        height: 70.h,
                                                        width: 264.w,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "حدث خطأ أثناء تحميل البيانات, حاول مرة أخرى..",
                                                          style: TextStyle(
                                                              fontSize: 18.sp,
                                                              fontWeight: FontWeight.w900,
                                                              color: Colors.teal
                                                          ),
                                                        ),

                                                      )

                                                    ],
                                                  )
                                              );
                                            }),

                                        actions: [
                                          SizedBox(
                                            height: 10.h,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.today,
                                size: 37.w,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 5.h,
                          ),

                          //Text the name of those days in the top of this code
                          SizedBox(
                            width: 40.w,
                            height: 20.h,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                orderedDays[i],
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15.sp,
                                    color: Colors.black),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),


              //The appointment of today
              Container(
                padding: EdgeInsets.only(right: 21.w),
                child: Text(
                  orderedDays.last, // اليوم الحالي
                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.right,
                ),
              ),
              FutureBuilder<List<AppointmentModel>>(
                  future: patientsQueryHandles.getTodayAppointment(daysOfWeekNumbers[6],widget.dataBaseMain),
                  builder: (context, snapshot) {
                    //This is for the waiting
                    print("i am before the waiting11111111111111 circle");
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      //replace it with the waiting cards
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    print("i am after the waiting222222222222222 circle");
                    if (snapshot.connectionState == ConnectionState.done) {
                      print("i am inside the done333333333333 circle");
                      if (snapshot.hasData) {
                        appointmentPatientData = snapshot.data!;
                        print("i am inside the has data444444444444444444");
                        return appointmentPatientData.isEmpty? Column(
                          children: [
                            Container(
                              child: Lottie.asset( //#
                                'assets/animations/dj_party.json', // مسار الملف
                                fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(7.w),
                              alignment: Alignment.center,
                              child: Text(
                                "تهانينا... انتهت مواعيد اليوم, ",
                                style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.teal
                                ),
                              ),

                            ), Container(
                              padding: EdgeInsets.all(7.w),
                              alignment: Alignment.center,
                              child: Text(
                                " شكراً لجهودك",
                                style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.teal
                                ),
                              ),

                            )

                          ],
                        ):
                        SizedBox(
                          width: double.maxFinite,
                          height: 400,
                          child: ListView(
                              children: [
                                ListView.builder(
                                    itemCount: appointmentPatientData.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      Patient patient = Patient(name: appointmentPatientData[i].name, nickName: appointmentPatientData[i].nickName, address: appointmentPatientData[i].address, status: appointmentPatientData[i].status , patientID: appointmentPatientData[i].patientID);
                                      return Padding(
                                        padding: EdgeInsets.all(10.0.h),
                                        child: GestureDetector(
                                          onTap: () {
                                            // الانتقال إلى واجهة تفاصيل المريض مع تمرير البيانات
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                //Here should i add the patient ID #
                                                PersonalProfile(patientData: patient, dataBaseMain: widget.dataBaseMain,),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            elevation: 10.h,
                                            shadowColor: Colors.teal.withOpacity(0.7.h),
                                            // إضافة تأثير الظل الخفيف
                                            color: Colors.white,
                                            // لون الخلفية البيضاء
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 13.0.w,
                                                      left: 13.0.w,
                                                      bottom: 13.h,
                                                      top: 20.h),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(colors: [
                                                            Colors.grey.shade600,
                                                            Colors.tealAccent
                                                          ], tileMode: TileMode.repeated),
                                                          // لون أكثر هدوءًا للأيقونة
                                                          borderRadius:
                                                          BorderRadius.circular(100.w),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black.withOpacity(0.1),
                                                              spreadRadius: 1,
                                                              blurRadius: 2,
                                                              offset: Offset(0.w, 2.h),
                                                            ),
                                                          ],
                                                        ),
                                                        padding: EdgeInsets.all(15.w),
                                                        child: Icon(
                                                          Icons.today,
                                                          size: 40.w,
                                                        ),
                                                      ),
                                                      SizedBox(width: 16.w),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              height: 15.h,
                                                            ),
                                                            Text(
                                                              appointmentPatientData[i].name,
                                                              style: TextStyle(
                                                                fontSize: 20.sp, // تكبير حجم النص
                                                                fontWeight: FontWeight.w900,
                                                                color: Colors.teal[
                                                                700], // لون داكن أكثر للنص
                                                              ),
                                                            ),
                                                            Text(
                                                              '( ${appointmentPatientData[i].nickName} )',
                                                              style: TextStyle(
                                                                fontSize: 20.sp, // تكبير حجم النص
                                                                fontWeight: FontWeight.w900,
                                                                color: Colors.teal, // لون داكن أكثر للنص
                                                              ),
                                                            ),
                                                            SizedBox(height: 8.h),
                                                            Text(
                                                              appointmentPatientData[i].address,
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w900,
                                                                // لون أكثر رمادية للنص الثانوي
                                                                fontSize:
                                                                17.sp, // تكبير حجم النص قليلاً
                                                              ),
                                                            ),
                                                            SizedBox(height: 8.h),
                                                            Text(
                                                              appointmentPatientData[i].status,
                                                              style: TextStyle(
                                                                color: Colors.grey[700],
                                                                fontWeight: FontWeight.w900,
                                                                // نفس لون النص الثانوي
                                                                fontSize:
                                                                17.sp, // تكبير حجم النص قليلاً
                                                              ),
                                                            ),
                                                            SizedBox(height: 4.h),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0.h,
                                                  right: 10.w, // تغيير الموضع إلى الزاوية اليمنى
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
                                                        Icons.cyclone_sharp,
                                                        color: Colors.teal,
                                                        size: 30.w,
                                                      ),
                                                      onPressed: () async {
                                                        bool? result = await showCustomDialog(context, appointmentPatientData[i].patientID! , appointmentPatientData[i].appointmentID!, widget.dataBaseMain);
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
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                              ]),
                        );
                      }
                      print("i am before the error circle");
                      if (snapshot.hasError) {
                        print("i am inside the error circle");
                        print(snapshot.error);
                        //Here replace it with icon on the errors
                        return Center(
                          //Animation for error #
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Lottie.asset( //#
                                    'assets/animations/Search_move_no_data.json', // مسار الملف
                                    fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16.h),
                                  padding: EdgeInsets.all(7.w),
                                  height: 70.h,
                                  width: 264.w,
                                  alignment: Alignment.center,
                                  child:Text(
                                    "حدث خطأ أثناء تحميل البيانات, حاول مرة أخرى...",
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.teal
                                    ),
                                  ),

                                )

                              ],
                            )
                        );
                      }
                    }
                    print("i am after the get data circle");
                    //Here but an icon for fail
                    return  Center(
                      //The connection has fail one #
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Lottie.asset( //#
                                'assets/animations/Search_move_no_data.json', // مسار الملف
                                fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16.h),
                              padding: EdgeInsets.all(7.w),
                              height: 70.h,
                              width: 264.w,
                              alignment: Alignment.center,
                              child: Text(
                                "حدث خطأ أثناء تحميل البيانات, حاول مرة أخرى..",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.teal
                                ),
                              ),

                            )

                          ],
                        )
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> showCustomDialog(BuildContext context , int patientID , int appointmentID , DataBaseMain db)async {
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
                child:  WarningDialogContent(patientID:patientID ,appointmentID:appointmentID , dataBaseMain: db,),
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
