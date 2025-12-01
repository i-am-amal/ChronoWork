import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showInfoDialog(BuildContext context) async {
  final navigator = Navigator.of(context);

  final info = await PackageInfo.fromPlatform();

  if (!navigator.mounted) return;

  showDialog(
    context: navigator.context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: const Color(0xff1A2A4A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        title: Text(
          "App Info",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- VERSION ---------------- //
            Text(
              "Version: ${info.version}",
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
            ),

            SizedBox(height: 18.h),

            // ---------------- PRIVACY POLICY ---------------- //
            GestureDetector(
              onTap: () {
                launchUrl(
                  Uri.parse(
                    "https://github.com/i-am-amal/ChronoWork-Privacy-Policy/blob/main/ChronoWork-Privacy-Policy.md",
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.lightBlueAccent,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),

                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        actionsPadding: EdgeInsets.only(bottom: 8.h, right: 8.w),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: Text(
              "Close",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    },
  );
}
