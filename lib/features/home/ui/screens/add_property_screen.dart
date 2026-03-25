import 'package:flutter/material.dart';
import 'package:untitlednew2/core/theme/app_colors.dart';

import '../../../../core/theme/ app_text_styles.dart';


class AddPropertyScreen extends StatelessWidget {
  const AddPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة عقار جديد'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'واجهة إضافة عقار ستكون هنا',
          style: AppTextStyles.font16SemiBold,
        ),
      ),
    );
  }
}