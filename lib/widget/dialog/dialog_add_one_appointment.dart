import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DialogAddOneAppointment extends StatefulWidget {
  const DialogAddOneAppointment({super.key});

  @override
  State<DialogAddOneAppointment> createState() =>
      _DialogAddOneAppointmentState();
}

class _DialogAddOneAppointmentState extends State<DialogAddOneAppointment>
    with SingleTickerProviderStateMixin {
  late AnimationController _controllerAddOneAppointment;

  DateTime? _selectedDate; // متغير لتخزين التاريخ المختار
  String? _dayName; // متغير لتخزين اسم اليوم

  @override
  void initState() {
    _controllerAddOneAppointment = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controllerAddOneAppointment.dispose();
    super.dispose();
  }

  // دالة لاختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal, // لون الشريط العلوي
            hintColor: Colors.teal, // لون العنصر المحدد
            colorScheme: const ColorScheme.light(primary: Colors.teal),
            buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary), // لون أزرار
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dayName = DateFormat.EEEE('ar')
            .format(_selectedDate!); // استخراج اسم اليوم باللغة العربية
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(17.0.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.date_range_sharp,
            color: Colors.black,
            size: 80.sp,
          ),
          SizedBox(
            height: 15.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _selectedDate == null
                    ? 'يرجى اختيار تاريخ'
                    : 'التاريخ المختار: ${DateFormat.yMMMMd('ar').format(_selectedDate!)}',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900),
              ),
              _selectedDate == null
                  ? SizedBox(height: 0.h)
                  : SizedBox(
                height: 20.h,
              ),
              Text(
                _dayName == null ? '' : ' اليوم: $_dayName',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900),
              ),
              _dayName == null ? SizedBox(height: 0.h) : SizedBox(height: 30.h),
              SizedBox(
                width: 120.w,
                height: 45.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[800]),
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(
                    'اختيار يوم',
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
            height: 25.h,
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
                    //Here the code for the query of DB
                    Navigator.of(context).pop(); // Close the dialog
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
    );
  }
}
