class AppointmentModel {
  int? patientID;
  int? appointmentID;
  String name;
  String nickName;
  String address;
  String status;

  //Add the number on here and other get from the data base ones

  //Constructor
  AppointmentModel({
    this.appointmentID,
    this.patientID,
    required this.name,
    required this.nickName,
    required this.address,
    required this.status
  });

  // لتحويل خريطة (Map) إلى كائن Patient
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      appointmentID: map['appointmentID'],
      patientID: map['patientID'],
      name: map['name'],
      nickName: map['nickName'],
      address: map['address'],
      status: map['status'],

      //used like this when i want display the patients
      //Map<String, dynamic> patientMap = await database.query('Patients', where: 'id = ?', whereArgs: [1]);
      //Patient patient = Patient.fromMap(patientMap);
    );
  }

  // لتحويل خريطة من القواعد لعرض واجهة المرضى
  factory AppointmentModel.fromMapAllPatients(Map<String, dynamic> map) {
    return AppointmentModel(
      appointmentID: map['appointmentID'],
      patientID: map['patientID'],
      name: map['name'],
      nickName: map['nickName'],
      address: map['address'],
      status: map['status'],
    );
  }

  static List<AppointmentModel> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => AppointmentModel.fromMapAllPatients(map)).toList();
  }


}