import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

class QuotationOverviewLoadingListCard extends StatelessWidget {
  final double height;
  final int count;
  const QuotationOverviewLoadingListCard({
    super.key,
    this.height = 155,
    this.count = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
          count,
          (index) => QuotationOverviewLoadingCard(height: height),
        ),
      ],
    );
  }
}

class QuotationOverviewLoadingCard extends StatelessWidget {
  final double height;
  const QuotationOverviewLoadingCard({super.key, this.height = 155});

  @override
  Widget build(BuildContext context) {
    return CardLoading(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      borderRadius: BorderRadius.circular(16),
    );
  }
}
