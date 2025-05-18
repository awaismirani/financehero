import 'package:hive/hive.dart';

part 'income_model.g.dart';

@HiveType(typeId: 1)
class IncomeModel extends HiveObject {
  @HiveField(0)
  final double income;

  @HiveField(1)
  final double percentage;

  @HiveField(2)
  final double hoursPerDay;

  @HiveField(3)
  final double daysPerWeek;

  @HiveField(4)
  final String currency;

  IncomeModel({
    required this.income,
    required this.percentage,
    required this.hoursPerDay,
    required this.daysPerWeek,
    required this.currency,
  });
}
