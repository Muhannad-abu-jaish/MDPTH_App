import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialogAnimation {

  static Future<bool?> showCustomDialogPersonal(BuildContext context , Widget dialogSpec)async {
    return await showGeneralDialog <bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 1500),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0.h),
            child: Align(
              alignment: Alignment.center,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0.w),
                ),
                child: dialogSpec,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.easeOutQuint;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = anim1.drive(tween);

        var fadeAnimation = anim1.drive(Tween(begin: 0.0, end: 1.0));

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

}