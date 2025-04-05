import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/patients_query.dart';
import '../../model/databse_main.dart';

class DialogRemovePatient extends StatefulWidget {
  final int patientID;
  final DataBaseMain dataBaseMain;
  const DialogRemovePatient({super.key, required this.patientID, required this.dataBaseMain});

  @override
  State<DialogRemovePatient> createState() => _DialogRemovePatientState();
}

class _DialogRemovePatientState extends State<DialogRemovePatient> with SingleTickerProviderStateMixin {

  late AnimationController _controllerRemovePatient;
  final TextEditingController _addressControllerEdit = TextEditingController();
  PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles();

  @override
  void initState() {
    _controllerRemovePatient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controllerRemovePatient.dispose();
    super.dispose();
  }
  /* void showToast(String message, bool isSuccess) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }*/
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
              Icons.remove_circle,
              color: Colors.black,
              size: 66.sp,
            ),

            SizedBox(
              height: 15.h,
            ),

            //Remove Patient check
            Container(
              width: 275.w,
              height: 25.h,
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "هل أنت متأكد من عملية حذف المريض؟",
                  style: TextStyle(
                      color: Colors.black,
                      // نفس لون النص الثانوي
                      fontSize: 15.sp,
                      // تكبير حجم النص قليلاً
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),

            Container(
              width: 235.w,
              height: 25.h,
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "قد تكون هنالك معلومات مهمة هنا!!!",
                  style: TextStyle(
                      color: Colors.black,
                      // نفس لون النص الثانوي
                      fontSize: 16.sp,
                      // تكبير حجم النص قليلاً
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),

            SizedBox(
              height: 25.h,
            ),

            //Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Confirm Button
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: 43.h,
                        maxHeight: 80.h

                    ),
                    width: 109.w,
                    height: 43.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[800]),
                      onPressed: () async {
                        String messageTrue ="تمت عملية الحذف بنجاح" ;
                        String messageFalse ="حدثت مشكلة اثناء عملية الحذف" ;
                        bool res = await patientsQueryHandles.deletePatientById(widget.dataBaseMain, widget.patientID);
                        if(res == true )
                        {
                          //showToast(messageTrue, res);
                          print(messageTrue) ;
                        }else{
                          print(messageFalse) ;
                          //showToast(messageFalse, res);
                        }

                        Navigator.of(context).pop(res); // Close the dialog
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          ' تأكيد العملية',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 7.w,),
                //Cancel Button
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: 43.h,
                        maxHeight: 80.h
                    ),
                    width: 114.w,
                    height: 43.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: () {
                        //Here just off the operation
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'إلغاء العملية',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
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
