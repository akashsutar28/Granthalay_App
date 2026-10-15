import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routing/app_routes.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/member.dart';
import '../../repositories/member_repository.dart';
import '../../widgets/search_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/custom_card.dart';

class MembersListScreen extends StatefulWidget {
  final MemberRepository memberRepository;
  final VoidCallback? onOpenDrawer;

  const MembersListScreen({
    super.key,
    required this.memberRepository,
    this.onOpenDrawer,
  });

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.membersTitle),
        leading: widget.onOpenDrawer != null
            ? IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: widget.onOpenDrawer,
              )
            : null,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addMemberFab',
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addEditMember);
        },
        icon: const Icon(Icons.person_add_rounded),
        label: Text(l10n.addMember),
      ),
      body: ListenableBuilder(
        listenable: widget.memberRepository as Listenable,
        builder: (context, _) {
          final allMembers = widget.memberRepository.members;
          final query = _searchQuery.trim().toLowerCase();

          final filteredMembers = allMembers.where((m) {
            if (query.isEmpty) return true;
            return m.memberCode.toLowerCase().contains(query) ||
                m.nameMr.toLowerCase().contains(query) ||
                m.nameEn.toLowerCase().contains(query) ||
                m.phone.toLowerCase().contains(query) ||
                m.departmentClass.toLowerCase().contains(query);
          }).toList();

          return Column(
            children: [
              // Search Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SearchField(
                  hintText: l10n.searchMembersPlaceholder,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ),

              // Members List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await widget.memberRepository.getMembers();
                  },
                  child: filteredMembers.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            EmptyState(
                              icon: Icons.people_outline_rounded,
                              title: l10n.membersTitle,
                              subtitle: l10n.searchPersonNoResults,
                              actionLabel: l10n.addMember,
                              onAction: () => Navigator.pushNamed(context, AppRoutes.addEditMember),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredMembers.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            return _MemberCard(
                              member: member,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.memberDetails,
                                  arguments: member,
                                );
                              },
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

class _MemberCard extends StatelessWidget {
  final Member member;
  final VoidCallback onTap;

  const _MemberCard({
    required this.member,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.displayName(locale).isNotEmpty
                    ? member.displayName(locale).characters.first
                    : 'M',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        member.displayName(locale),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      member.phone,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    if (member.departmentClass.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      const Text('•', style: TextStyle(color: AppColors.border)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          member.departmentClass,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
