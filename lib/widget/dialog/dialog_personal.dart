import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/patients_query.dart';
import '../../model/databse_main.dart';

class DialogPersonal extends StatefulWidget {
  final int patientID;
  final DataBaseMain dataBaseMain;
  const DialogPersonal({super.key, required this.patientID, required this.dataBaseMain});

  @override
  State<DialogPersonal> createState() => _DialogPersonalState();
}

class _DialogPersonalState extends State<DialogPersonal>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _controllerPersonalEdit;
  final TextEditingController _nameControllerEdit = TextEditingController();
  final TextEditingController _nickNameControllerEdit = TextEditingController();
  final TextEditingController _numberControllerEdit = TextEditingController();
  final TextEditingController _ageControllerEdit = TextEditingController();
  PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles() ;

  void sendData(BuildContext context) async{

    String messageTrue ="تمت عملية تأكيد الموعد بنجاح" ;
    String messageFalse ="حدثت مشكلة اثناء تأكيد الموعد" ;
    bool result = await patientsQueryHandles.updateInformationByID(widget.dataBaseMain, widget.patientID, _nameControllerEdit.text, _nickNameControllerEdit.text , _ageControllerEdit.text , _numberControllerEdit.text) ;
    if(result == true )
    {
      print(messageTrue) ;
    }else{
      print(messageFalse) ;

    }
    Navigator.of(context).pop(result);
  }
  @override
  void initState() {
    _controllerPersonalEdit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controllerPersonalEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Remove focus from the TextFormField
      },
      child: Padding(
        padding: EdgeInsets.all(1.0.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person,
              color: Colors.black,
              size: 80.sp,
            ),

            Form(
                key: _formKey,
                child: Column(
                  children: [
                    //Full name
                    Container(
                      width: 235.w,
                      height: 45.h,
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: _nameControllerEdit,
                        keyboardType: TextInputType.name,
                        // تحديد نوع لوحة المفاتيح للأرقام
                        textAlign: TextAlign.right,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        decoration: InputDecoration(
                          labelText: "الاسم الكامل",
                          contentPadding: EdgeInsets.only(right: 20.w),
                          labelStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w900,
                          ),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide: BorderSide(color: Colors.red, width: 2.w), // إطار عند الخطأ
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide: BorderSide(color: Colors.red, width: 2.w), // إطار عند التركيز مع الخطأ
                          ),
                        ),
                        style: TextStyle(
                            color: Colors.grey[700],
                            // نفس لون النص الثانوي
                            fontSize: 15.sp,
                            // تكبير حجم النص قليلاً
                            fontWeight: FontWeight.w900),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "يرجى إدخال الاسم المعدل";
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 12.h,),

                    //Nick name
                    Container(
                      width: 235.w,
                      height: 45.h,
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: _nickNameControllerEdit,
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(11),
                        ],
                        // تحديد نوع لوحة المفاتيح للأرقام
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: "اللقب",
                          contentPadding: EdgeInsets.only(right: 20.w),
                          labelStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w900,
                          ),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide: BorderSide(color: Colors.red, width: 2.w), // إطار عند الخطأ
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide: BorderSide(color: Colors.red, width: 2.w), // إطار عند التركيز مع الخطأ
                          ),
                        ),
                        style: TextStyle(
                            color: Colors.grey[700],
                            // نفس لون النص الثانوي
                            fontSize: 15.sp,
                            // تكبير حجم النص قليلاً
                            fontWeight: FontWeight.w900),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "يرجى إدخال اللقب المعدل";
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 12.h,),
                    //Number
                    Container(
                      width: 235.w,
                      height: 45.h,
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: _numberControllerEdit,
                        keyboardType: TextInputType.number,

                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: "رقم الهاتف",
                          contentPadding: EdgeInsets.only(right: 20.w),
                          labelStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w900,
                          ),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide: BorderSide(color: Colors.red, width: 2.w), // إطار عند الخطأ
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide: BorderSide(color: Colors.red, width: 2.w), // إطار عند التركيز مع الخطأ
                          ),
                        ),
                        style: TextStyle(
                            color: Colors.grey[700],
                            // نفس لون النص الثانوي
                            fontSize: 15.sp,
                            // تكبير حجم النص قليلاً
                            fontWeight: FontWeight.w900),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "يرجى إدخال الرقم المعدل";
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 12.h,),

                    //Age
                    Container(
                      width: 235.w,
                      height: 45.h,
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: _ageControllerEdit,
                        keyboardType: TextInputType.number,
                        // تحديد نوع لوحة المفاتيح للأرقام
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: "العمر",
                          contentPadding: EdgeInsets.only(right: 20.w),
                          labelStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w900,
                          ),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide: BorderSide(color: Colors.red, width: 2.w), // إطار عند الخطأ
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide: BorderSide(color: Colors.red, width: 2.w), // إطار عند التركيز مع الخطأ
                          ),
                        ),
                        style: TextStyle(
                            color: Colors.grey[700],
                            // نفس لون النص الثانوي
                            fontSize: 15.sp,
                            // تكبير حجم النص قليلاً
                            fontWeight: FontWeight.w900),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "يرجى إدخال العمر المعدل";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),

                  ],
                )
            ),
            //Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Confirm Button
                SizedBox(
                  width: 130.w,
                  height: 45.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendData(context);
                        print("جميع الحقول مملوءة");
                      } else {
                        // يوجد خطأ في أحد الحقول
                        print("هناك أخطاء في الإدخال");
                      }
                    },
                    child: Text(
                      ' تأكيد البيانات',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            )
          ],
        ),
      ),
    );
  }
}
