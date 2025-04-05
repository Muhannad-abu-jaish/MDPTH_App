
import 'package:diaa_pth/model/appointment_model.dart';
import 'package:diaa_pth/model/databse_main.dart';
import 'package:diaa_pth/model/patient.dart';
import 'package:diaa_pth/model/personal_profile.dart';
import 'package:intl/intl.dart';

class PatientsQueryHandles {
  //inserts
  Future<bool> insertsDataToPatient(Patient patient , DataBaseMain dataBaseMain) async {
    //هنا تتم عملية التأكد من كافة القيم التي هي نول اضعها في القواعد (لا يوجد)
    //هنا بالتأكيد سأرسل بيانات الأرقام كأصفار كي تخزن كذلك

    List<int> daysID = [];
    print("yeeesssssssss");
    //هنا سأتأكد أي من  الأيام تم اختياره لأقوم بإدخال المواعيد على اساسه
    for (int i = 0; i < patient.days!.length; i++) {
      print(i);
      if (patient.days?[i] == true) {
        daysID.add(i + 1);
      }
    } //بنهاية حلقة فور هذه احصل على عدد الايام المدخلة بالتالي عدد الإدخالات لجدول المواعيد بالإضافة لدليل كل يوم
    patient.paymentGot = 0;
    patient.paymentStill = 0;

    //insert the data into the model
    // هنا يجب ان تعاد نتيجة االعملية وبناء عليها اعرض حدث ما مثلا رسالة تظهر للعميل
    //اي استقبل رقم ما للنجاح ورقم ما للفشل واتعامل مع الحالتين
    return await dataBaseMain.insertPatientWithAppointments(
        patient.toMap(), daysID);
  }
//read

  //To get all the patients
  Future<List<Patient>> getAllPatients(DataBaseMain dataBaseMain) async{

    List<Map<String, dynamic>> patientsData = await dataBaseMain.getAllPatientsFromDB();
    //Give me all the patient you have
    List<Patient> patients= Patient.fromMapList(patientsData);
   /* for(int i=0 ; i<patients.length ; i++)
      {
        print(patients[20].name);
      }
    print(patients);*/
    return patients;
  }

  //To get one specific day appointment
  Future<List<Patient>> getDayAppointment( int dayID , DataBaseMain dataBaseMain) async{

    List<Map<String, dynamic>> patientsData = await dataBaseMain.getDayAppointments(dayID);
    List<Patient> patients = Patient.fromMapList(patientsData) ;

    return patients;
  }

  //To get today appointment
  Future<List<AppointmentModel>> getTodayAppointment( int dayID , DataBaseMain dataBaseMain) async{

    List<Map<String, dynamic>> patientsData = await dataBaseMain.getTodayAppointments(dayID);
    List<AppointmentModel> patients = AppointmentModel.fromMapList(patientsData) ;

    return patients;
  }


  //To get the personal profile and other data that important
  Future<PersonalProfileModel> getPersonalProfile(DataBaseMain dataBaseMain , int? patientID) async{
    PersonalProfileModel personalProfile = PersonalProfileModel();

    List< Map< String , dynamic > > patient = await dataBaseMain.getOnePatient(patientID!);
    //Here i have the patient data
    personalProfile.patient= Patient.fromMapOnePatient(patient);
    print("This is the return of the opertation ${personalProfile.patient?.name}");
    personalProfile.daysNumbers = await dataBaseMain.getDaysOnePatient(patientID);

    if(personalProfile.daysNumbers!.isEmpty || personalProfile.daysNumbers == null){
      //Here should i give this list or send something to not entered into the list while it is null
      //Something like sending another variable with true value
      personalProfile.isDaysWell = false ;
      print(personalProfile.daysNumbers);
      print("the day number is false now, so it is empty") ;
    }
    else
      {
        personalProfile.isDaysWell = true;
       print("am printing now ${personalProfile.daysNumbers![0]}}");
      }

    List<Map<String,dynamic>> appointmentDays = await dataBaseMain.getDayTimeForOnePatient(patientID);

    personalProfile.dayTime = DayTime.fromMapListDayTime(appointmentDays);
    if(personalProfile.dayTime!.isEmpty || personalProfile.dayTime == null)
    {
      personalProfile.isAppointmentWell=false;
      print(personalProfile.dayTime);
      print("the app is false now");
    }
    else{
      personalProfile.isAppointmentWell = true;
      for(int i=0 ; i<personalProfile.dayTime!.length; i++)
      {
        print("The appointment in ${personalProfile.dayTime![i].time}  ${personalProfile.dayTime![i].date}");
      }
    }
    return personalProfile ;
  }

  //To get all the debts
  Future<List<Patient>> getAllDebts(DataBaseMain dataBaseMain) async{
    List<Map<String, dynamic>> patientsData = await dataBaseMain.getAllDebts();
    //Give me all the patient with debts you have
    List<Patient> patients= Patient.fromMapListAllDebts(patientsData);
    return patients;
  }

  //To get one specific day appointment
  Future< Map<int, int>> getPercentDaysApps( DataBaseMain dataBaseMain) async{

    Map<int, int> percentDays = await dataBaseMain.getPercentDaysAppsDB();
    print(percentDays);

    return percentDays;
  }
//delete
  //To remove one patient from the database
  Future<bool> deletePatientById(DataBaseMain db, int patientID) async {

      int result = await db.deleteOnePatient(patientID) ;
      print('$result rows deleted.');
      if(result >0 )
        {
          print("Operation end successfully") ;
          return Future.value(true);
        }else{
        print("The operation is fucked ya bro");
        return Future.value(false) ;
      }

  }

//update

//Called of the function that changed the  data of the appointments
  //When its start the 11:59
 /* static Future<void> setDailyAlarm(DataBaseMain db) async {
    await AndroidAlarmManager.periodic(
      const Duration(days: 1), // التكرار كل يوم
      0, // معرف فريد للتنبيه
      db.updateDailyAppointments,
      startAt: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        23,
        59,
      ),
      exact: true,
      wakeup: true,
    );
    print('Daily alarm set for 23:11');
  }*/


  Future<bool> updateAppointmentStatus(DataBaseMain db) async {

    bool result = await db.updateDailyAppointments() ;
    print('$result rows deleted.');
    if(result )
    {
      print("Updating daily appointment status end successfully") ;
      return Future.value(true);
    }else{
      print("Updating daily appointment status is fucked ya bro");
      return Future.value(false) ;
    }

  }

  Future<bool> updateDebtsByID(DataBaseMain db , int patientID , double paid , double debts) async {

    bool result = await db.updateDebtsByIDInDB(patientID, paid, debts) ;
    print('$result rows deleted.');
    if(result )
    {
      print("Updating debts and paid end successfully") ;
      return Future.value(true);
    }else{
      print("Updating debts and paid is fucked ya bro");
      return Future.value(false) ;
    }

  }

  Future<bool> updateInformationByID(DataBaseMain db , int patientID , String name , String nickName , String age , String number ) async {

    bool result = await db.updateInformationByIDInDB( patientID, name, nickName , age , number) ;
    print('$result rows deleted.');
    if(result )
    {
      print("Updating personal information end successfully") ;
      return Future.value(true);
    }else{
      print("Updating personal information is fucked ya bro");
      return Future.value(false) ;
    }

  }
  Future<bool> updateAddressByID(DataBaseMain db , int patientID , String address) async {

    bool result = await db.updateAddressByIDInDB( patientID, address) ;
    print('$result rows deleted.');
    if(result )
    {
      print("Updating address end successfully") ;
      return Future.value(true);
    }else{
      print("Updating address is fucked ya bro");
      return Future.value(false) ;
    }

  }
  Future<bool> updateStatusByID(DataBaseMain db , int patientID , String status) async {
    bool result = await db.updateStatusByIDInDB( patientID, status) ;
    print('$result rows deleted.');
    if(result )
    {
      print("Updating status end successfully") ;
      return Future.value(true);
    }else{
      print("Updating status is fucked ya bro");
      return Future.value(false) ;
    }

  }

  Future<bool> updatePlanByID(DataBaseMain db , int patientID , String plan) async {

    bool result = await db.updatePlanByIDInDB( patientID, plan) ;
    print('$result rows deleted.');
    if(result )
    {
      print("Updating plan end successfully") ;
      return Future.value(true);
    }else{
      print("Updating plan is fucked ya bro");
      return Future.value(false) ;
    }

  }

  Future<bool> updateAppointmentsDays(DataBaseMain db , int patientID, List<bool> daysSelected) async {
    List<int> daysID = [];
    print("yeeesssssssss");
    //هنا سأتأكد أي من  الأيام تم اختياره لأقوم بإدخال المواعيد على اساسه
    for (int i = 0; i < daysSelected.length; i++) {
      print(i);
      if (daysSelected[i] == true) {
        daysID.add(i + 1);
      }
    }
    //After ending this for i have the id of selected days

    bool result = await db.updateAppointmentsDaysDB(patientID, daysID) ;
    print('$result rows deleted.');
    if(result )
    {
      print("Updating appointment end successfully") ;
      return Future.value(true);
    }else{
      print("Updating appointment is fucked ya bro");
      return Future.value(false) ;
    }
  }

  Future<bool> cancelOneAppointment(DataBaseMain db , int appointmentID) async {

    bool result = await db.canceledOneAppointment(appointmentID) ;
    print('$result rows deleted.');
    if(result )
    {
      print("Updating daily appointment status end successfully") ;
      return Future.value(true);
    }else{
      print("Updating daily appointment status is fucked ya bro");
      return Future.value(false) ;
    }

  }

  Future<bool> confirmOneAppointment(DataBaseMain db , int appointmentID , int patientID , int valueDebts, int valuePaid) async {

    DateTime now = DateTime.now();
    String timeAsText = DateFormat('HH:mm').format(now);
    String dateAsText = DateFormat('yyyy-MM-dd').format(now);
    //This for change the status of this appointment
    bool result = await db.confirmOneAppointmentDB(appointmentID , patientID , valueDebts ,valuePaid ,timeAsText , dateAsText) ;
    print('$result Appointment confirmed.');
    if(result )
    {
      print("Appointment confirmed operation end successfully") ;
      return Future.value(true);
    }else{
      print("Appointment confirmed operation fucked ya bro");
      return Future.value(false) ;
    }

  }
}

