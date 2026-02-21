import 'package:get/get.dart';
import 'package:trailmate/controllers/auth/auth_controller.dart';
import 'package:trailmate/controllers/auth/login_controller.dart';
import 'package:trailmate/controllers/auth/signup_controller.dart';

class Initialbinding extends Bindings {
  @override
  void dependencies() {
    // Register AuthController as a permanent dependency
    Get.put(AuthController(), permanent: true);
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignupController>(() => SignupController());
  }
}
