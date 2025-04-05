import 'package:diaa_pth/constant/database_tabels.dart';

class Patient {
  int? patientID;
  List<bool>? days;
  String name;
  String nickName;
  String? age;
  String address;
  String status;
  String? treatmentPlan;
  double? paymentStill;
  double? paymentGot;
  String? phoneNumber;

  //Add the number on here and other get from the data base ones

  //Constructor
  Patient({this.patientID,
    this.days,
    required this.name,
    required this.nickName,
    this.age,
    required this.address,
    
    required this.status,
    this.treatmentPlan,
    this.paymentStill,
    this.paymentGot,
    this.phoneNumber
  });

// لتحويل كائن Patient إلى خريطة (Map) لاستخدامها في قواعد البيانات
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'address': address,
      'status': status,
      'number':phoneNumber,
      'treatmentPlan': treatmentPlan,
      'paymentStill': paymentStill,
      'paymentGot': paymentGot,
      'nickName': nickName,
    };

    //used like this when create a new row
    //Patient newPatient = Patient(name: "John Doe", age: 30, address: "123 Street", healthCondition: "Good");
    //await database.insert('Patients', newPatient.toMap());
  }

  // لتحويل خريطة (Map) إلى كائن Patient
  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      patientID: map['patientID'],
      name: map['name'],
      nickName: map['nickName'],
      age: map['age'],
      address: map['address'],
      status: map['status'],
      treatmentPlan: map['treatmentPlan'],
      paymentStill: map['paymentStill'],
      paymentGot: map['paymentGot'],

      //used like this when i want display the patients
      //Map<String, dynamic> patientMap = await database.query('Patients', where: 'id = ?', whereArgs: [1]);
      //Patient patient = Patient.fromMap(patientMap);
    );
  }

  // لتحويل خريطة من القواعد لعرض واجهة المرضى
  factory Patient.fromMapAllPatients(Map<String, dynamic> map) {
    return Patient(
      patientID: map['patientID'],
      name: map['name'],
      nickName: map['nickName'],
      address: map['address'],
      status: map['status'],

    );
  }

  static List<Patient> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => Patient.fromMapAllPatients(map)).toList();
  }


  //Those tow function to convert the list returned from the database
  //into list of patient instance
  factory Patient.fromMapAllDebts(Map< String , dynamic > map){
    return Patient(
      patientID: map['patientID'],
      name: map['name'],
      nickName: map['nickName'],
      paymentStill: map[DataBaseTables.paymentStill],
      paymentGot: map[DataBaseTables.paymentGot],
      address: map['address'],
      status: map['status'],
    );
  }
  static List<Patient> fromMapListAllDebts(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => Patient.fromMapAllDebts(map)).toList();
  }

  factory Patient.fromMapOnePatient(List<Map<String, dynamic>> map) {
    return Patient(
      patientID: map[0]['patientID'],
      name: map[0]['name'],
      nickName: map[0]['nickName'],
      age: map[0]['age'],
      phoneNumber: map[0]['number'],
      address: map[0]['address'],
      status: map[0]['status'],
      treatmentPlan: map[0]['treatmentPlan'],
      paymentStill: map[0]['paymentStill'],
      paymentGot: map[0]['paymentGot'],

      //used like this when i want display the patients
      //Map<String, dynamic> patientMap = await database.query('Patients', where: 'id = ?', whereArgs: [1]);
      //Patient patient = Patient.fromMap(patientMap);
    );
  }

}