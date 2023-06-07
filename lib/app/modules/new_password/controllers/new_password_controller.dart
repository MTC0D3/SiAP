import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:presensi/app/shared/theme.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void newPassord() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        try {
          String email = auth.currentUser!.email!;
          await auth.currentUser!.updatePassword(newPassC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: email,
            password: newPassC.text,
          );

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar(
              "Terjadi Kesalahan",
              "Password terlalu lemah, setidaknya 6 karakter.",
              backgroundColor: redColor,
              colorText: whiteColor,
            );
          }
        } catch (e) {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Password terlalu lemah, setidaknya 6 karakter.",
            backgroundColor: redColor,
            colorText: whiteColor,
          );
        }
      } else {
        Get.snackbar(
          "Terjadi Kesalahan",
          "Tidak dapat membuat password baru, silahkan hubungi Admin",
          backgroundColor: redColor,
          colorText: whiteColor,
        );
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Password baru wajib diisi.",
        backgroundColor: redColor,
        colorText: whiteColor,
      );
    }
  }
}
