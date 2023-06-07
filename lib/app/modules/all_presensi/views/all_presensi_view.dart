import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:presensi/app/shared/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
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
          'Semua Absensi',
          style: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<AllPresensiController>(
        builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: controller.getAllPresensi(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snap.data?.docs.length == 0 || snap.data == null) {
              return Center(
                child: Text(
                  "Belum ada history absensi",
                  style: blackTextStyle.copyWith(
                    fontSize: 13,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: 24, top: 40, left: 24, right: 24),
              itemCount: snap.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = snap.data!.docs[index].data();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Material(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () => Get.toNamed(
                        Routes.DETAIL_PRESENSI,
                        arguments: data,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Masuk",
                                  style: blackTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                Text(
                                  "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                  style: blackTextStyle.copyWith(
                                    fontSize: 13,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data['masuk']?['date'] == null
                                  ? "-"
                                  : "${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}",
                              style: blackTextStyle.copyWith(fontSize: 13),
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
                              data['keluar']?['date'] == null
                                  ? "-"
                                  : "${DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}",
                              style: blackTextStyle.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //syncfusion datepicker
          Get.dialog(
            Dialog(
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 400,
                child: SfDateRangePicker(
                  monthViewSettings:
                      const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                  selectionMode: DateRangePickerSelectionMode.range,
                  showActionButtons: true,
                  onCancel: () => Get.back(),
                  onSubmit: (obj) {
                    if (obj != null) {
                      if ((obj as PickerDateRange).endDate != null) {
                        //Di proses
                        controller.pickDate(obj.startDate!, obj.endDate!);
                      }
                    }
                  },
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.format_list_bulleted_rounded),
        backgroundColor: purpleColor,
      ),
    );
  }
}
