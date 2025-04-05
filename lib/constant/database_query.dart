
class DataBaseQuery {


  //مثال عن الاستعلام
  static const String insertPatient = '''
  INSERT INTO 'patients' ('name' , 'age' , 'address' , 'status' , 'treatmentPlan' , 'paymentStill' , 'paymentGot') VALUES (?, ?, ?, ?, ?, ?, ?)
''';

  //هكذا يستدعى الاستعلام عند المستخدم
  //await db.execute(Queries.insertPatient, [name, age, address, condition]);
  //وهو يكون مشابه لهذا عند ربطه ببيانات ال؟
  //INSERT INTO patients (name, age, address, condition) VALUES ('John', 30, '123 Street', 'Healthy');
}



/*
The function
Future<int> insertData(String sql, List<dynamic> args) async {
  Database? myDB = await db;
  int response = await myDB!.rawInsert(sql, args);
  return response;
}

The called of the function!!!
qlDP.insertData(
  '''INSERT INTO notes (note, color) VALUES (?, ?)''',
  [note.text, color.text],
);

في حالة كانت لدي بيانات فارغة مثلا في إدخال البيانات للمريض وهذا ممكن
qlDP.insertData(
  '''INSERT INTO notes (note, color) VALUES (?, ?)''',
  [note.text, color.text.isEmpty ? null : color.text],
);


 */