import 'package:financehero/models/goal_model.dart';
import 'package:financehero/repository/goal_repository.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class GoalController extends GetxController {
  final GoalRepository _repo = GoalRepository();
  var goals = <GoalModel>[].obs;

  // form fields
  var goalName = ''.obs;
  var targetAmount = 0.0.obs;
  var savedAmount = 0.0.obs;
  var interval = 'Weekly'.obs;
  var contribution = 0.0.obs;
  var targetDate = ''.obs;
  var emoji = '💰'.obs;

  @override
  void onInit() {
    super.onInit();
    loadGoals();
  }

  void loadGoals() async {
    goals.value = await _repo.getGoals();
  }

  double get progress =>
      targetAmount.value == 0 ? 0.0 : savedAmount.value / targetAmount.value;

  void saveGoal() {
    final goal = GoalModel(
      name: goalName.value,
      targetAmount: targetAmount.value,
      savedAmount: savedAmount.value,
      interval: interval.value,
      contribution: contribution.value,
      targetDate: targetDate.value,
      emoji: emoji.value,
    );
    _repo.addGoal(goal);
    loadGoals();
    reset();
  }

  void reset() {
    goalName.value = '';
    targetAmount.value = 0.0;
    savedAmount.value = 0.0;
    interval.value = 'Weekly';
    contribution.value = 0.0;
    targetDate.value = '';
    emoji.value = '💰';
  }

  Future<void> updateSavedAmount(int index, double newAmount) async {
    final box = await Hive.openBox<GoalModel>(_repo.boxName);
    final oldGoal = box.getAt(index);

    if (oldGoal != null) {
      final updatedGoal = GoalModel(
        name: oldGoal.name,
        targetAmount: oldGoal.targetAmount,
        savedAmount: newAmount,
        interval: oldGoal.interval,
        contribution: oldGoal.contribution,
        targetDate: oldGoal.targetDate,
        emoji: oldGoal.emoji,
      );

      await _repo.updateGoal(index, updatedGoal);
      loadGoals();
    }
  }

  /// ✅ Add this:
  Future<void> updateGoal(int index, GoalModel goal) async {
    await _repo.updateGoal(index, goal);
    loadGoals();
  }

  /// ✅ Add this:
  Future<void> deleteGoal(int index) async {
    await _repo.deleteGoal(index);
    loadGoals();
  }
}
