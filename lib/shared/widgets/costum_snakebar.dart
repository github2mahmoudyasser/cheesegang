

      import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'costum_text.dart';

      SnackBar customSnack(String errorMsg) {
        return SnackBar(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black.withOpacity(0.8), // اسود شفاف
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                CupertinoIcons.info,
                color: Colors.white,
              ),
              const Gap(10),

              Expanded( // 👈 مهم عشان يمنع overflow
                child: CustomText(
                  text: errorMsg,
                  color: Colors.white,
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }
