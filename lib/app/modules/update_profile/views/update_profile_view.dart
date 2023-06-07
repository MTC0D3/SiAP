import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi/app/shared/theme.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user["nip"];
    controller.namaC.text = user["nama"];
    controller.emailC.text = user["email"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: blackColor,
        ),
        title: Text(
          'Update Profile',
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
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NIP",
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      autocorrect: false,
                      readOnly: true,
                      controller: controller.nipC,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Email Address",
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      autocorrect: false,
                      readOnly: true,
                      controller: controller.emailC,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Nama",
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      autocorrect: false,
                      controller: controller.namaC,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GetBuilder<UpdateProfileController>(
                          builder: (c) {
                            if (c.image != null) {
                              return ClipOval(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.file(
                                    File(c.image!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } else {
                              if (user["profile"] != null) {
                                return Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.network(
                                          user["profile"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        controller.deleteProfile(user["uid"]);
                                      },
                                      child: const Text(
                                        "Delete",
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Text("no image");
                              }
                            }
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            controller.pickImage();
                          },
                          child: const Text("Choose"),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: () async {
                        if (controller.isLoading.isFalse) {
                          await controller.updateProfile(user["uid"]);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: purpleColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(56),
                        ),
                      ),
                      child: Text(
                        controller.isLoading.isFalse
                            ? "Update Profile"
                            : "Loading...",
                        style: whiteTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
