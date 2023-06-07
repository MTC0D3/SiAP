import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:presensi/app/routes/app_pages.dart';
import 'package:presensi/app/shared/theme.dart';

import '../controllers/profile_controller.dart';
import '../../../controllers/page_index_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightBackgroundColor,
        elevation: 0,
        title: Text(
          'My Profile',
          style: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasData) {
            Map<String, dynamic> user = snap.data!.data()!;
            String defaultImage =
                "https://ui-avatars.com/api/?name=${user['nama']}";
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 40),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            user["profile"] != null
                                ? user["profile"] != ""
                                    ? user["profile"]
                                    : defaultImage
                                : defaultImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${user['nama'].toString().toUpperCase()}",
                        style: blackTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${user['email']}",
                        style: blackTextStyle,
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.UPDATE_PROFILE,
                          arguments: user,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Row(
                            children: [
                              const Icon(Icons.person, size: 24),
                              const SizedBox(width: 18),
                              Text(
                                "Update Profile",
                                style: blackTextStyle.copyWith(
                                  fontWeight: medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Row(
                            children: [
                              const Icon(Icons.vpn_key, size: 24),
                              const SizedBox(width: 18),
                              Text(
                                "Update Password",
                                style: blackTextStyle.copyWith(
                                  fontWeight: medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (user["role"] == "admin")
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.ADD_PEGAWAI),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: Row(
                              children: [
                                const Icon(Icons.person_add, size: 24),
                                const SizedBox(width: 18),
                                Text(
                                  "Add Pegawai",
                                  style: blackTextStyle.copyWith(
                                    fontWeight: medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () => controller.logout(),
                        child: Container(
                          child: Row(
                            children: [
                              const Icon(Icons.logout, size: 24),
                              const SizedBox(width: 18),
                              Text(
                                "Logout",
                                style: blackTextStyle.copyWith(
                                  fontWeight: medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: whiteColor,
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("Tidak dapat memuat data user."),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        elevation: 0,
        style: TabStyle.fixedCircle,
        backgroundColor: whiteColor,
        color: greyColor,
        activeColor: purpleColor,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Add'),
          TabItem(icon: CupertinoIcons.profile_circled, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
