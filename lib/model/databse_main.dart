//import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:diaa_pth/constant/database_tabels.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseMain {
  static final DataBaseMain _instance = DataBaseMain._internal();
  static Database? _database;

  //هنا يمكن اضافة اي منطق انا اريده
  // أي تهيئة تحتاجها، مثل فتح قاعدة البيانات
  // يمكنك وضع منطق تهيئة هنا
  DataBaseMain._internal();

  factory DataBaseMain() => _instance;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'physiotherapy.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print("i am in oncreate=======================================");
    Batch batch = db.batch();

    //Create patient
    batch.execute('''
      CREATE TABLE "Patients" (
        'patientID' INTEGER PRIMARY KEY AUTOINCREMENT,
        'name' TEXT NOT NULL,
        'age' TEXT NULL,
        'address' TEXT NULL,
        'number' TEXT NULL,
        'nickName' TEXT NULL,
        'status' TEXT NULL,
        'treatmentPlan' TEXT NULL,
        'paymentStill' REAL NULL,
        'paymentGot' REAL NULL
      )
    ''');

    //Create appointment
    batch.execute('''
      CREATE TABLE "Appointments" (
        'appointmentID' INTEGER PRIMARY KEY AUTOINCREMENT,
        'patientID' INTEGER,
        'dayID' INTEGER,
        'status' INTEGER,
        FOREIGN KEY (patientID) REFERENCES Patients (patientID) ON DELETE CASCADE,
        FOREIGN KEY (dayID) REFERENCES Days (dayID)
      )
    ''');

    //Create single appointment
    batch.execute('''
      CREATE TABLE "SingleAppointments" (
        'singleAppointmentID' INTEGER PRIMARY KEY AUTOINCREMENT,
        'patientID' INTEGER,
        'date' TEXT,
        FOREIGN KEY (PatientID) REFERENCES Patients (PatientID) ON DELETE CASCADE
      )
    ''');

    //Create days
    batch.execute('''
      CREATE TABLE "Days" (
        'dayID' INTEGER PRIMARY KEY AUTOINCREMENT,
        'dayName' INTEGER UNIQUE,
        'isActive' INTEGER
      )
    ''');

    //Create attendance
    batch.execute('''
      CREATE TABLE "Attendance" (
        'attendanceID' INTEGER PRIMARY KEY AUTOINCREMENT,
        'patientID' INTEGER,
        'date' TEXT,
        'time' TEXT,
        FOREIGN KEY (PatientID) REFERENCES Patients (PatientID) ON DELETE CASCADE
      )
    ''');

    print("Create DATABASE AND TABLE =============");
    await batch.commit();

    await db.insert('Days', {'dayName': 1, 'isActive': 0});
    await db.insert('Days', {'dayName': 2, 'isActive': 0});
    await db.insert('Days', {'dayName': 3, 'isActive': 0});
    await db.insert('Days', {'dayName': 4, 'isActive': 0});
    await db.insert('Days', {'dayName': 5, 'isActive': 0});
    await db.insert('Days', {'dayName': 6, 'isActive': 0});
    await db.insert('Days', {'dayName': 7, 'isActive': 0});
  }

  //To Upgrade the database
  //1-increase the version of DB
  //2-Write the sql instruction to upgrade the DB
  Future<void> _onUpgrade(Database db, int oldVersion, newVersion) async {
    print(" onUpgrade ======================= ");
    if (oldVersion < 1) {
      print("it is all okeee");
    }
    print("am out ya bro");
  }

  //إدخال بيانات المريض مع وجود مواعيد لأيام محددة بالتالي ربط هذا المريض بهذا الموعد لهذا اليوم
  Future<bool> insertPatientWithAppointments(Map<String, dynamic> patientMap, List<int> daysForAppointments) async {
    print("object////////////////////////////////////");
    Database? db = await database;
    print("Starting transaction...");
    try {
      await db.transaction((txn) async {
        // إدخال بيانات المريض والحصول على معرّف المريض الجديد
        int patientId = await txn.insert(DataBaseTables.patient, patientMap);
        print("1111111111111111111111");

        if (patientId == 0) {
          // إذا كانت قيمة ID المريض 0 فهذا يعني أن الإدخال فشل

          throw Exception("Failed to insert patient");
        }

        // جلب معرّفات الأيام بناءً على أسماء الأيام المحددة للمواعيد
        print("2222222222222222222222222");
        for (int dayName in daysForAppointments) {
          // استعلام للحصول على معرّف اليوم
          print("33333333333333333333333333333333333333");
          final dayQuery = await txn
              .query('Days', where: 'dayName = ?', whereArgs: [dayName]);
          print("4444444444444444444444444444444444444");

          if (dayQuery.isNotEmpty) {
            print("5555555555555555555555555555555555");
            int dayId = dayQuery.first['dayID'] as int;
            // ربط الموعد مع معرّف المريض ومعرّف اليوم
            await txn.insert('Appointments',
                {'patientID': patientId, 'dayID': dayId, 'status': 1});
          }
        }

        // استخدام نفس كائن المعاملة txn لاستعلام جدول Patients
        final daysData = await txn.query('Patients');
        for (var row in daysData) {
          print("Row: $row");
        }
        return true; // إذا كانت العملية ناجحة
      });
      db.close();
      return true;
    } catch (e) {
      print("Error occurred while inserting patient: $e");
      return Future.error("حدث خطأ اثناء إدخال المريض يا حوب");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllPatientsFromDB() async {
    print("open the data");
    Database? db = await database;
    print("opened");

    try {
      print("insideeeeeeeeeee");
      // استعلام SQL لجلب الحقول المطلوبة فقط من جدول المرضى
      final List<Map<String, dynamic>> result = await db.query(
        DataBaseTables.patient,
        columns: [
          DataBaseTables.patientID,
          DataBaseTables.name,
          DataBaseTables.nickName,
          DataBaseTables.address,
          DataBaseTables.status
        ], // الحقول المطلوبة فقط
      );

      print("outtttttttttt");
      db.close();
      return result; // إذا كانت العملية ناجحة
    } catch (e) {
      print("am in the catch of getAllPatientsFromDB");
      print("Error occurred while get all the patients: $e");
      return Future.error("حدث خطأ أثناء جلب المرضى");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  //To get the personal information of our patient
  Future<List<Map<String, dynamic>>> getOnePatient(int patientID) async {
    print("open the data of one patient");
    Database? db = await database;
    print("opened of the one patient");

    try {
      print("insideeeeeeeeeee the one patient");
      List<Map<String, dynamic>> result = await db
          .query('Patients', where: 'patientID = ?', whereArgs: [patientID]);
      if (result.isEmpty) {
        throw Exception("المريض غير موجود عند محاولة الدخول لملفه الشخصي");
      }
      print("returned the one patient");
      db.close();
      return result;
    } catch (e) {
      print("am in the catch of getOnePatient");
      print("Error occurred while get the patient: $e");
      return Future.error("حدث خطأ أثناء جلب ملف المريض");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  //To get the days of patient's appointment
  Future<List<int>> getDaysOnePatient(int patientID) async {
    print("open the data of get one patient day");
    Database? db = await database;
    print("opened of the get one patient day");

    try {
      print("insideeeeeeeeeee get one patient day");
      List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT d.dayName
      FROM Days d
      INNER JOIN Appointments ap ON ap.dayID = d.dayID
      WHERE ap.patientID = ?
    ''', [patientID]);
      if (result.isEmpty) {
        print("the patient have no appointment");
        //throw Exception("اليوم غير موجود عند محاولة الدخول لملفه الشخصي") ;
      }
      List<int> appointmentDays =
          result.map((row) => row['dayName'] as int).toList();
      print("returned the get one patient day");
      db.close();
      return appointmentDays;
    } catch (e) {
      print("am in the catch of get one patient day");
      print("Error occurred while get one patient day: $e");
      return Future.error("حدث خطأ أثناء جلب ملف المريض");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  Future<List<Map<String, dynamic>>> getDayTimeForOnePatient(int patientID) async {
    print("open the data of Da7 Time one patient");
    Database? db = await database;
    print("opened of the Da7 Time one patient");

    try {
      print("insideeeeeeeeeee the Da7 Time one patient");

      List<Map<String, dynamic>> result = await db.rawQuery('''
  SELECT date, time FROM Attendance WHERE patientID = ?
''', [patientID]);

      if (result.isEmpty) {
        print("the patient have no appointment Yet");
        //throw Exception("لا توجد مواعيد سابقة عند محاولة الدخول لملفه الشخصي") ;
      }
      print("returned theDa7 Time one patient");
      db.close();
      return result;
    } catch (e) {
      print("am in the catch of Da7 Time one patient");
      print("Error occurred while get Da7 Time one patient: $e");
      return Future.error("حدث خطأ أثناء جلب ملف المريض");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  //Get appointments for one specific day by the id of the day
  Future<List<Map<String, dynamic>>> getDayAppointments(int dayID) async {
    print("open the data of day's appointment");
    Database? db = await database;
    print("opened day's appointment");

    try {
      print("insideeeeeeeeeee of day's appointment");

      List<Map<String, dynamic>> result = await db.rawQuery('''
 SELECT 
        Patients.name,
        Patients.nickName,
        Patients.address,
        Patients.status
    FROM 
        Appointments
    JOIN 
        Patients 
    ON 
        Appointments.patientID = Patients.patientID
    WHERE 
        Appointments.dayID = ?
  ''', [dayID]);

      if (result.isEmpty) {
        print("There is no appointment in this day");

      }
      print("returned the day's appointment");
      db.close();
      return result;
    } catch (e) {
      print("am in the catch day's appointment");
      print("Error occurred while get  day's appointment: $e");
      return Future.error("حدث خطأ أثناء جلب مواعيد هذا اليوم");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  //Get appointments for today day by the id of the day
  Future<List<Map<String, dynamic>>> getTodayAppointments(int dayID) async {
    print("open the data of today's appointment");
    Database? db = await database;
    print("opened today's appointment");

    try {
      print("insideeeeeeeeeee of today's appointment");

      List<Map<String, dynamic>> result = await db.rawQuery('''
 SELECT 
        a.${DataBaseTables.patientID},
        a.${DataBaseTables.appointmentID},
        p.name,
        p.nickName,
        p.address,
        p.status
    FROM 
        Appointments a
    JOIN 
        Patients p ON a.patientID = p.patientID
    WHERE 
        a.dayID = ?
        AND a.status = 1
  ''', [dayID]);

      if (result.isEmpty) {
        print("There is no appointment in this day");

      }
      print("returned the today's appointment");
      db.close();
      return result;
    } catch (e) {
      print("am in the catch today's appointment");
      print("Error occurred while get  today's appointment: $e");
      return Future.error("حدث خطأ أثناء جلب مواعيد هذا اليوم");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }


  //Get patient debts
  Future<List<Map<String, dynamic>>> getAllDebts() async {

    print("open the data of get patient debts");
    Database? db = await database;
    print("opened of get patient debts");

    try {
      print("insideeeeeeeeeee of get patient debts");
      // استعلام SQL لجلب الحقول المطلوبة فقط من جدول المرضى
      final List<Map<String, dynamic>> result = await db.query(
        'Patients',
        columns: ['patientID', 'name', 'nickName', 'paymentGot', 'paymentStill' , 'status' , 'address'],
        where: 'paymentStill > ?',
        whereArgs: [0],
      );

      print("outtttttttttt of get patient debts");
      db.close();
      return result; // إذا كانت العملية ناجحة
    } catch (e) {
      print("am in the catch of of get patient debts");
      print("Error occurred while get all the debts: $e");
      return Future.error("حدث خطأ أثناء جلب الديون");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }

  }
  //To change the status of the appointments of the end of the days
   Future<bool> updateDailyAppointments() async {
     print("open the data of update apps manually");
    Database? db = await database;
     print("opened of update apps manually");
    try {
      print("insideeeeeeeeeee update apps manually");
      await db.rawUpdate('''
        UPDATE Appointments
        SET status = 1
        WHERE status != 1
      ''');
      print('Appointments updated successfully for All appointments');
      db.close();
      return Future.value(true);
    } catch (e) {
      print('Error updating appointments: $e');
      return Future.error("حدث خطأ أثناء تغيير الحالة لمواعيد");
    }finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  //To change the value of paid and debts
  Future<bool> updateDebtsByIDInDB(int patientID , double paid , double debts) async {
    print("open the data of update the debts");
    Database? db = await database;
    print("opened of of update the debts");
    try {
      print("insideeeeeeeeeee of update the debts");
      await db.rawUpdate('''
        UPDATE Patients
        SET 
          paymentGot = ?,
          paymentStill = MAX(?,0)
        WHERE patientID = ?
      ''' , [paid , debts , patientID]);
      print('Debts and Paid updated successfully for This patient');
      db.close();
      return Future.value(true);
    } catch (e) {
      print('Error updating the debts: $e');
      return Future.error("حدث خطأ أثناء تحديث الديون");
    }finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  //To change personal information
  Future<bool> updateInformationByIDInDB(int patientID , String name , String nickName , String age , String number ) async {
    print("open the data of update the personal information ");
    Database? db = await database;
    print("opened of of update the personal information ");
    try {
      print("insideeeeeeeeeee of update the personal information ");
      await db.rawUpdate('''
        UPDATE Patients
        SET 
          ${DataBaseTables.name} = ?,
          ${DataBaseTables.nickName} = ?,
          ${DataBaseTables.age} = ?,
          ${DataBaseTables.number} = ?
        WHERE patientID = ?
      ''' , [name , nickName , age , number , patientID]);
      print('personal information updated successfully for This patient');
      db.close();
      return Future.value(true);
    } catch (e) {
      print('Error updating the personal information : $e');
      return Future.error("حدث خطأ أثناء تحديث البيانات الشخصية");
    }finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  //To change personal information
  Future<bool> updateAddressByIDInDB(int patientID , String address ) async {
    print("open the data of update the address ");
    Database? db = await database;
    print("opened of of update the address ");
    try {
      print("insideeeeeeeeeee of update the address");
      await db.rawUpdate('''
        UPDATE Patients
        SET 
          ${DataBaseTables.address} = ?
        WHERE patientID = ?
      ''' , [address , patientID]);
      print('address updated successfully for This patient');
      db.close();
      return Future.value(true);
    } catch (e) {
      print('Error updating the address : $e');
      return Future.error("حدث خطأ أثناء تحديث العنوان");
    }finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  //To change general state
  Future<bool> updateStatusByIDInDB(int patientID , String status ) async {
    print("open the data of update the status ");
    Database? db = await database;
    print("opened of of update the status ");
    try {
      print("insideeeeeeeeeee of update the status");
      await db.rawUpdate('''
        UPDATE Patients
        SET 
          ${DataBaseTables.status} = ?
        WHERE patientID = ?
      ''' , [status , patientID]);
      print('status updated successfully for This patient');
      db.close();
      return Future.value(true);
    } catch (e) {
      print('Error updating the status : $e');
      return Future.error("حدث خطأ أثناء تحديث الحالة العامة");
    }finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  //To change medical plan
  Future<bool> updatePlanByIDInDB(int patientID , String plan ) async {
    print("open the data of update the plan ");
    Database? db = await database;
    print("opened of of update the plan ");
    try {
      print("insideeeeeeeeeee of update the plan");
      await db.rawUpdate('''
        UPDATE Patients
        SET 
          ${DataBaseTables.treatmentPlan} = ?
        WHERE patientID = ?
      ''' , [plan , patientID]);
      print('plan updated successfully for This patient');
      db.close();
      return Future.value(true);
    } catch (e) {
      print('Error updating the plan : $e');
      return Future.error("حدث خطأ أثناء تحديث الخطة العلاجية");
    }finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  //إدخال بيانات المريض مع وجود مواعيد لأيام محددة بالتالي ربط هذا المريض بهذا الموعد لهذا اليوم
  Future<bool> updateAppointmentsDaysDB(int patientID, List<int> daysForAppointments) async {
    print("open update appointments by self");
    Database? db = await database;
    print("Starting transaction update appointments by self...");
    try {
      await db.transaction((txn) async {
        // إدخال بيانات المريض والحصول على معرّف المريض الجديد
        int result = await txn.rawDelete('DELETE FROM Appointments WHERE patientID = ?', [patientID]);
        print(result) ;
        print("1111111111111111111111");


        // جلب معرّفات الأيام بناءً على أسماء الأيام المحددة للمواعيد
        print("2222222222222222222222222");
        for (int dayName in daysForAppointments) {
          // استعلام للحصول على معرّف اليوم
          print("33333333333333333333333333333333333333");
          final dayQuery = await txn
              .query('Days', where: 'dayName = ?', whereArgs: [dayName]);
          print("4444444444444444444444444444444444444");

          if (dayQuery.isNotEmpty) {
            print("5555555555555555555555555555555555");
            int dayId = dayQuery.first['dayID'] as int;
            // ربط الموعد مع معرّف المريض ومعرّف اليوم
            await txn.insert('Appointments',
                {'patientID': patientID, 'dayID': dayId, 'status': 1});
          }
        }
        return true; // إذا كانت العملية ناجحة
      });
      db.close();
      return true;
    } catch (e) {
      print("Error occurred while inserting patient: $e");
      return Future.error("حدث خطأ اثناء إدخال المريض يا حوب");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  Future<Map<int , int >> getPercentDaysAppsDB() async {
    print("open get percent");
    Database? db = await database;
    print("Starting transaction get percent...");
    Map<int, int> appointmentsMap = {};
    try {
      await db.transaction((txn) async {
        print("insid the get percent transaction") ;
        List<int> dayNames = [
          1, 2, 3, 4, 5, 6, 7
        ];
        // تنفيذ الاستعلام للحصول على عدد المواعيد لكل يوم
        for (int dayName in dayNames) {
          var result = await txn.rawQuery('''
      SELECT COUNT(*) 
      FROM Appointments 
      JOIN Days ON Appointments.dayID = Days.dayID 
      WHERE Days.dayName = ? 
    ''', [dayName]);

          // إضافة القيمة في الماب، إذا لم توجد مواعيد فسيتم تخزين 0
          appointmentsMap[dayName] = result.isEmpty ? 0 : result.first.values.first as int;
          print("${appointmentsMap[dayName] } kfjdklfjsdkfjd  + $dayName" ) ;
        }
        var re = await txn.rawQuery('''
      SELECT *
      FROM Appointments 
    ''');
        print(re );

        return appointmentsMap;
      });
      db.close();
      return appointmentsMap;
    } catch (e) {
      print("Error occurred while inserting patient: $e");
      return Future.error("حدث خطأ سحب النسب يا حوب");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }
  Future<bool> canceledOneAppointment(int appointmentID) async{
    print("open the data of canceled One Appointment");
    Database? db = await database;
    print("opened of canceled One Appointment");
    try {
      print("insideeeeeeeeeee canceled One Appointment");
      int result = await db.rawUpdate('''
        UPDATE Appointments
        SET status = 0
        WHERE appointmentID = ?
      ''' , [appointmentID]);
      print('canceled One Appointment successfully for this appointment');
      if(result == 1)
        {
          db.close();
          return Future.value(true);
        }else{
        db.close();
        return Future.value(false);
      }
    } catch (e) {
      print('Error canceled appointment: $e');
      return Future.error("حدث خطأ أثناء تغيير الحالة للموعد");
    }finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }

  Future<bool> confirmOneAppointmentDB(int appointmentID , int patientID , int valueDebts, int valuePaid ,String time, String date) async{
    print("open data of confirm one appointment db");
    Database? db = await database;
    print("Starting transaction...++confirm one appointment db");
    try {
      await db.transaction((txn) async {
        print("am inside the transaction of confirm one appointment db");

        //Change the status of the appointment
        int result = await txn.rawUpdate('''
        UPDATE Appointments
        SET status = 0
        WHERE appointmentID = ?
      ''' , [appointmentID]);

        if( result == 0)
          {
            print("There is something wrong") ;
          }
        print("Changing doing well");

        int count = await txn.rawUpdate('''
      UPDATE Patients
      SET paymentGot = paymentGot + ?,
          paymentStill = paymentStill + ?
      WHERE patientID = ?
    ''', [valuePaid, valueDebts, patientID]);

        if(count > 0)
          {
            print("تم تحديث البيانات بنجاح");
          }else{
          print("لم يتم العثور على السطر المطلوب");
        }

        await txn.execute('''
    INSERT INTO Attendance (patientID, date, time)
    VALUES (?, ?, ?)
  ''', [patientID, date , time]);

        return true; // إذا كانت العملية ناجحة
      });
      db.close();
      return true;
    } catch (e) {
      print("Error occurred while confirm the appointment: $e");
      return Future.error("حدث خطأ اثناء تحديث البيانات يا حوب");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }
  //Remove one patient from the database
  Future<int> deleteOnePatient(int patientID) async {
    print("open the data of remove patient");
    Database? db = await database;
    print("opened of remove patient");

    try {
      print("insideeeeeeeeeee the remove patient");
      Future<bool> dataResult = Future.value(false);
      int result = await db.delete(
        'Patients',
        where: 'patientID = ?',
        whereArgs: [patientID],
      );
      print("returned the remove patient");
      db.close();
      if (result > 0) {
        dataResult = Future.value(true);
      } else {
        dataResult = Future.value(false);
      }
      return result;
    } catch (e) {
      print("am in the catch of remove patient");
      print("Error occurred while remove patient: $e");
      return Future.error("حدث خطأ أثناء حذف المريض");
    } finally {
      if (db.isOpen) {
        await db.close(); // إغلاق قاعدة البيانات بعد الانتهاء من استخدامها
      }
    }
  }


  // insert the appointment store when i confirm the appointment
  /*
   // إدخال بيانات الحضور وربطها بمريض معين عبر patientID
      await db.transaction((txn) async {
        await txn.execute('''
    INSERT INTO Attendance (patientID, date, time)
    VALUES (?, ?, ?)
  ''', [patientID, '2024-11-12', '10:00 AM']);// استبدل patientID بالتعريف الفعلي للمريض

        await txn.execute('''
    INSERT INTO Attendance (patientID, date, time)
    VALUES (?, ?, ?)
  ''', [patientID, '2023-11-12', '2:00 PM']); // استبدل patientID بالتعريف الفعلي للمريض

      }
      );
   */
  readData(String sql) async {
    try {
      //Get the data from DataBase (SELECT)
      Database? myDB = _database; //This is the creation of DB upper the code
      //This function for make a select (sql is the select instruction
      List<Map> response = await myDB!.rawQuery(sql);

      return response;
    } catch (e) {
      print("Error reading data: $e");
    }
  }

  updateData(String sql) async {
    try {
      //update the data in DataBase (update)
      Database? myDB = _database; //This is the creation of DB upper the code
      //This function for make a update (sql is the update instruction
      int response = await myDB!.rawUpdate(sql);

      return response;
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  insertData(String sql, List<dynamic> args) async {
    try {
      //insert the data to DataBase (insert)
      Database? myDB = _database; //This is the creation of DB upper the code
      //This function for make a insert (sql is the insert instruction
      int response = await myDB!.rawInsert(sql, args);
      return response;
    } catch (e) {
      print("Error inserting data: $e");
    }
  }

  deleteData(String sql) async {
    try {
      //delete the data from DataBase (delete)
      Database? myDB = _database; //This is the creation of DB upper the code
      //This function for make a delete (sql is the delete instruction
      int response = await myDB!.rawDelete(sql);
      return response;
    } catch (e) {
      print("Error deleting data: $e");
    }
  }
}
