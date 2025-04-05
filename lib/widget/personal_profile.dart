import 'package:diaa_pth/templet_usage/custom_dialog_animation.dart';
import 'package:diaa_pth/widget/dialog/dialog_add_one_appointment.dart';
import 'package:diaa_pth/widget/dialog/dialog_address.dart';
import 'package:diaa_pth/widget/dialog/dialog_apointment_days.dart';
import 'package:diaa_pth/widget/dialog/dialog_general_state.dart';
import 'package:diaa_pth/widget/dialog/dialog_medical_plan.dart';
import 'package:diaa_pth/widget/dialog/dialog_personal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../controller/patients_query.dart';
import '../model/databse_main.dart';
import '../model/patient.dart';
import '../model/personal_profile.dart';
import 'dialog/dialog_payments.dart';

class PersonalProfile extends StatefulWidget {
  final Patient patientData;
  final DataBaseMain dataBaseMain;

  const PersonalProfile(
      {super.key, required this.patientData, required this.dataBaseMain});

  @override
  State<PersonalProfile> createState() => _PersonalProfileState();
}

class _PersonalProfileState extends State<PersonalProfile> {
  late Patient patient;
  late PersonalProfileModel personalProfile;
  late AnimationController _controllerAnimation;
  PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles();

  String daysName(List<int> daysNameNumber) {
    Map<String, int> myMap = {
      'الأحد': 1,
      'الأثنين': 2,
      'الثلاثاء': 3,
      'الأربعاء': 4,
      'الخميس': 5,
      'الجمعة': 6,
      'السبت': 7,
    };

    List<String> daysName = [];

    for (int num in daysNameNumber) {
      myMap.forEach((day, value) {
        if (value == num) {
          daysName.add(day);
        }
      });
    }

    return daysName.join(" - ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Here i will add the dialog for choosing a specific day
          CustomDialogAnimation.showCustomDialogPersonal(
              context, const DialogAddOneAppointment());
        },
        backgroundColor: Colors.teal,
        child: Icon(
          Icons.add,
          size: 25.w,
        ),
      ),*/
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(3.w),
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                //عنوان الصفحة الملف الشخصي
                Row(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(top: 27.h, right: 40.w),
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.w),
                              gradient: LinearGradient(colors: [
                                Colors.grey.shade600,
                                Colors.tealAccent
                              ], tileMode: TileMode.repeated)),
                          height: 55.h,
                          width: 264.w,
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "الملف الشخصي",
                              style: TextStyle(
                                  fontSize: 29.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  ],
                ),

                SizedBox(height: 25.h),

                //Patients card
                FutureBuilder<PersonalProfileModel>(
                    future: patientsQueryHandles.getPersonalProfile(
                        widget.dataBaseMain, widget.patientData.patientID),
                    builder: (context, snapshot) {
                      //This is for the waiting
                      print(
                          "i am before the waiting Personal profile11111111111");
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        //replace it with the waiting cards
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      print(
                          "i am after the waiting Personal profile 222222222222222");
                      if (snapshot.connectionState == ConnectionState.done) {
                        print(
                            "i am inside the done Personal profile 333333333333");
                        if (snapshot.hasData) {
                          personalProfile = snapshot.data!;
                          String debts = NumberFormat('#,##0', 'en_US')
                              .format(personalProfile.patient?.paymentStill);
                          String payed = NumberFormat('#,##0', 'en_US')
                              .format(personalProfile.patient?.paymentGot);
                          //List<Patient> displayListPatients = _filteredItems.isEmpty? patientsData : _filteredItems;
                          print(
                              "i am inside the has data Personal profile 444444444444444444");
                          if (personalProfile.patient != null &&
                              personalProfile.dayTime != null &&
                              personalProfile.daysNumbers != null) {
                            return Column(
                              children: [
                                //Name and age card
                                Container(
                                  padding: EdgeInsets.all(16.0.h),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15.0.h),
                                    ),
                                    elevation: 20.h,
                                    shadowColor: Colors.teal.withOpacity(0.7),
                                    // إضافة تأثير الظل الخفيف
                                    color: Colors.white,
                                    // لون الخلفية البيضاء
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.0.h,
                                              top: 16.0.h,
                                              bottom: 16.0.h),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        personalProfile
                                                            .patient!.name,
                                                        style: TextStyle(
                                                            fontSize: 23.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900),
                                                      ),
                                                      subtitle: Text(
                                                        "( ${personalProfile.patient!.nickName} )",
                                                        style: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900),
                                                      ),
                                                      leading: Icon(
                                                        Icons.person,
                                                        size: 32.w,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 60.w),
                                                      child: Text(
                                                        personalProfile.patient!
                                                            .age ==
                                                            "لا يوجد"
                                                            ? "لا يوجد"
                                                            : "${personalProfile.patient!.age}, سنة",
                                                        style: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                            FontWeight.w900,
                                                            color: Colors
                                                                .grey[800]),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 60.w),
                                                      child: Text(
                                                        "${personalProfile.patient!.phoneNumber}",
                                                        style: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                            FontWeight.w900,
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //اشارة الاكس
                                        Positioned(
                                          top: 10.h,
                                          left: 7.w,
                                          // تغيير الموضع إلى الزاوية اليمنى
                                          child: Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              // لون خلفية الزر
                                              borderRadius:
                                              BorderRadius.circular(
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
                                                bool? result =
                                                await CustomDialogAnimation
                                                    .showCustomDialogPersonal(
                                                    context,
                                                    DialogPersonal(
                                                      patientID:
                                                      personalProfile
                                                          .patient!
                                                          .patientID!,
                                                      dataBaseMain: widget.dataBaseMain,
                                                    ));
                                                if (result == null) {
                                                  print("The null is on");
                                                } else if (result == true) {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'تمت العملية بنجاح'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                        Colors.teal,
                                                      ),
                                                    );
                                                  }
                                                  setState(() {});
                                                } else {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'حدثت مشكلة أثناء التنفيذ, حاول مرة أخرى'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                        Colors.teal,
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
                                ),

                                //Address card
                                Container(
                                  padding: EdgeInsets.all(16.0.h),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15.0.h),
                                    ),
                                    elevation: 20.h,
                                    shadowColor: Colors.teal.withOpacity(0.7),
                                    // إضافة تأثير الظل الخفيف
                                    color: Colors.white,
                                    // لون الخلفية البيضاء
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.0.h,
                                              top: 16.0.h,
                                              bottom: 16.0.h),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        "العنوان",
                                                        style: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900),
                                                      ),
                                                      subtitle: Text(
                                                        personalProfile
                                                            .patient!.address,
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900),
                                                      ),
                                                      leading: Icon(
                                                        Icons.location_on,
                                                        size: 35.w,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //اشارة الاكس
                                        Positioned(
                                          top: 10.h,
                                          left: 6.w,
                                          // تغيير الموضع إلى الزاوية اليمنى
                                          child: Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              // لون خلفية الزر
                                              borderRadius:
                                              BorderRadius.circular(
                                                  50), // جعل الشكل دائرياً
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add_circle_rounded,
                                                color: Colors.teal,
                                                size: 30.w,
                                              ),
                                              // أيقونة إكس باللون الأحمر
                                              onPressed: ()async {
                                                bool? result =
                                                await  CustomDialogAnimation
                                                    .showCustomDialogPersonal(
                                                    context,
                                                    DialogAddress( patientID:  personalProfile.patient!.patientID!, dataBaseMain: widget.dataBaseMain,)
                                                );
                                                if (result == null) {
                                                  print("The null is on");
                                                } else if (result == true) {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'تمت العملية بنجاح'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                        Colors.teal,
                                                      ),
                                                    );
                                                  }
                                                  setState(() {});
                                                } else {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'حدثت مشكلة أثناء التنفيذ, حاول مرة أخرى'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                        Colors.teal,
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
                                ),

                                //General State card
                                Container(
                                  padding: EdgeInsets.all(16.0.h),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15.0.h),
                                    ),
                                    elevation: 20.h,
                                    shadowColor: Colors.teal.withOpacity(0.7),
                                    // إضافة تأثير الظل الخفيف
                                    color: Colors.white,
                                    // لون الخلفية البيضاء
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.0.h,
                                              top: 16.0.h,
                                              bottom: 16.0.h),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        "الحالة العامة ",
                                                        style: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900),
                                                      ),
                                                      subtitle: Text(
                                                        personalProfile
                                                            .patient!.status,
                                                        style: TextStyle(
                                                            fontSize: 17.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900),
                                                      ),
                                                      leading: Icon(
                                                        Icons.paste,
                                                        size: 32.w,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //اشارة الاكس
                                        Positioned(
                                          top: 10.h,
                                          left: 6.w,
                                          // تغيير الموضع إلى الزاوية اليمنى
                                          child: Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              // لون خلفية الزر
                                              borderRadius:
                                              BorderRadius.circular(
                                                  50), // جعل الشكل دائرياً
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add_circle_rounded,
                                                color: Colors.teal,
                                                size: 30.w,
                                              ),
                                              // أيقونة إكس باللون الأحمر
                                              onPressed: () async{
                                                bool? result =
                                                await  CustomDialogAnimation
                                                    .showCustomDialogPersonal(
                                                    context,
                                                    DialogGeneralState(patientID:  personalProfile.patient!.patientID!, dataBaseMain: widget.dataBaseMain,));
                                                if (result == null) {
                                                  print("The null is on");
                                                } else if (result == true) {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'تمت العملية بنجاح'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                        Colors.teal,
                                                      ),
                                                    );
                                                  }
                                                  setState(() {});
                                                } else {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'حدثت مشكلة أثناء التنفيذ, حاول مرة أخرى'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                        Colors.teal,
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
                                ),

                                //Payments card
                                ListView(
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0.h),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(15.0.h),
                                          ),
                                          elevation: 20.h,
                                          shadowColor:
                                          Colors.teal.withOpacity(0.7),
                                          // إضافة تأثير الظل الخفيف
                                          color: Colors.white,
                                          // لون الخلفية البيضاء
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0.h,
                                                    top: 16.0.h,
                                                    bottom: 16.0.h,
                                                    right: 10.0.h),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.monetization_on,
                                                      size: 32.w,
                                                      color: Colors.teal,
                                                    ),
                                                    SizedBox(
                                                      width: 6.w,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          //Name
                                                          SizedBox(
                                                              height: 15.h),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 100.w,
                                                                child: Text(
                                                                  'المبلغ المدفوع:  ',
                                                                  style: TextStyle(
                                                                      color: Colors.grey[700],
                                                                      // نفس لون النص الثانوي
                                                                      fontSize: 17.sp,
                                                                      // تكبير حجم النص قليلاً
                                                                      fontWeight: FontWeight.w900),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 30.w,
                                                              ),
                                                              Container(
                                                                width: 100.w,
                                                                height: 35.h,
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .teal[
                                                                    100],
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        7.h)),
                                                                child:
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  child: Text(
                                                                    payed,
                                                                    style: TextStyle(
                                                                        color: Colors.grey[700],
                                                                        // نفس لون النص الثانوي
                                                                        fontSize: 16.sp,
                                                                        // تكبير حجم النص قليلاً
                                                                        fontWeight: FontWeight.w900),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          SizedBox(
                                                              height: 15.h),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 100.w,
                                                                child: Text(
                                                                  'المبلغ المتبقي:',
                                                                  style: TextStyle(
                                                                      color: Colors.grey[700],
                                                                      // نفس لون النص الثانوي
                                                                      fontSize: 17.sp,
                                                                      // تكبير حجم النص قليلاً
                                                                      fontWeight: FontWeight.w900),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 30.w,
                                                              ),
                                                              Container(
                                                                width: 100.w,
                                                                height: 35.h,
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .teal,
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        7.h)),
                                                                child:
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .scaleDown,
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
                                                top: 10.h,
                                                left: 6.w,
                                                // تغيير الموضع إلى الزاوية اليمنى
                                                child: Container(
                                                  width: 40.w,
                                                  height: 40.h,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    // لون خلفية الزر
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        50), // جعل الشكل دائرياً
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.add_circle_rounded,
                                                      color: Colors.teal,
                                                      size: 30.w,
                                                    ),
                                                    // أيقونة إكس باللون الأحمر
                                                    onPressed: () async{
                                                      bool? result =
                                                      await  CustomDialogAnimation
                                                          .showCustomDialogPersonal(
                                                          context,
                                                          DialogPayments(patientID: personalProfile.patient!.patientID! , dataBaseMain: widget.dataBaseMain, paidMoney: personalProfile.patient!.paymentGot!, debtsMoney: personalProfile.patient!.paymentStill!,)
                                                      );
                                                      if (result == null) {
                                                        print("The null is on");
                                                      } else if (result == true) {
                                                        if (mounted) {
                                                          ScaffoldMessenger.of(
                                                              context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'تمت العملية بنجاح'),
                                                              duration: Duration(
                                                                  seconds: 2),
                                                              backgroundColor:
                                                              Colors.teal,
                                                            ),
                                                          );
                                                        }
                                                        setState(() {});
                                                      } else {
                                                        if (mounted) {
                                                          ScaffoldMessenger.of(
                                                              context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'حدثت مشكلة أثناء التنفيذ, حاول مرة أخرى'),
                                                              duration: Duration(
                                                                  seconds: 2),
                                                              backgroundColor:
                                                              Colors.teal,
                                                            ),
                                                          );
                                                        }
                                                      }

                                                      /* CustomDialogAnimation
                                                              .showCustomDialogPersonal(
                                                              context, const DialogPayments());
                                                          // قم بتنفيذ أي إجراء عند الضغط على الزر*/
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),

                                //Days card
                                Container(
                                  padding: EdgeInsets.all(16.0.h),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15.0.h),
                                    ),
                                    elevation: 20.h,
                                    shadowColor: Colors.teal.withOpacity(0.7),
                                    // إضافة تأثير الظل الخفيف
                                    color: Colors.white,
                                    // لون الخلفية البيضاء
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.0.h,
                                              top: 16.0.h,
                                              bottom: 16.0.h),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        "أيام المواعيد",
                                                        style: TextStyle(
                                                            fontSize: 22.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900),
                                                      ),
                                                      subtitle: Text(
                                                        personalProfile
                                                            .daysNumbers!
                                                            .isEmpty
                                                            ? "لا يوجد مواعيد مخزنة مسبقا"
                                                            : daysName(
                                                            personalProfile
                                                                .daysNumbers!),
                                                        style: TextStyle(
                                                            fontSize: 19.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900),
                                                      ),
                                                      leading: Icon(
                                                        Icons.date_range,
                                                        size: 32.w,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //اشارة الاكس
                                        Positioned(
                                          top: 10.h,
                                          left: 6.w,
                                          // تغيير الموضع إلى الزاوية اليمنى
                                          child: Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              // لون خلفية الزر
                                              borderRadius:
                                              BorderRadius.circular(
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
                                                bool? result =
                                                await  CustomDialogAnimation
                                                    .showCustomDialogPersonal(
                                                    context,
                                                    DialogAppointmentDays(patientID: personalProfile.patient!.patientID!, dataBaseMain: widget.dataBaseMain,));
                                                if (result == null) {
                                                  print("The null is on");
                                                } else if (result == true) {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'تمت العملية بنجاح'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                        Colors.teal,
                                                      ),
                                                    );
                                                  }
                                                  setState(() {});
                                                } else {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'حدثت مشكلة أثناء التنفيذ, حاول مرة أخرى'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                        Colors.teal,
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

                                //Medical plan card
                                Container(
                                  padding: EdgeInsets.all(16.0.h),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(15.0.h),
                                    ),
                                    elevation: 20.h,
                                    shadowColor: Colors.teal.withOpacity(0.7),
                                    // إضافة تأثير الظل الخفيف
                                    color: Colors.white,
                                    // لون الخلفية البيضاء
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.0.h,
                                              top: 16.0.h,
                                              bottom: 16.0.h),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        "الخطة العلاجية ",
                                                        style: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900),
                                                      ),
                                                      subtitle: LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          return ConstrainedBox(
                                                            constraints:
                                                            BoxConstraints(
                                                                maxHeight:
                                                                150.h),
                                                            child:
                                                            SingleChildScrollView(
                                                              child: Text(
                                                                "${personalProfile.patient!.treatmentPlan}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    19.sp,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      leading: Icon(
                                                        Icons.paste,
                                                        size: 32.w,
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //اشارة الاكس
                                        Positioned(
                                          top: 10.h,
                                          left: 6.w,
                                          // تغيير الموضع إلى الزاوية اليمنى
                                          child: Container(
                                            width: 40.w,
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              // لون خلفية الزر
                                              borderRadius:
                                              BorderRadius.circular(
                                                  50), // جعل الشكل دائرياً
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add_circle_rounded,
                                                color: Colors.teal,
                                                size: 30.w,
                                              ),
                                              // أيقونة إكس باللون الأحمر
                                              onPressed: () async{

                                                bool? result =
                                                await  CustomDialogAnimation
                                                    .showCustomDialogPersonal(
                                                    context,
                                                    DialogMedicalPlan(dataBaseMain: widget.dataBaseMain, patientID: personalProfile.patient!.patientID!,));
                                                if (result == null) {
                                                  print("The null is on");
                                                } else if (result == true) {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'تمت العملية بنجاح'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                        Colors.teal,
                                                      ),
                                                    );
                                                  }
                                                  setState(() {});
                                                } else {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'حدثت مشكلة أثناء التنفيذ, حاول مرة أخرى'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                        Colors.teal,
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

                                //Dates Appointment Title
                                Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(right: 10.w),
                                  child: Text(
                                    "تواريخ الجلسات - ${personalProfile.dayTime?.length} -",
                                    style: TextStyle(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                //Dates Appointment card
                                SizedBox(
                                  height: 530.h,
                                  child: Card(
                                      color: Colors.teal[200],
                                      child: personalProfile.dayTime!.isEmpty
                                          ? Column(
                                        children: [
                                          Container(
                                            child: Lottie.asset(
                                              //#
                                              'assets/animations/Search_move_no_data.json',
                                              // مسار الملف
                                              fit: BoxFit
                                                  .cover, // ملاءمة الأنيميشن (اختياري)
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 16.h),
                                            padding: EdgeInsets.all(7.w),
                                            height: 70.h,
                                            width: 264.w,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "لا يوجد مواعيد لهذا المريض...",
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight:
                                                  FontWeight.w900,
                                                  color: Colors.teal),
                                            ),
                                          )
                                        ],
                                      )
                                          : ListView.builder(
                                          itemCount: personalProfile
                                              .dayTime?.length,
                                          physics:
                                          const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, i) {
                                            String? dateText =
                                                personalProfile
                                                    .dayTime![i].date;
                                            DateTime parsedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .parse(dateText!);

                                            int year =
                                                parsedDate.year; // السنة
                                            int day =
                                                parsedDate.day; // اليوم
                                            String dayName = DateFormat
                                                .EEEE('ar')
                                                .format(
                                                parsedDate); // اسم اليوم بالعربية
                                            String monthName = DateFormat
                                                .MMMM('ar')
                                                .format(
                                                parsedDate); // اسم الشهر بالعربية

                                            List<String>? timeParts =
                                            personalProfile
                                                .dayTime![i].time
                                                ?.split(":");
                                            int hour =
                                            int.parse(timeParts![0]);
                                            String period = (hour >= 12)
                                                ? "مساءً"
                                                : "صباحاً";
                                            return Padding(
                                              padding:
                                              EdgeInsets.all(10.0.h),
                                              child: Card(
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      15.0.h),
                                                ),
                                                elevation: 20.h,
                                                shadowColor: Colors.teal
                                                    .withOpacity(0.7),
                                                // إضافة تأثير الظل الخفيف
                                                color: Colors.white,
                                                // لون الخلفية البيضاء
                                                child: Stack(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.all(
                                                          16.0.h),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 16.w,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                //Name Day
                                                                Text(
                                                                  '$year ,$dayName',
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    18.sp,
                                                                    // تكبير حجم النص
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    color: Colors
                                                                        .black, // لون داكن أكثر للنص
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '$day',
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    50.sp,
                                                                    // تكبير حجم النص
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    color: Colors
                                                                        .black, // لون داكن أكثر للنص
                                                                  ),
                                                                ),
                                                                Text(
                                                                  monthName,
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    35.sp,
                                                                    // تكبير حجم النص
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    color: Colors
                                                                        .black, // لون داكن أكثر للنص
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                    15.h),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                color: Colors
                                                                    .black,
                                                                height:
                                                                150.h,
                                                                width: 2.w,
                                                                margin: EdgeInsets.only(
                                                                    top: 32.0
                                                                        .h),
                                                              ),
                                                              SizedBox(
                                                                width: 20.w,
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    '${personalProfile.dayTime![i].time}',
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        // نفس لون النص الثانوي
                                                                        fontSize: 35.sp,
                                                                        // تكبير حجم النص قليلاً
                                                                        fontWeight: FontWeight.w900),
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                    50.w,
                                                                    height:
                                                                    2.h,
                                                                    color: Colors
                                                                        .black,
                                                                    margin: EdgeInsets.only(
                                                                        top:
                                                                        10.h,
                                                                        right: 50.w),
                                                                  ),
                                                                  Text(
                                                                    period,
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        // نفس لون النص الثانوي
                                                                        fontSize: 30.sp,
                                                                        // تكبير حجم النص قليلاً
                                                                        fontWeight: FontWeight.w800),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          })),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              //Adding animation for error
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Lottie.asset(
                                        //#
                                        'assets/animations/Search_move_no_data.json',
                                        // مسار الملف
                                        fit: BoxFit
                                            .cover, // ملاءمة الأنيميشن (اختياري)
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16.h),
                                      padding: EdgeInsets.all(7.w),
                                      height: 70.h,
                                      width: 264.w,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "بيانات المريض غير مكتملة, حاول مرة أخرى...",
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.teal),
                                      ),
                                    )
                                  ],
                                ));
                          }
                        }
                        print("i am before the error Personal profile");
                        if (snapshot.hasError) {
                          print("i am inside the error Personal profile");
                          print(snapshot.error);
                          //Here replace it with icon on the errors
                          return Center(
                            //Adding animation for error #
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Lottie.asset(
                                      //#
                                      'assets/animations/Search_move_no_data.json',
                                      // مسار الملف
                                      fit: BoxFit
                                          .cover, // ملاءمة الأنيميشن (اختياري)
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 16.h),
                                    padding: EdgeInsets.all(7.w),
                                    height: 70.h,
                                    width: 264.w,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "حدث خطأ أثناء تحميل الملف الشخصي, حاول مرة أخرى...",
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.teal),
                                    ),
                                  )
                                ],
                              ));
                        }
                      }
                      print("i am after the get data");
                      //Here but an icon for fail
                      return Center(
                        //Adding the connection has fail one #
                        //Adding also a string something like
                        //Unexpected error happens in arabic yo
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Lottie.asset(
                                  //#
                                  'assets/animations/Search_move_no_data.json',
                                  // مسار الملف
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
                                  "حدث خطأ أثناء تحميل البيانات, حاول مرة أخرى...",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.teal),
                                ),
                              )
                            ],
                          ));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
