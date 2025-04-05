import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/patients_query.dart';
import '../../model/databse_main.dart';

class DialogPayments extends StatefulWidget {
  final int patientID ;
  final DataBaseMain dataBaseMain ;
  final double paidMoney;
  final double debtsMoney;
  const DialogPayments({super.key, required this.patientID, required this.dataBaseMain, required this.paidMoney, required this.debtsMoney});


  @override
  State<DialogPayments> createState() => _DialogPaymentsState();
}

class _DialogPaymentsState extends State<DialogPayments> with SingleTickerProviderStateMixin {

  late AnimationController _controllerPayments;
  final TextEditingController _paidControllerPayments = TextEditingController();
  PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles() ;

  void _validateInput(BuildContext context) async{
    String inputPaid = _paidControllerPayments.text.trim();
    double valuePaid;

    if (inputPaid.isEmpty) {
      _paidControllerPayments.text = "0"; // تعيين القيمة إلى صفر إذا كانت فارغة

      Navigator.of(context).pop();
    }else{
      valuePaid = double.tryParse(inputPaid) ?? 0;
      double debtsSend = widget.debtsMoney - valuePaid;
      if(debtsSend <0 )
      {
        debtsSend = 0 ;
      }
      double paidSend = valuePaid + widget.paidMoney ;

      String messageTrue ="تمت عملية تأكيد الموعد بنجاح" ;
      String messageFalse ="حدثت مشكلة اثناء تأكيد الموعد" ;
      bool result = await patientsQueryHandles.updateDebtsByID(widget.dataBaseMain, widget.patientID, paidSend, debtsSend) ;
      if(result == true )
      {
        print(messageTrue) ;
      }else{
        print(messageFalse) ;

      }
      Navigator.of(context).pop(result);
    }


  }
  @override
  void initState() {
    _controllerPayments = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controllerPayments.dispose();
    super.dispose();
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
              Icons.attach_money,
              color: Colors.black,
              size: 80.sp,

            ),

            SizedBox(height: 25.h,),

            //Paid
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 80.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'المبلغ المدفوع:  ',
                        style: TextStyle(
                            color: Colors.black87,
                            // نفس لون النص الثانوي
                            fontSize: 16.sp,
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
                    height: 45.h,
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: _paidControllerPayments,
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
                          )
                      ),
                      style: TextStyle(

                          color: Colors.grey[700],
                          // نفس لون النص الثانوي
                          fontSize: 15.sp,
                          // تكبير حجم النص قليلاً
                          fontWeight: FontWeight.w900),
                    ),
                  ),)
              ],
            ),
            SizedBox(height: 35.h,),



            //Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Confirm Button
                Expanded(
                  child: SizedBox(
                    width: 130.w,
                    height: 45.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black
                      ),
                      onPressed: () =>_validateInput(context),
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
              ],
            ),
            SizedBox(height: 20.h,)
          ],
        ),
      ),
    );
  }
}
