// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hive/hive.dart';
// import '../../../../constants/di/dependency_injection.dart';
// import '../../../../core/resources/manager_colors.dart';
// import '../../../main/presentation/view/main_view.dart';
// import 'login_view.dart';
// class AuthChecker extends StatefulWidget {
//   const AuthChecker({super.key});
//
//   @override
//   State<AuthChecker> createState() => _AuthCheckerState();
// }
//
// class _AuthCheckerState extends State<AuthChecker> {
//   @override
//   void initState() {
//     super.initState();
//     _checkSession();
//   }
//   bool isLoggedIn() {
//     var box = Hive.box('authBox');
//     return box.get('access_token') != null;
//   }
//
//   Future<void> _checkSession() async {
//     // await hiveService.initHive();
//     await initHive();
//
//     final isAuth = isLoggedIn();
//     if (isAuth) {
//       initMain();
//       Get.offAll(() => const MainView());
//     } else {
//       initLoginModule();
//
//       Get.offAll(() => const LoginView());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(
//           color: ManagerColors.primaryColor,
//         ),
//       ),
//     );
//   }
// }
