import '../constant/database_tabels.dart';

class Days{
  int? dayID;
  int dayName;
  int? isActive;

  Days({
    required this.dayName
});

  factory Days.fromMapDaysNumbers(Map<String , dynamic> map){
    return Days(
      dayName: map[DataBaseTables.dayName],
    );
  }

  static List<Days> fromMapListDays(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => Days.fromMapDaysNumbers(map)).toList();
  }
}