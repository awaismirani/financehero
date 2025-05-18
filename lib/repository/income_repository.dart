import 'package:hive/hive.dart';
import '../models/income_model.dart';

class IncomeRepository {
  final _boxName = 'incomeBox';

  Future<void> saveIncomeData(IncomeModel model) async {
    final box = await Hive.openBox<IncomeModel>(_boxName);
    await box.put('userIncome', model);
  }

  Future<IncomeModel?> getIncomeData() async {
    final box = await Hive.openBox<IncomeModel>(_boxName);
    return box.get('userIncome');
  }
}
