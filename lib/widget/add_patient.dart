import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:diaa_pth/widget/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller/patients_query.dart';
import '../model/databse_main.dart';
import '../model/patient.dart';

class AddPatient extends StatefulWidget {
  final DataBaseMain dataBaseMain;
  const AddPatient({super.key, required this.dataBaseMain});

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _treatmentPlanController =
  TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _generalConditionController =
  TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<bool> _selectedDays = List.generate(7, (_) => false);
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeNickName = FocusNode();
  final FocusNode _focusNodeAge = FocusNode();
  final FocusNode _focusNodePlan = FocusNode();
  final FocusNode _focusNodeAddress = FocusNode();
  final FocusNode _focusNodeGeneralState = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();

  late Patient _patient;

  final String notAdded = "لا يوجد";

  final PatientsQueryHandles _patientsQueryHandles = PatientsQueryHandles();



  //Send the data to the data base
  Future<void> _submitData() async {
    try{
      print('Name: ${_nameController.text}');
      print('Age: ${_ageController.text}');
      print('Selected Days: $_selectedDays');
      print('Treatment Plan: ${_treatmentPlanController.text}');
      print('Address: ${_addressController.text}');
      print('General Condition: ${_generalConditionController.text}');
      print('General Condition: ${_phoneNumberController.text}');

      _patient = Patient(
          name: textIsEmpty(_nameController.text),
          days: _selectedDays,
          nickName: textIsEmpty(_nickNameController.text),
          age: textIsEmpty(_ageController.text),
          address: textIsEmpty(_addressController.text),
          status: textIsEmpty(_generalConditionController.text),
          phoneNumber: textIsEmpty(_phoneNumberController.text),
          treatmentPlan: textIsEmpty(_treatmentPlanController.text)
      );
      //Here where i want to send the data

      bool result =  await _patientsQueryHandles.insertsDataToPatient(_patient ,widget.dataBaseMain);

      //There is a return result
      if (result) {
        if(!mounted)return;//في حالة الودجت ازيلت من الشجرة

        //If the operation of adding with no errors
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إضافة المريض بنجاح'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.teal,
          ),
        );

        print("am hereeeee bo yyyyyyyyy");
        //Back to the patients screen
        Future.delayed(const Duration(seconds: 1), () {
          if(mounted){
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePagePhysics(dataBaseMain: widget.dataBaseMain,)),
                  (route) => false,
            );
          }
        }
        );
      }
      //If the result is false for any reason
      else
      {
        if(mounted)
        {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('فشل عملية إضافة مريض.. حاول مرة أخرى ')
              )
          );
          _generalConditionController.clear();
          _addressController.clear();
          _ageController.clear();
          _nameController.clear();
          _phoneNumberController.clear();
          _treatmentPlanController.clear();
        }
      }

    }catch(e){
      //If there is an exception
      if(mounted)
      {
        print("errrroooorrr$e");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('فشل عملية إضافة مريض.. حاول مرة أخرى'),
              backgroundColor: Colors.teal,
            )
        );
        _generalConditionController.clear();
        _addressController.clear();
        _ageController.clear();
        _nameController.clear();
        _phoneNumberController.clear();
        _treatmentPlanController.clear();
        _nickNameController.clear();
      }
    }
  }

  //To check if the editTextField is empty to store the right result
  String textIsEmpty(String textEdit) {
    if (textEdit.isEmpty) return notAdded;

    return textEdit;
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _treatmentPlanController.dispose();
    _phoneNumberController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _generalConditionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
              vertical: BorderSide(
                color: Colors.teal.shade200,
                width: 6.w,
              ),
            ),
            borderRadius: BorderRadius.circular(20.0.w),
          ),
          margin: EdgeInsets.only(
              left: 6.0.w, right: 6.0.w, bottom: 14.0.w, top: 40.0.w),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Add patient title
                  Row(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 16.h, right: 33.w),
                            padding: EdgeInsets.all(7.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey.shade600,
                                    Colors.tealAccent
                                  ],
                                )),
                            height: 55.h,
                            width: 264.w,
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "إضافة مريض",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 35.h),

                  //Add patient field
                  SizedBox(
                    width: 300.w,
                    child: Form(
                      key: _formKey,
                      child: AnimatedTextField(
                        validator: (value){
                          //check if is empty
                          if (value == null || value.isEmpty) {
                            return 'يجب أن تدخل اسم للمريض';
                          }
                          return null;

                        },
                        focusNode: _focusNodeName,
                        animationType: Animationtype.fade,
                        controller: _nameController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                        hintTexts: const [
                          'اسم المريض',
                          'اسم المريض هنا',
                          'اكتب اسم المريض هنا'
                        ],
                        hintTextStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)),
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white54,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),

                  //Add the nickName field
                  SizedBox(
                    width: 300.w,
                    child: AnimatedTextField(
                      focusNode: _focusNodeNickName,
                      animationType: Animationtype.fade,
                      controller: _nickNameController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                      ],
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                      hintTexts: const [
                        'لقب المريض',
                        'لقب المريض هنا',
                        'اكتب لقب المريض هنا'
                      ],
                      hintTextStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white54,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),

                  //Add age field
                  SizedBox(
                    width: 300.w,
                    child: AnimatedTextField(
                      focusNode: _focusNodeAge,
                      animationType: Animationtype.fade,
                      controller: _ageController,
                      hintTexts: const ['العمر', 'العمر هنا', 'اكتب العمر هنا'],
                      hintTextStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 22.h),

                  //Days Appointment
                  Text('تحديد أيام المواعيد',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      )),
                  SizedBox(height: 10.h),
                  //Add Days Appointment
                  SizedBox(
                    width: 300.w,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ToggleButtons(
                        isSelected: _selectedDays,
                        onPressed: (int index) {
                          setState(() {
                            _selectedDays[index] = !_selectedDays[index];
                          });
                        },
                        color: Colors.black,
                        selectedBorderColor: Colors.orange,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                        borderColor: Colors.teal,
                        borderWidth: 2.w,
                        highlightColor: Colors.teal,
                        borderRadius: BorderRadius.circular(17.h),
                        children: [
                          for (var day in [
                            'الأحد',
                            'الاثنين',
                            'الثلاثاء',
                            'الأربعاء',
                            'الخميس',
                            'الجمعة',
                            'السبت'
                          ])
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.h),
                              child: Container(
                                  width: 70,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text(day)),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 23.h),
                  //Add Patient plan
                  SizedBox(
                    width: 300.w,
                    child: AnimatedTextField(
                      focusNode: _focusNodePlan,
                      animationType: Animationtype.fade,
                      controller: _treatmentPlanController,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                      hintTexts: const [
                        'الخطة العلاجية',
                        'الخطة العلاجية هنا',
                        'اكتب الخطة العلاجية هنا',
                        'مشان الله اكتب الخطة هنا'
                      ],
                      hintTextStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold),
                      maxLines: 7,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white54,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      ),
                    ),
                  ),

                  SizedBox(height: 23.h),

                  //Add Address
                  SizedBox(
                    width: 300.w,
                    child: AnimatedTextField(
                      focusNode: _focusNodeAddress,
                      animationType: Animationtype.fade,
                      controller: _addressController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(45),
                      ],
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                      hintTexts: const [
                        'العنوان',
                        'العنوان هنا',
                        'اكتب العنوان هنا',
                        'مشان الله اكتب العنوان هنا'
                      ],
                      hintTextStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white54,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 23.h),

                  //Add General state
                  SizedBox(
                    width: 300.w,
                    child: AnimatedTextField(
                      focusNode: _focusNodeGeneralState,
                      animationType: Animationtype.fade,
                      controller: _generalConditionController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                      ],
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                      hintTexts: const [
                        'الحالة العامة للمريض',
                        'الحالة العامة للمريض هنا',
                        'الحالة العامة للمريض هنا'
                      ],
                      hintTextStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white54,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 23.h),

                  //Add Phone number
                  SizedBox(
                    width: 300.w,
                    child: AnimatedTextField(
                      focusNode: _focusNodePhone,
                      animationType: Animationtype.fade,
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                      hintTexts: const [
                        'رقم الهاتف',
                        'رقم الهاتف هنا',
                        'اكتب رقم الهاتف هنا',
                        'مشان الله اكتب رقم الهاتف هناا'
                      ],
                      hintTextStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white54,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),

                  //Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Add Button
                      SizedBox(
                        width: 110.w,
                        height: 40.h,
                        /*decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.h),
                            border: Border.all(color: Colors.teal, width: 4.w)),*/
                        child: ElevatedButton(
                          onPressed: () {
                            // If there is a name for the patient
                            if (_formKey.currentState!.validate()) {
                              // تنفيذ العملية المطلوبة هنا
                              _submitData();
                            }

                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'إضافة',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 50.w),
                      //Cancel Button
                      SizedBox(
                        width: 110.w,
                        height: 40.h,
                        /* decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.h),
                            border: Border.all(color: Colors.teal, width: 4.w)),*/
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                                  return  HomePagePhysics(dataBaseMain: widget.dataBaseMain,);
                                }), (route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'إلغاء',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
