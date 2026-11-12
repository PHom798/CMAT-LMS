import 'package:flutter/material.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/learning/domain/learning_history.dart';

/// Open strip (no card) inviting the learner to fix past mistakes.
/// Only shown when there is something to review.
class ReviewMistakes extends StatelessWidget {
  const ReviewMistakes({super.key, required this.count, required this.onReview});

  final int count;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(color: AppColors.orangeSoft, shape: BoxShape.circle),
          child: const Icon(Icons.replay_rounded, color: AppColors.orangeDeep),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count ${count == 1 ? 'mistake' : 'mistakes'} to review',
                style: AppText.label.copyWith(fontSize: 15.5),
              ),
              Text(
                'Fix them for +${PracticeScoring.reviewFixXp} XP each. They return until you get them right.',
                style: AppText.caption,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        TextButton(
          onPressed: onReview,
          style: TextButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            shape: const StadiumBorder(),
          ),
          child: Text('Review', style: AppText.label.copyWith(color: Colors.white, fontSize: 14)),
        ),
      ],
    );
  }
}
