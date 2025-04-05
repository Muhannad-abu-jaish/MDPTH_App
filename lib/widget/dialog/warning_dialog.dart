
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/patients_query.dart';
import '../../model/databse_main.dart';

class WarningDialogContent extends StatefulWidget {
  final int patientID;
  final int appointmentID;
  final DataBaseMain dataBaseMain;
  const WarningDialogContent({super.key, required this.patientID, required this.appointmentID, required this.dataBaseMain});

  @override
  _WarningDialogContentState createState() => _WarningDialogContentState();
}

class _WarningDialogContentState extends State<WarningDialogContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _paidControllerDates = TextEditingController();
  final TextEditingController _debtsControllerDates = TextEditingController();
  PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles();
  String? _errorMessagePaid;
  String? _errorMessageDebts;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateInput(BuildContext context) async{
    String inputDebts = _debtsControllerDates.text.trim();
    String inputPaid = _paidControllerDates.text.trim();


    if (inputDebts.isEmpty) {
      _debtsControllerDates.text = "0"; // تعيين القيمة إلى صفر إذا كانت فارغة
    }
    if(inputPaid.isEmpty){
      _paidControllerDates.text = "0";
    }

    int valueDebts = int.tryParse(inputDebts) ?? 0;
    int valuePaid = int.tryParse(inputPaid) ?? 0;

    String messageTrue ="تمت عملية تأكيد الموعد بنجاح" ;
    String messageFalse ="حدثت مشكلة اثناء تأكيد الموعد" ;
    bool result = await patientsQueryHandles.confirmOneAppointment(widget.dataBaseMain, widget.appointmentID , widget.patientID ,valueDebts , valuePaid) ;
    if(result == true )
    {
      print(messageTrue) ;
    }else{
      print(messageFalse) ;

    }
    Navigator.of(context).pop(result);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Remove focus from the TextFormField
      },
      child: Padding(
        padding:  EdgeInsets.all(17.0.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.system_security_update_warning_outlined,
              color: Colors.black,
              size: 48.sp,


            ),

            SizedBox(height: 30.h,),

            //Paid
            Row(
              children: [
                Expanded(
                  child:  SizedBox(
                    width: 90.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'المبلغ المدفوع:  ',
                        style: TextStyle(
                            color: Colors.black87,
                            // نفس لون النص الثانوي
                            fontSize: 15.sp,
                            // تكبير حجم النص قليلاً
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Container(
                    width: 135.w,
                    height: 35.h,
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: _paidControllerDates,
                      keyboardType: TextInputType.number, // تحديد نوع لوحة المفاتيح للأرقام
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly, // يسمح بإدخال الأرقام فقط
                      ],
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelText: "الواصل",
                        contentPadding: EdgeInsets.only(right: 40.w),
                        labelStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w900,

                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.h),
                            borderSide:
                            BorderSide(color: Colors.teal, width: 2.w)
                        ),
                      ),
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
            SizedBox(height: 15.h,),

            //Debts
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 90.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'المبلغ المتبقي:  ',
                        style: TextStyle(
                            color: Colors.black87,
                            // نفس لون النص الثانوي
                            fontSize: 15.sp,
                            // تكبير حجم النص قليلاً
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Container(
                    width: 135.w,
                    height: 35.h,
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: _debtsControllerDates,
                      keyboardType: TextInputType.number, // تحديد نوع لوحة المفاتيح للأرقام
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly, // يسمح بإدخال الأرقام فقط
                      ],
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          labelText: "المتبقي",
                          contentPadding: EdgeInsets.only(right: 40.w),
                          labelStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w900,

                          ),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.h),
                              borderSide:
                              BorderSide(color: Colors.teal, width: 2.w)
                          )
                      ),
                      style: TextStyle(

                          color: Colors.grey[700],
                          // نفس لون النص الثانوي
                          fontSize: 15.sp,
                          // تكبير حجم النص قليلاً
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30.h,),

            //Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SizedBox(
                    width: 124.w,
                    height: 45.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[700]
                      ),
                      onPressed:()=> _validateInput(context),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          ' تأكيد البيانات',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w,),

                //Cancel button
                Expanded(
                  child: SizedBox(
                    width: 116.w,
                    height: 45.h,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black
                        ),
                        onPressed: ()async {
                          String messageTrue ="تمت عملية إلغاء الموعد بنجاح" ;
                          String messageFalse ="حدثت مشكلة اثناء إلغاء الموعد" ;
                          bool result = await patientsQueryHandles.cancelOneAppointment(widget.dataBaseMain, widget.appointmentID) ;
                          if(result == true )
                          {
                            print(messageTrue) ;
                          }else{
                            print(messageFalse) ;

                          }
                          Navigator.of(context).pop(result); // Close the dialog
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'إلغاء الموعد',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,)
          ],
        ),
      ),
    );
  }
}