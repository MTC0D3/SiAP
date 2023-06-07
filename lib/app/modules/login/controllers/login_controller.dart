import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:presensi/app/shared/theme.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        if (userCredential.user!.emailVerified == true) {
          isLoading.value = false;
          if (passC.text == "password") {
            Get.offAllNamed(Routes.NEW_PASSWORD);
          } else {
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          Get.defaultDialog(
            title: "Belum Verifikasi",
            titleStyle: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: bold,
            ),
            content: Padding(
              padding: const EdgeInsets.only(right: 22, left: 22, bottom: 22),
              child: Text(
                "Anda belum verifikasi akun ini. Lakukan Verifikasi di email anda.",
                textAlign: TextAlign.center,
                style: blackTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 13,
                ),
              ),
            ),
            actions: [
              SizedBox(
                width: 100,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: redColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: whiteTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 40,
                child: TextButton(
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar(
                        "Berhasil",
                        "Kami telah berhasil mengirim email verfikasi ke akun anda.",
                        backgroundColor: greenColor,
                        colorText: whiteColor,
                      );
                      isLoading.value = false;
                    } catch (e) {
                      isLoading.value = false;
                      Get.snackbar(
                        "Terjadi Kesalahan",
                        "Tidak dapat mengirim email verifikasi. Silahkan Hubungi Admin",
                        backgroundColor: redColor,
                        colorText: whiteColor,
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: purpleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Kirim Ulang",
                    style: whiteTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Email tidak terdaftar.",
            backgroundColor: redColor,
            colorText: whiteColor,
          );
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Password salah.",
            backgroundColor: redColor,
            colorText: whiteColor,
          );
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          "Terjadi Kesalahan",
          "Tidak dapat login.",
          backgroundColor: redColor,
          colorText: whiteColor,
        );
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Email dan password wajib diisi.",
        backgroundColor: redColor,
        colorText: whiteColor,
      );
    }
  }
}
