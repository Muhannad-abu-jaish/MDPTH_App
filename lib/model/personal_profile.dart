import 'package:diaa_pth/constant/database_tabels.dart';
import 'package:diaa_pth/model/patient.dart';

class PersonalProfileModel {
  Patient? patient;
  List<int>? daysNumbers;
  List<DayTime>? dayTime;
  bool? isDaysWell ;
  bool? isAppointmentWell ;

  PersonalProfileModel({
     this.patient,
     this.daysNumbers,
     this.dayTime,
     this.isDaysWell,
     this.isAppointmentWell
});


}

class DayTime{
  String? time;
  String? date;

  DayTime({
     this.time,
     this.date
});

  factory DayTime.fromMapDayTime(Map<String , dynamic > map)
  {
    return DayTime(
        time: map[DataBaseTables.time],
        date: map[DataBaseTables.date]
    );
  }

  static List<DayTime> fromMapListDayTime(List<Map<String, dynamic>> mapList){
    return mapList.map((map) => DayTime.fromMapDayTime(map)).toList();
  }
}