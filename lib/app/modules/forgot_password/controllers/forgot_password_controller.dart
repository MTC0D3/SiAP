import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/shared/theme.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar(
          "Berhasil",
          "Kami telah mengirimkan email reset password. Periksa email anda !",
          backgroundColor: greenColor,
          colorText: whiteColor,
        );
        isLoading.value = false;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          "Terjadi Kesalahan",
          "Tidak dapat mengirim email reset password",
          backgroundColor: redColor,
          colorText: whiteColor,
        );
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Email wajib diisi.",
        backgroundColor: redColor,
        colorText: whiteColor,
      );
    }
  }
}
