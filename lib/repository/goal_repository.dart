// goal_repository.dart
import 'package:hive/hive.dart';
import '../models/goal_model.dart';

class GoalRepository {
  final _boxName = 'goalsBox';
 String get boxName => _boxName; // 👈 public getter
  Future<void> addGoal(GoalModel goal) async {
    final box = await Hive.openBox<GoalModel>(_boxName);
    await box.add(goal);
  }

  Future<List<GoalModel>> getGoals() async {
    final box = await Hive.openBox<GoalModel>(_boxName);
    return box.values.toList();
  }
  Future<void> updateGoal(int index, GoalModel updatedGoal) async {
  final box = await Hive.openBox<GoalModel>(_boxName);
  await box.putAt(index, updatedGoal);
}



  /// ✅ Needed for delete
  Future<void> deleteGoal(int index) async {
    final box = await Hive.openBox<GoalModel>(boxName);
    await box.deleteAt(index);
  }
}
