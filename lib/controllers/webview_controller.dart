import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class WebviewController extends GetxController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Reactive variables
  RxString link = 'https://tiktok.com'.obs;
  RxString web = 'false'.obs;
  RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loading.value = true;
    _listenToFirebase();
  }

  void _listenToFirebase() {
    loading.value = true;
    _dbRef.child('web/web').onValue.listen((event) {
      web.value = event.snapshot.value?.toString() ?? 'false';
    });

    _dbRef.child('link/link').onValue.listen((event) {
      link.value = event.snapshot.value?.toString() ?? '';
    });
    loading.value = false;
  }
}
