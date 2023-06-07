import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/shared/theme.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: blackColor,
        ),
        title: Text(
          'Detail Absensi',
          style: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "${DateFormat.yMMMMEEEEd().format(DateTime.parse(data["date"]))}",
                    style: blackTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Masuk",
                  style: blackTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Jam : ${DateFormat.jms().format(DateTime.parse(data["masuk"]!["date"]))}",
                  style: blackTextStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  "Posisi : ${data["masuk"]!["lat"]}, ${data["masuk"]!["long"]}",
                  style: blackTextStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  "Distance : ${data["masuk"]!["distance"].toString().split(".").first} meter",
                  style: blackTextStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  "Address : ${data["masuk"]!["address"]}",
                  style: blackTextStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  "Status : ${data["masuk"]!["status"]}",
                  style: greenTextStyle,
                ),
                const SizedBox(height: 20),
                Text(
                  "Keluar",
                  style: blackTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data["keluar"]?["date"] == null
                      ? "Jam : -"
                      : "Jam : ${DateFormat.jms().format(DateTime.parse(data["keluar"]!["date"]))}",
                  style: blackTextStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  data["keluar"]?["lat"] == null &&
                          data["keluar"]?["long"] == null
                      ? "Posisi : -"
                      : "Posisi : ${data["keluar"]!["lat"]}, ${data["keluar"]!["long"]}",
                  style: blackTextStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  data["keluar"]?["distance"] == null
                      ? "Distance : -"
                      : "Distance : ${data["keluar"]!["distance"].toString().split(".").first} meter",
                  style: blackTextStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  data["keluar"]?["address"] == null
                      ? "Address : -"
                      : "Address : ${data["keluar"]!["address"]}",
                  style: blackTextStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  data["keluar"]?["status"] == null
                      ? "Status : -"
                      : "Status : ${data["masuk"]!["status"]}",
                  style: greenTextStyle,
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
