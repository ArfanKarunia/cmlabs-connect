import 'package:flutter/material.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../utils/color.dart';

class DefaultSmartRefresherHeader extends StatelessWidget {
  const DefaultSmartRefresherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClassicHeader(
      refreshStyle: RefreshStyle.Follow,
      refreshingIcon: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: AppColors.text_4,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
