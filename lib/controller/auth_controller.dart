import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:si_dallant_wallet_app/screens/welcome.dart';

import '../screens/login.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth authentication = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(authentication.currentUser);
    _user.bindStream(authentication.userChanges());
    ever(_user, _moveToPage);
  }

  _moveToPage(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() => const WelcomePage());
    }
  }

  void register() async {
    String name = Get.arguments[0];
    String id = Get.arguments[1];
    String mobile = Get.arguments[2];
    String banknum = Get.arguments[3];
    String chooid = Get.arguments[4];

    // try {
    //   await authentication.createUserWithEmailAndPassword(
    //       email: email, password: password);
    // } catch (e) {
    //   Get.snackbar(
    //     "Error message",
    //     "User message",
    //     backgroundColor: Colors.red,
    //     snackPosition: SnackPosition.BOTTOM,
    //     titleText: const Text(
    //       "Registration is failed",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     messageText: Text(
    //       e.toString(),
    //       style: const TextStyle(color: Colors.white),
    //     ),
    //   );
    // }
  }

  void logout() {
    authentication.signOut();
  }
}
