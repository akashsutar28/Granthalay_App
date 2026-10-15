import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../repositories/member_repository.dart';
import '../../repositories/borrowing_repository.dart';
import '../../widgets/search_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/custom_card.dart';

class SearchPersonScreen extends StatefulWidget {
  final MemberRepository memberRepository;
  final BorrowingRepository borrowingRepository;

  const SearchPersonScreen({
    super.key,
    required this.memberRepository,
    required this.borrowingRepository,
  });

  @override
  State<SearchPersonScreen> createState() => _SearchPersonScreenState();
}

class _SearchPersonScreenState extends State<SearchPersonScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyQuickQuery(String query) {
    _searchController.text = query;
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.searchPersonTitle),
      ),
      body: ListenableBuilder(
        listenable: widget.memberRepository as Listenable,
        builder: (context, _) {
          final allMembers = widget.memberRepository.members;
          final q = _searchQuery.trim().toLowerCase();

          final matchingMembers = allMembers.where((m) {
            if (q.isEmpty) return true;
            return m.nameMr.toLowerCase().contains(q) ||
                m.nameEn.toLowerCase().contains(q) ||
                m.memberCode.toLowerCase().contains(q) ||
                m.phone.contains(q) ||
                m.departmentClass.toLowerCase().contains(q);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Prominent Search Area
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.searchPersonSubtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SearchField(
                      controller: _searchController,
                      autofocus: false,
                      hintText: l10n.searchPersonPlaceholder,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // Quick Search Suggestions
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _QuickChip(
                          label: 'राहुल पाटील',
                          onTap: () => _applyQuickQuery('राहुल'),
                        ),
                        _QuickChip(
                          label: 'Rahul Patil',
                          onTap: () => _applyQuickQuery('Rahul'),
                        ),
                        _QuickChip(
                          label: 'M001',
                          onTap: () => _applyQuickQuery('M001'),
                        ),
                        _QuickChip(
                          label: 'स्नेहल जोशी',
                          onTap: () => _applyQuickQuery('स्नेहल'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Helper notice
                    Text(
                      l10n.searchPersonHelperText,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              // Matching Results
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await widget.memberRepository.getMembers();
                    await widget.borrowingRepository.getAllRecords();
                  },
                  child: matchingMembers.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            EmptyState(
                              icon: Icons.person_search_rounded,
                              title: l10n.searchPersonNoResults,
                              subtitle: 'वेगळा शब्द, कोड किंवा इंग्रजी नाव वापरून शोधा.',
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                        itemCount: matchingMembers.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final member = matchingMembers[i];
                          final records = widget.borrowingRepository.records
                              .where((r) => r.memberId == member.id)
                              .toList();
                          final activeBorrowed = records.where((r) => !r.isReturned).length;
                          final hasOverdue = records.any((r) => r.isCurrentlyOverdue);

                          return CustomCard(
                            padding: const EdgeInsets.all(16),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.borrowingHistory,
                                arguments: {
                                  'memberId': member.id,
                                  'memberName': member.displayName(locale),
                                  'memberCode': member.memberCode,
                                },
                              );
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.primaryContainer,
                                  child: Text(
                                    member.displayName(locale).isNotEmpty
                                        ? member.displayName(locale).characters.first
                                        : 'M',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              member.displayName(locale),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.surfaceVariant,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              member.memberCode,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${member.phone} • ${member.departmentClass}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: activeBorrowed > 0 ? AppColors.infoBg : AppColors.surfaceVariant,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${l10n.currentlyBorrowed}: $activeBorrowed',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: activeBorrowed > 0 ? AppColors.info : AppColors.textMuted,
                                              ),
                                            ),
                                          ),
                                          if (hasOverdue) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.errorBg,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                l10n.statusOverdue,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.error,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.history_edu_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
