import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/patients_query.dart';
import '../../model/databse_main.dart';

class DialogGeneralState extends StatefulWidget {
  final DataBaseMain dataBaseMain;
  final int patientID;
  const DialogGeneralState({super.key, required this.dataBaseMain, required this.patientID});


  @override
  State<DialogGeneralState> createState() => _DialogGeneralStateState();
}

class _DialogGeneralStateState extends State<DialogGeneralState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controllerGeneralStateEdit;
  final TextEditingController _generalStateControllerEdit =
  TextEditingController();
  PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void sendData(BuildContext context) async{

    String messageTrue ="تمت عملية تأكيد الموعد بنجاح" ;
    String messageFalse ="حدثت مشكلة اثناء تأكيد الموعد" ;
    bool result = await patientsQueryHandles.updateStatusByID(widget.dataBaseMain, widget.patientID , _generalStateControllerEdit.text);
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
    _controllerGeneralStateEdit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controllerGeneralStateEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              height: 35.h,
            ),

            //General State
            Container(
              width: 235.w,
              height: 65.h,
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _generalStateControllerEdit,
                  keyboardType: TextInputType.name,
                  // تحديد نوع لوحة المفاتيح للأرقام
                  textAlign: TextAlign.right,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  decoration: InputDecoration(
                      labelText: "الحالة العامة",
                      contentPadding: EdgeInsets.all(20.h),
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                      ),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.h),
                          borderSide: BorderSide(color: Colors.teal, width: 2.w)),
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
                      )
                  ),
                  style: TextStyle(
                      color: Colors.grey[700],
                      // نفس لون النص الثانوي
                      fontSize: 15.sp,
                      // تكبير حجم النص قليلاً
                      fontWeight: FontWeight.w900),
                  validator: (value){
                    if (value == null || value.trim().isEmpty) {
                      return "يرجى إدخال الحالة العامة المعدلة";
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
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black),
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
