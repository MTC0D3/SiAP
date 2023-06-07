import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import 'package:presensi/app/routes/app_pages.dart';
import 'package:presensi/app/shared/theme.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          String address =
              "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";
          await updatePosition(position, address);

          // Cek distance between 2 position
          double distance = Geolocator.distanceBetween(
              -6.5993931, 106.8097919, position.latitude, position.longitude);

          //Absen
          await presensi(position, address, distance);

          // Get.snackbar("Berhasil", "Anda telah mengisi kehadiran.");
        } else {
          Get.snackbar(
            "Terjadi Kesalahan",
            dataResponse["message"],
            backgroundColor: redColor,
            colorText: whiteColor,
          );
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresensi =
        await firestore.collection("pegawai").doc(uid).collection("presensi");

    QuerySnapshot<Map<String, dynamic>> snapPresensi = await colPresensi.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di Luar Area";

    if (distance <= 200) {
      // di dalam area
      status = "Di Dalam Area";
    }

    if (snapPresensi.docs.length == 0) {
      // belum pernah absen & set absen masuk pertama kali
      if (distance <= 200) {
        await Get.defaultDialog(
          title: "Validasi Absensi",
          titleStyle: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: bold,
          ),
          content: Padding(
            padding: const EdgeInsets.only(right: 22, left: 22, bottom: 22),
            child: Text(
              "Apakah anda yakin akan mengisi absen masuk sekarang ?",
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
                  await colPresensi.doc(todayDocID).set(
                    {
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      },
                    },
                  );
                  Get.back();
                  Get.snackbar(
                    "Berhasil",
                    "Anda telah melakukan absen masuk.",
                    backgroundColor: greenColor,
                    colorText: whiteColor,
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: purpleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Yes",
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        Get.snackbar(
          "Terjadi Kesalahan",
          "Anda berada di luar area.",
          backgroundColor: redColor,
          colorText: whiteColor,
        );
      }
    } else {
      //Sudah pernah absen-> cek hari ini sudah absen masuk/keluar belum ?
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresensi.doc(todayDocID).get();

      if (todayDoc.exists == true) {
        // tinggal absen keluar atau sudah absen masuk/keluar
        Map<String, dynamic>? dataPresensiToday = todayDoc.data();
        if (dataPresensiToday?["keluar"] != null) {
          // sudah absen masuk dan keluar
          Get.snackbar(
            "Pemberitahuan",
            "Anda telah melakukan absen masuk & keluar.",
            backgroundColor: yellowColor,
            colorText: whiteColor,
          );
        } else {
          //absen keluar
          if (distance <= 200) {
            await Get.defaultDialog(
              title: "Validasi Absensi",
              titleStyle: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              ),
              content: Padding(
                padding: const EdgeInsets.only(right: 22, left: 22, bottom: 22),
                child: Text(
                  "Apakah anda yakin akan melakukan absen keluar sekarang ?",
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
                      await colPresensi.doc(todayDocID).update(
                        {
                          "keluar": {
                            "date": now.toIso8601String(),
                            "lat": position.latitude,
                            "long": position.longitude,
                            "address": address,
                            "status": status,
                            "distance": distance,
                          },
                        },
                      );
                      Get.back();
                      Get.snackbar(
                        "Berhasil",
                        "Anda telah melakukan absen keluar.",
                        backgroundColor: greenColor,
                        colorText: whiteColor,
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: purpleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Yes",
                      style: whiteTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            Get.snackbar(
              "Terjadi Kesalahan",
              "Anda berada di luar area.",
              backgroundColor: redColor,
              colorText: whiteColor,
            );
          }
        }
      } else {
        //absen masuk
        if (distance <= 200) {
          await Get.defaultDialog(
            title: "Validasi Absensi",
            titleStyle: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: bold,
            ),
            content: Padding(
              padding: const EdgeInsets.only(right: 22, left: 22, bottom: 22),
              child: Text(
                "Apakah anda yakin akan mengisi absen masuk sekarang ?",
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
                    await colPresensi.doc(todayDocID).set(
                      {
                        "date": now.toIso8601String(),
                        "masuk": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": status,
                          "distance": distance,
                        },
                      },
                    );
                    Get.back();
                    Get.snackbar(
                      "Berhasil",
                      "Anda telah melakukan absen masuk.",
                      backgroundColor: greenColor,
                      colorText: whiteColor,
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: purpleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Yes",
                    style: whiteTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Anda berada di luar area.",
            backgroundColor: redColor,
            colorText: whiteColor,
          );
        }
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;

    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        "message": "Tidak dapat menggunakan GPS pada device ini.",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "message": "Izin penggunaan GPS ditolak.",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Akses GPS Device anda telah dibatasi. Ubah pada settingan device anda.",
        "error": true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device.",
      "error": false,
    };
  }
}
