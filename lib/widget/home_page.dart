import 'package:flutter/material.dart';
import 'package:diaa_pth/widget/days_circle_dialog.dart';
import 'package:diaa_pth/widget/patients.dart';
import 'package:diaa_pth/widget/payments.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/databse_main.dart';

class HomePagePhysics extends StatefulWidget {
  final DataBaseMain dataBaseMain;
  const HomePagePhysics({super.key, required this.dataBaseMain});

  @override
  State<HomePagePhysics> createState() => _HomePagePhysicsState();
}

class _HomePagePhysicsState extends State<HomePagePhysics> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index) ;
    setState(() {
      selectedIndex = index ;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // قائمة الصفحات التي سيتم التنقل بينها
    final List<Widget> widgetPages =  [
      DaysCircleDialog(dataBaseMain:widget.dataBaseMain,),
      Patients(dataBaseMain:widget.dataBaseMain,),
      Payments(dataBaseMain:widget.dataBaseMain,)
    ];
    return Scaffold(
      drawer: const Drawer(),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35.w,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black87,
        unselectedLabelStyle:  TextStyle(fontSize: 13.sp , fontWeight: FontWeight.w900),
        selectedLabelStyle:  TextStyle(fontSize: 17.sp , fontWeight: FontWeight.w900),
        onTap: _onItemTapped,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined , size: 42.w,),
            label: "المواعيد",
          ),
          BottomNavigationBarItem(

            icon: Icon(Icons.supervised_user_circle_rounded  , size: 42.w, ),
            label: "المرضى",

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined , size: 42.w,),
            label: "الدفعات",
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: widgetPages,

      ),
    );
  }
}

