import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

class InboxLoadingListTile extends StatelessWidget {
  final int count;
  const InboxLoadingListTile({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(count, (index) => const InboxLoadingTile()),
      ],
    );
  }
}

class InboxLoadingTile extends StatelessWidget {
  const InboxLoadingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return CardLoading(
      height: 112.4,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
