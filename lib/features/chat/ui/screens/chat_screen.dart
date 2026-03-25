import 'package:flutter/material.dart';

import '../../../../core/theme/ app_text_styles.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'واجهة الدردشات ستكون هنا',
          style: AppTextStyles.font24Bold,
        ),
      ),
    );
  }
}