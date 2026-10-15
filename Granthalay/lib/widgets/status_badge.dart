import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/borrow_record.dart';

class StatusBadge extends StatelessWidget {
  final String? customLabel;
  final BorrowStatus? borrowStatus;
  final bool? isAvailable;
  final bool compact;

  const StatusBadge.borrowStatus({
    super.key,
    required this.borrowStatus,
    this.compact = false,
  })  : isAvailable = null,
        customLabel = null;

  const StatusBadge.availability({
    super.key,
    required this.isAvailable,
    this.compact = false,
  })  : borrowStatus = null,
        customLabel = null;

  const StatusBadge.custom({
    super.key,
    required this.customLabel,
    required Color color,
    required Color bgColor,
    this.compact = false,
  })  : isAvailable = null,
        borrowStatus = null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color bgColor;
    Color textColor;
    IconData icon;
    String label;

    if (isAvailable != null) {
      if (isAvailable!) {
        bgColor = AppColors.successBg;
        textColor = AppColors.accentGreen;
        icon = Icons.check_circle_outline;
        label = l10n.statusAvailable;
      } else {
        bgColor = AppColors.errorBg;
        textColor = AppColors.error;
        icon = Icons.highlight_off;
        label = l10n.statusUnavailable;
      }
    } else if (borrowStatus != null) {
      switch (borrowStatus!) {
        case BorrowStatus.issued:
          bgColor = AppColors.infoBg;
          textColor = AppColors.info;
          icon = Icons.outbox;
          label = l10n.statusIssued;
          break;
        case BorrowStatus.returned:
          bgColor = AppColors.successBg;
          textColor = AppColors.accentGreen;
          icon = Icons.assignment_turned_in_outlined;
          label = l10n.statusReturned;
          break;
        case BorrowStatus.overdue:
          bgColor = AppColors.errorBg;
          textColor = AppColors.error;
          icon = Icons.warning_amber_rounded;
          label = l10n.statusOverdue;
          break;
      }
    } else {
      bgColor = AppColors.surfaceVariant;
      textColor = AppColors.textSecondary;
      icon = Icons.info_outline;
      label = customLabel ?? '';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 12 : 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
