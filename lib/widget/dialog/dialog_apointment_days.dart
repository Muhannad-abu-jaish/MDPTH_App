
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/patients_query.dart';
import '../../model/databse_main.dart';

class DialogAppointmentDays extends StatefulWidget {
  final int patientID;
  final DataBaseMain dataBaseMain ;
  const DialogAppointmentDays({super.key, required this.patientID, required this.dataBaseMain});

  @override
  State<DialogAppointmentDays> createState() => _DialogAppointmentDaysState();
}

class _DialogAppointmentDaysState extends State<DialogAppointmentDays> with SingleTickerProviderStateMixin{

  late AnimationController _controllerAppointmentDaysEdit;
  PatientsQueryHandles patientsQueryHandles =PatientsQueryHandles();
  final List<bool> _selectedDays = List.generate(7, (_) => false);

  void sendData(BuildContext context) async {
    String messageTrue ="تمت عملية تأكيد الموعد بنجاح";
    String messageFalse ="حدثت مشكلة اثناء تأكيد الموعد";
    print(_selectedDays);
    bool result = await patientsQueryHandles.updateAppointmentsDays(widget.dataBaseMain , widget.patientID , _selectedDays);
    if(result == true )
    {
      print(messageTrue);
    }else{
      print(messageFalse);
    }
    Navigator.of(context).pop(result);
  }

  @override
  void initState() {
    _controllerAppointmentDaysEdit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controllerAppointmentDaysEdit.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    print(_selectedDays) ;
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
              Icons.date_range,
              color: Colors.black,
              size: 80.sp,
            ),

            SizedBox(
              height: 15.h,
            ),
            SizedBox(
              width: 300.w,
              child: Column(
                children: [
                  for(int i = 0; i < _selectedDays.length; i += 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int j = i; j < i + 3 && j < _selectedDays.length; j++)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                            child: ToggleButtons(
                              isSelected: [_selectedDays[j]],
                              onPressed: (int index) {
                                setState(() {
                                  _selectedDays[j] = !_selectedDays[j];
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
                                Container(
                                  constraints: BoxConstraints(
                                      minWidth: 66.w,
                                      maxWidth: 80.w
                                  ),
                                  width: 66.w,
                                  height: 40.h,
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit:BoxFit.scaleDown,
                                    child: Text(
                                      ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'][j],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            //Button Confirm Information
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Confirm Button
                Container(
                  width: 130.w,
                  height: 45.h,
                  constraints: BoxConstraints(
                      minHeight: 55.h,
                      maxHeight: 80.h
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black),
                    onPressed: () {
                      sendData(context) ;
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        ' تأكيد البيانات',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
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
