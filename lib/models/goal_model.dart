import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 0)
class GoalModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double targetAmount;

  @HiveField(2)
  double savedAmount;

  @HiveField(3)
  String interval;

  @HiveField(4)
  double contribution;

  @HiveField(5)
  String targetDate;

  @HiveField(6)
  String emoji;

  GoalModel({
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.interval,
    required this.contribution,
    required this.targetDate,
    required this.emoji,
  });

  double get progress => targetAmount == 0 ? 0.0 : savedAmount / targetAmount;
}
