import 'package:diaa_pth/templet_usage/custom_dialog_animation.dart';
import 'package:diaa_pth/widget/dialog/dialog_remove_patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../controller/patients_query.dart';
import '../model/databse_main.dart';
import '../model/patient.dart';
import '../templet_usage/remove_patient_dialog.dart';
import 'add_patient.dart';
import 'personal_profile.dart';

final GlobalKey<_PatientsState> _globalKey = GlobalKey();
class Patients extends StatefulWidget {
  final DataBaseMain dataBaseMain;

  const Patients({super.key, required this.dataBaseMain});

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> with SingleTickerProviderStateMixin{
  List<Patient> patientsData = [];
  List items = [
    {
      "icon": Icons.person_pin_rounded,
      "title": "محمد سالم ابو زيد",
      "subtitle": "الشارع الشمالي",
      "price": "كسر قدم"
    },
    {
      "icon": Icons.person_pin_rounded,
      "title": "احمد النواصرة",
      "subtitle": "ابطع الشارع الاوسط",
      "price": "خلع كتف"
    },
    {
      "icon": Icons.person_pin_rounded,
      "title": "صفوان احمد",
      "subtitle": "لا يوجد عنوان",
      "price": "علاج عام"
    },
    {
      "icon": Icons.person_pin_rounded,
      "title": "تيسير الصفدي",
      "subtitle": "شارع الحديد",
      "price": "تمزق اربطة"
    },
    {
      "icon": Icons.person_pin_rounded,
      "title": "تيم حسن",
      "subtitle": "مقابل طلال ابوعون",
      "price": "مشاكل عمود فقري"
    },
    {
      "icon": Icons.person_pin_rounded,
      "title": "باسل خياط",
      "subtitle": "بجانب الصدلية المركزية",
      "price": "مشاكل رقبة"
    },
    {
      "icon": Icons.person_pin_rounded,
      "title": "قصي خولي",
      "subtitle": "دوار داعل",
      "price": "حجامة"
    },
    {
      "icon": Icons.person_pin_rounded,
      "title": "كرستيانو رونالدو",
      "subtitle": "مشاكل عائلية",
      "price": " طفس- جامع الحسن-"
    },
    {
      "icon": Icons.person_pin_rounded,
      "title": "نغولو كانتي",
      "subtitle": "شمال لندن",
      "price": "منشطات"
    },
    {
      "icon": Icons.person_pin_rounded,
      "title": "حكيم زياش",
      "subtitle": "هولندا-أياكس-",
      "price": "اربطة الكتف"
    }
  ];
  PatientsQueryHandles patientsQueryHandles = PatientsQueryHandles();
  late AnimationController _controllerAnimation;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    super.initState();

    print("Hi am in the patient screen");

  }

  @override
  void dispose() {
    _controllerAnimation.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Tooltip(
        message: "إضافة مريض جديد",
        child: FloatingActionButton(
          onPressed: () {
            // patientsQueryHandles.getAllPatients(widget.dataBaseMain);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPatient(
                    dataBaseMain: widget.dataBaseMain,
                  )
              ),
            );
          },
          backgroundColor: Colors.teal,
          child: Icon(Icons.add, size: 25.w),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // إزالة التركيز عن حقل الإدخال عند النقر في أي مكان
        },
        child: RefreshIndicator(
          onRefresh: () async {
            // استدعاء دالة تحميل البيانات لتحديث القائمة
            // await patientsQueryHandles.getAllPatients(widget.dataBaseMain);
            setState(() {}); // إعادة بناء الواجهة بعد تحديث البيانات
          },
          child: Container(
            padding: EdgeInsets.all(6.h),
            child: ListView(
              children: [
                SizedBox(height: 15.h),

                //Search bar
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _focusNode,
                        readOnly: true,
                        //onChanged: _filterItems,
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: CustomSearch(patientsCustomDisplay: patientsData, controllerAnimation: _controllerAnimation ,widget.dataBaseMain,
                                onUpdate: (){
                                  setState(() {
                                  });
                                }
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search,
                              color: Colors.teal[800], size: 34.h),
                          hintText: "البحث عن مريض",
                          hintStyle: TextStyle(
                              color: Colors.teal[800],
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900),
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                //Title of the patients
                Text(
                  "المرضى",
                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10.h),

                //This code for the Grid view that changed with text inside
                /*
                 StaggeredGrid.count(
          crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.h,
            children: List.generate(_filteredItems.length, (i) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalProfile(patientData: _filteredItems[i]),
                    ),
                  );
                },
                onLongPress: () {
                  CustomDialogAnimation.showCustomDialogPersonal(context, const DialogRemovePatient());
                },
                child: Card(
                  color: Colors.white,
                  elevation: 13.h,
                  shadowColor: Colors.teal.withOpacity(0.7),
                  child: Padding(
                    padding: EdgeInsets.all(5.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 70.w,
                          height: 70.h,
                          child: Icon(
                            _filteredItems[i]["icon"],
                            size: 50.sp,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          _filteredItems[i]["title"],
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "(أبو محمد الدوماني )",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          _filteredItems[i]["subtitle"],
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          _filteredItems[i]["price"],
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );

                 */

                //Patients card
                FutureBuilder<List<Patient>>(
                    future: patientsQueryHandles.getAllPatients(widget.dataBaseMain),
                    builder: (context, snapshot) {
                      //This is for the waiting
                      print("i am before the waiting11111111111111");
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        //replace it with the waiting cards
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      print("i am after the waiting222222222222222");
                      if (snapshot.connectionState == ConnectionState.done) {
                        print("i am inside the done333333333333");
                        if (snapshot.hasData) {
                          patientsData = snapshot.data!;
                          //List<Patient> displayListPatients = _filteredItems.isEmpty? patientsData : _filteredItems;
                          print("i am inside the has data444444444444444444");
                          return patientsData.isEmpty? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9, // عرض الأنيميشن (اختياري)
                                height: MediaQuery.of(context).size.height * 0.4, // ارتفاع الأنيميشن (اختياري)
                                child: Lottie.asset( //#
                                  'assets/animations/Search_move_no_data.json', // مسار الملف
                                  fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 16.h),
                                padding: EdgeInsets.all(7.w),
                                height: 55.h,
                                width: 264.w,
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "لا يوجد مرضى لعرضهم...",
                                    style: TextStyle(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.teal
                                    ),
                                  ),
                                ),
                              )

                            ],
                          ):
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: patientsData.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 20.h,
                              crossAxisSpacing: 10.h,
                              childAspectRatio: 2 / 3,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // an query to get the patient info by the id
                                      builder: (context) => PersonalProfile(
                                        patientData: patientsData[i], dataBaseMain: widget.dataBaseMain,),
                                    ),
                                  );
                                },
                                onLongPress: () async {
                                  //The query for the deleting patient after the confirm
                                  bool? result = await RemovePatientDialog.showCustomDialogRemove(
                                      context,  DialogRemovePatient(patientID:patientsData[i].patientID! , dataBaseMain:widget.dataBaseMain,));

                                  if(result == null)
                                  {
                                    print("The null is on") ;
                                  }else if(result ==true){
                                    if(mounted)
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('تم حذف المريض بنجاح'),
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Colors.teal,
                                        ),
                                      );
                                    }
                                    setState(() {
                                    });
                                  }else{
                                    if(mounted)
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('حدثت مشكلة أثناء الحذف, حاول مرة أخرى'),
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Colors.teal,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Card(
                                  color: Colors.white,
                                  elevation: 13.h,
                                  shadowColor: Colors.teal.withOpacity(0.7),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0.h),
                                    child: Column(children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 70.w,
                                              height: 60.h,
                                              child: Icon(
                                                Icons.person_pin_rounded,
                                                size: 55.sp,
                                                color: Colors.teal,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                patientsData[i].name,
                                                style: TextStyle(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                overflow: TextOverflow.visible,
                                                maxLines: null,
                                              ),
                                            ),
                                            SizedBox(height: 20.h),
                                            Expanded(
                                              child: Text(
                                                "( ${patientsData[i].nickName} )",
                                                style: TextStyle(
                                                  fontSize: 17.sp,
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                overflow: TextOverflow.visible,
                                                maxLines: null,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            Expanded(
                                              child: Text(
                                                patientsData[i].address,
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w900),
                                                overflow: TextOverflow.visible,
                                                maxLines: null,
                                              ),
                                            ),
                                            SizedBox(height: 22.h),
                                            Expanded(
                                              child: Text(
                                                patientsData[i].status,
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.grey),
                                                overflow: TextOverflow.visible,
                                                maxLines: null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        print("i am before the error");
                        if (snapshot.hasError) {
                          print("i am inside the error");
                          //Here replace it with icon on the errors
                          return Center(
                            //Animation for error #
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.9, // عرض الأنيميشن (اختياري)
                                    height: MediaQuery.of(context).size.height * 0.4, // ارتفاع الأنيميشن (اختياري)
                                    child: Lottie.asset( //#
                                      'assets/animations/Search_move_no_data.json', // مسار الملف
                                      fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 16.h, right: 33.w),
                                    padding: EdgeInsets.all(7.w),
                                    height: 55.h,
                                    width: 264.w,
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "حدث خطأ أثناء تحميل البيانات, حاول مرة أخرى",
                                        style: TextStyle(
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                          );
                        }
                      }
                      print("i am after the get data");
                      //Here but an icon for fail
                      return  Center(
                        //The connection has fail one #
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9, // عرض الأنيميشن (اختياري)
                                height: MediaQuery.of(context).size.height * 0.4, // ارتفاع الأنيميشن (اختياري)
                                child: Lottie.asset(
                                  'assets/animations/Search_move_no_data.json', // مسار الملف
                                  fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 16.h, right: 33.w),
                                padding: EdgeInsets.all(7.w),
                                height: 55.h,
                                width: 264.w,
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "حدث خطأ أثناء تحميل البيانات, حاول مرة أخرى",
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate  {
  List<Patient> patientsCustomDisplay = [];
  AnimationController controllerAnimation;
  final DataBaseMain dataBaseMain ;
  final Function onUpdate;

  CustomSearch(this.dataBaseMain, { required this.onUpdate,required this.patientsCustomDisplay , required this.controllerAnimation});

  List<Patient>? filterList;

  @override
  List<Widget>? buildActions(BuildContext context) {
    //To add group of widget so here for remove the search text
    return [
      IconButton(
        onPressed: () {
          //Any thing written in the search will store in variable named (query)
          //so if i want to clear the search after clicking on the close
          //I just do this
          query = "";
        },
        icon: const Icon(Icons.close),
        color: Colors.teal,
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //Widget start in the delegate search
    return IconButton(
        onPressed: () {
          //this function for closing the search delegate
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    //Here where i can show the
    return const Text(" I am in the result ");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //This is the content of the result search page

    //doing a search proccess
    if (query == "") {
      //Show here all the patients from the attribute up there
      return ListView(
        children: [
          //There is no text search and there is no patients #
          patientsCustomDisplay.isEmpty ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width , // عرض الأنيميشن (اختياري)
                height: MediaQuery.of(context).size.height * 0.43, // ارتفاع الأنيميشن (اختياري)
                child: Lottie.asset(
                  'assets/animations/Search_move_no_data.json', // مسار الملف
                  fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2.h,),
                padding: EdgeInsets.all(7.w),
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width ,
                alignment: Alignment.center,
                child: Text(
                  "لا يوجد مرضى للبحث, بلا هبل يا حب..",
                  style: TextStyle(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.teal,
                  ),
                ),

              )
            ],
          ):
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: patientsCustomDisplay.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 10.h,
              childAspectRatio: 2 / 3,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //An query to get the patient info by the id
                      builder: (context) => PersonalProfile(
                          patientData: patientsCustomDisplay[i] ,dataBaseMain: dataBaseMain),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 13.h,
                  shadowColor: Colors.teal.withOpacity(0.7),
                  child: Padding(
                    padding: EdgeInsets.all(5.0.h),
                    child: Column(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 70.w,
                              height: 70.h,
                              child: Icon(
                                Icons.person_pin_rounded,
                                size: 55.sp,
                                color: Colors.teal,
                              ),
                            ),

                            Expanded(
                              child: Text(
                                patientsCustomDisplay[i].name,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.visible,
                                maxLines: null,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "( ${patientsCustomDisplay[i].nickName} )",
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.teal
                                ),
                                overflow: TextOverflow.visible,
                                maxLines: null,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Expanded(
                              child: Text(
                                patientsCustomDisplay[i].address,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900),
                                overflow: TextOverflow.visible,
                                maxLines: null,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Expanded(
                              child: Text(
                                patientsCustomDisplay[i].status,
                                style: TextStyle(
                                    fontSize: 15.sp, fontWeight: FontWeight.w900, color: Colors.grey),
                                overflow: TextOverflow.visible,
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          )
        ],
      );
      /*SizedBox(
        height: 400,
        child: ListView.builder(
            itemCount:  patientsCustomDisplay.length,
            itemBuilder:(context ,i )
            {
              return InkWell(
                onTap: ()
                {
                  //this function move me to the result function up there
                  //So i can display what i want
                  showResults(context) ;
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("${username[i]}" , style: const TextStyle(fontSize: 16),),
                  ),
                ),
              ) ;
            }
        ),
      );*/

    }
    //Here where the result of the search operation will shown
    else
    {
      // تحويل نص البحث إلى أحرف صغيرة وتجاهل الهمزات
      String normalizedQuery = query
          .toLowerCase()
          .replaceAll('أ', 'ا')
          .replaceAll('إ', 'ا')
          .replaceAll('آ', 'ا');

      filterList = patientsCustomDisplay.where((item) {
        // تطبيع الاسم قبل البحث
        String normalizedName = item.name
            .toLowerCase()
            .replaceAll('أ', 'ا')
            .replaceAll('إ', 'ا')
            .replaceAll('آ', 'ا');
        String normalizedNickName = item.nickName
            .toLowerCase()
            .replaceAll('أ', 'ا')
            .replaceAll('إ', 'ا')
            .replaceAll('آ', 'ا');

        return normalizedName.contains(normalizedQuery) ||
            normalizedNickName.contains(normalizedQuery);
      }).toList();

      //If there is a text search and there is no result #
      return ListView(
        children: [
          filterList!.isEmpty?  Column(

            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width , // عرض الأنيميشن (اختياري)
                height: MediaQuery.of(context).size.height * 0.43, // ارتفاع الأنيميشن (اختياري)
                child: Lottie.asset(
                  'assets/animations/Search_move_no_data.json', // مسار الملف
                  fit: BoxFit.cover, // ملاءمة الأنيميشن (اختياري)
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:2.h),
                padding: EdgeInsets.all(7.w),
                height: MediaQuery.of(context).size.height * 0.11,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child:Text(
                  "لا يوجد تطابق, تأكد من البحث..",
                  style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.teal
                  ),
                ),

              )
            ],
          )
              : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filterList?.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 10.h,
              childAspectRatio: 2 / 3,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //An query to get the patient info by the id
                      builder: (context) =>
                          PersonalProfile(patientData: filterList![i] , dataBaseMain: dataBaseMain,),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 13.h,
                  shadowColor: Colors.teal.withOpacity(0.7),
                  child: Padding(
                    padding: EdgeInsets.all(5.0.h),
                    child: Column(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 70.w,
                              height: 70.h,
                              child: Icon(
                                Icons.person_pin_rounded,
                                size: 55.sp,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Expanded(
                              child: Text(
                                filterList![i].name,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.visible,
                                maxLines: null,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "( ${filterList![i].nickName} )",
                                style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.teal
                                ),
                                overflow: TextOverflow.visible,
                                maxLines: null,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Expanded(
                              child: Text(
                                filterList![i].address,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900),
                                overflow: TextOverflow.visible,
                                maxLines: null,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Expanded(
                              child: Text(
                                filterList![i].status,
                                style: TextStyle(
                                    fontSize: 15.sp, fontWeight:FontWeight.w900, color: Colors.grey),
                                overflow: TextOverflow.visible,
                                maxLines: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        ],
      );

    }
  }
}
