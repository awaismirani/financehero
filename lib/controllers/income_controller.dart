import 'package:financehero/repository/income_repository.dart';
import 'package:get/get.dart';
import '../models/income_model.dart';


class IncomeController extends GetxController {
  final IncomeRepository _repo = IncomeRepository();

  var income = 0.0.obs;
  var percentage = 20.0.obs;
  var hoursPerDay = 8.0.obs;
  var daysPerWeek = 5.0.obs;
  var currency = 'USD'.obs;

  double get yearly => income.value * (percentage.value / 100) * 12;
  double get monthly => income.value * (percentage.value / 100);
  double get weekly => (yearly / 52);
  double get daily => weekly / daysPerWeek.value;
  double get hourly => daily / hoursPerDay.value;

  void saveData() {
    final model = IncomeModel(
      income: income.value,
      percentage: percentage.value,
      hoursPerDay: hoursPerDay.value,
      daysPerWeek: daysPerWeek.value,
      currency: currency.value,
    );
    _repo.saveIncomeData(model);
  }

  Future<void> loadData() async {
    final model = await _repo.getIncomeData();
    if (model != null) {
      income.value = model.income;
      percentage.value = model.percentage;
      hoursPerDay.value = model.hoursPerDay;
      daysPerWeek.value = model.daysPerWeek;
      currency.value = model.currency;
    }
  }
}
