import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi/app/shared/theme.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;
  // Untuk menampung value nama, job, email, passAdmin
  TextEditingController namaC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        final UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passAdminC.text);

        final UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "nama": namaC.text,
            "job": jobC.text,
            "email": emailC.text,
            "uid": uid,
            "role": "pegawai",
            "createdAt": DateTime.now().toIso8601String(),
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          final UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );
          Get.back(); //tutup dialog
          Get.back(); //back to home
          Get.snackbar(
            "Berhasil",
            "Berhasil menambahkan pegawai",
            backgroundColor: greenColor,
            colorText: whiteColor,
          );
        }
        isLoadingAddPegawai.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Password yang digunakan terlalu sigkat.",
            backgroundColor: redColor,
            colorText: whiteColor,
          );
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Pegawai sudah ada. Kamu tidak dapat menambahkan pegawai dengan email ini.",
            backgroundColor: redColor,
            colorText: whiteColor,
          );
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Admin tidak dapat login. Password salah!",
            backgroundColor: redColor,
            colorText: whiteColor,
          );
        } else {
          Get.snackbar(
            "Terjadi Kesalahan",
            "${e.code}",
            backgroundColor: redColor,
            colorText: whiteColor,
          );
        }
      } catch (e) {
        isLoadingAddPegawai.value = false;
        Get.snackbar(
          'Terjadi Kesalahan',
          'Tidak dapat menambahkan pegawai.',
          backgroundColor: redColor,
          colorText: whiteColor,
        );
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
        "Terjadi Kesalahan",
        "Password wajib diisi untuk keperluan validasi!",
        backgroundColor: redColor,
        colorText: whiteColor,
      );
    }
  }

// Fungsi Add Pegawai
  Future<void> addPegawai() async {
    if (namaC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: "Validasi Admin",
        titleStyle: blackTextStyle.copyWith(
          fontSize: 20,
          fontWeight: bold,
        ),
        content: Padding(
          padding: const EdgeInsets.only(right: 22, left: 22, bottom: 22),
          child: Column(
            children: [
              Text(
                "Masukan password untuk validasi !",
                style: blackTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password",
                    style: blackTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    controller: passAdminC,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ],
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
          Obx(
            () => SizedBox(
              width: 100,
              height: 40,
              child: TextButton(
                onPressed: () async {
                  if (isLoadingAddPegawai.isFalse) {
                    await prosesAddPegawai();
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: purpleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isLoadingAddPegawai.isFalse ? "Add Pegawai" : "Loading...",
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "NIP, Nama, Job, dan Email harus diisi.",
        backgroundColor: redColor,
        colorText: whiteColor,
      );
    }
  }
}
