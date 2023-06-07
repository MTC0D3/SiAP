import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/shared/theme.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if (currC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confirmC.text.isNotEmpty) {
      if (newC.text == confirmC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: currC.text);

          await auth.currentUser!.updatePassword(newC.text);

          Get.back();

          Get.snackbar(
            "Berhasil",
            "Berhasil update password.",
            backgroundColor: greenColor,
            colorText: whiteColor,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar(
              "Terjadi Kesalahan",
              "Password yang dimasukan salah. Tidak dapat update password.",
              backgroundColor: redColor,
              colorText: whiteColor,
            );
          } else {
            Get.snackbar(
              "Terjadi Kesalahan",
              "${e.code.toLowerCase()}",
              backgroundColor: redColor,
              colorText: whiteColor,
            );
          }
        } catch (e) {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Tidak dapat update password.",
            backgroundColor: redColor,
            colorText: whiteColor,
          );
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
          "Terjadi Kesalahan",
          "Confirm password tidak cocok.",
          backgroundColor: redColor,
          colorText: whiteColor,
        );
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Semua input harus diisi.",
        backgroundColor: redColor,
        colorText: whiteColor,
      );
    }
  }
}
