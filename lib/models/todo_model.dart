import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@Collection()
class Todo {
  Id id = Isar.autoIncrement;

  late String text;
  DateTime dateTime = DateTime.now();
  bool isDone = false;
  
  @enumerated
  PriorityLevel priority = PriorityLevel.normal;
}

enum PriorityLevel { low, normal, high }

String getTurkishMonth(int month) {
  const aylar = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık'
  ];
  return aylar[month - 1];
}

String getTurkishDay(int weekday) {
  const gunler = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar'
  ];
  return gunler[weekday - 1];
}
