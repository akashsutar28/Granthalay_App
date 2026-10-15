import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/borrow_record.dart';
import '../../repositories/borrowing_repository.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/custom_card.dart';

class OverdueBooksScreen extends StatefulWidget {
  final BorrowingRepository borrowingRepository;

  const OverdueBooksScreen({
    super.key,
    required this.borrowingRepository,
  });

  @override
  State<OverdueBooksScreen> createState() => _OverdueBooksScreenState();
}

class _OverdueBooksScreenState extends State<OverdueBooksScreen> {
  void _confirmReturn(BorrowRecord record) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.returnBookTitle),
        content: Text('${l10n.returnConfirmPrompt}\n\n${record.displayBookTitle(locale)}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.borrowingRepository.returnBook(record.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.returnSuccess), backgroundColor: AppColors.accentGreen),
                );
              }
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.overdueBooksTitle),
      ),
      body: ListenableBuilder(
        listenable: widget.borrowingRepository as Listenable,
        builder: (context, _) {
          final overdueRecords = widget.borrowingRepository.records
              .where((r) => r.isCurrentlyOverdue)
              .toList();

          return Column(
            children: [
              // Notice banner
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.overdueWarning,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: overdueRecords.isEmpty
                    ? EmptyState(
                        icon: Icons.done_all_rounded,
                        title: 'सर्व पुस्तके वेळेत आहेत!',
                        subtitle: 'सध्या कोणत्याही पुस्तकाची मुदत संपलेली नाही.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: overdueRecords.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final rec = overdueRecords[i];
                          return CustomCard(
                            padding: const EdgeInsets.all(16),
                            border: Border.all(color: AppColors.error.withOpacity(0.4), width: 1.2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.errorBg,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.timer_off_outlined, size: 14, color: AppColors.error),
                                          const SizedBox(width: 4),
                                          Text(
                                            l10n.daysOverdue(rec.daysOverdue),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.error,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      rec.bookCode,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  rec.displayBookTitle(locale),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.borrowingHistory,
                                      arguments: {
                                        'memberId': rec.memberId,
                                        'memberName': rec.displayMemberName(locale),
                                        'memberCode': rec.memberCode,
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person_rounded, size: 16, color: AppColors.primary),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${rec.displayMemberName(locale)} (${rec.memberCode})',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.phone_outlined, size: 14, color: AppColors.textMuted),
                                    const SizedBox(width: 6),
                                    Text(
                                      rec.memberPhone,
                                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${l10n.dueDate}: ${rec.dueDate.day}/${rec.dueDate.month}/${rec.dueDate.year}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => _confirmReturn(rec),
                                      icon: const Icon(Icons.move_to_inbox_rounded, size: 16),
                                      label: Text(l10n.quickReturnBook),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentGreen,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
