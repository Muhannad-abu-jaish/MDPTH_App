import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/patients_query.dart';
import '../../model/databse_main.dart';

class DialogMedicalPlan extends StatefulWidget {
  final int patientID;
  final DataBaseMain dataBaseMain;
  const DialogMedicalPlan({super.key, required this.patientID, required this.dataBaseMain});

  @override
  State<DialogMedicalPlan> createState() => _DialogMedicalPlanState();
}

class _DialogMedicalPlanState extends State<DialogMedicalPlan> with SingleTickerProviderStateMixin{

  late AnimationController _controllerMedicalPlanEdit;
  final TextEditingController _medicalPlanControllerEdit = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles();

  void sendData(BuildContext context) async{

    String messageTrue ="تمت عملية تأكيد الموعد بنجاح" ;
    String messageFalse ="حدثت مشكلة اثناء تأكيد الموعد" ;
    bool result = await patientsQueryHandles.updatePlanByID(widget.dataBaseMain, widget.patientID, _medicalPlanControllerEdit.text) ;
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
    _controllerMedicalPlanEdit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controllerMedicalPlanEdit.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return  GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Remove focus from the TextFormField
      },
      child: Padding(
        padding: EdgeInsets.all(17.0.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.paste,
              color: Colors.black,
              size: 80.sp,
            ),

            SizedBox(
              height: 25.h,
            ),

            //Add Medical plan
            Container(
              width: 235.w,
              height: 115.h,
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _medicalPlanControllerEdit,
                  keyboardType: TextInputType.multiline,
                  maxLines: 7,
                  // تحديد نوع لوحة المفاتيح للأرقام
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                      labelText: "الخطة العلاجية",
                      contentPadding: EdgeInsets.all(20.w),
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
                          BorderSide(color: Colors.teal, width: 2.w))),
                  style: TextStyle(
                      color: Colors.grey[700],
                      // نفس لون النص الثانوي
                      fontSize: 15.sp,
                      // تكبير حجم النص قليلاً
                      fontWeight: FontWeight.w900),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "يرجى إدخال العنوان المعدل";
                    }
                    return null;
                  },
                ),
              ),
            ),

            SizedBox(
              height: 35.h,
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
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }
}
