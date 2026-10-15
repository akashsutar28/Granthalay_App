import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/member.dart';
import '../../repositories/member_repository.dart';

class AddEditMemberScreen extends StatefulWidget {
  final MemberRepository memberRepository;
  final Member? memberToEdit;

  const AddEditMemberScreen({
    super.key,
    required this.memberRepository,
    this.memberToEdit,
  });

  @override
  State<AddEditMemberScreen> createState() => _AddEditMemberScreenState();
}

class _AddEditMemberScreenState extends State<AddEditMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  bool _isLoading = false;
  bool get _isEditing => widget.memberToEdit != null;

  @override
  void initState() {
    super.initState();
    final m = widget.memberToEdit;
    _codeController = TextEditingController(text: m?.memberCode ?? 'M00${widget.memberRepository.members.length + 1}');
    final initialName = m != null ? (m.nameMr.isNotEmpty ? m.nameMr : m.nameEn) : '';
    _nameController = TextEditingController(text: initialName);
    _phoneController = TextEditingController(text: m?.phone ?? '');
    _emailController = TextEditingController(text: m?.email ?? '');
    _addressController = TextEditingController(text: m?.address ?? '');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final enteredName = _nameController.text.trim();
    String nameMr = enteredName;
    String nameEn = enteredName;
    if (_isEditing && widget.memberToEdit != null) {
      final old = widget.memberToEdit!;
      if (enteredName == old.nameMr) {
        nameMr = old.nameMr;
        nameEn = old.nameEn.isNotEmpty ? old.nameEn : enteredName;
      } else if (enteredName == old.nameEn) {
        nameMr = old.nameMr.isNotEmpty ? old.nameMr : enteredName;
        nameEn = old.nameEn;
      }
    }

    final member = Member(
      id: widget.memberToEdit?.id ?? '',
      memberCode: _codeController.text.trim(),
      nameMr: nameMr,
      nameEn: nameEn,
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      departmentClass: widget.memberToEdit?.departmentClass ?? '',
      registeredDate: widget.memberToEdit?.registeredDate ?? DateTime.now(),
    );

    try {
      if (_isEditing) {
        await widget.memberRepository.updateMember(member);
      } else {
        await widget.memberRepository.addMember(member);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? l10n.successUpdated : l10n.successSaved),
            backgroundColor: AppColors.accentGreen,
          ),
        );
        Navigator.pop(context, member);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editMember : l10n.addMember),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Member Code
              _buildSectionTitle(l10n.memberCode),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: l10n.memberCode,
                  hintText: 'उदा. M001',
                  prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primary),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return l10n.codeRequired;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Full Name
              _buildSectionTitle(l10n.fullName),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.fullName,
                  hintText: l10n.fullNameHint,
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return l10n.fullNameRequired;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Contact Information
              _buildSectionTitle(l10n.phoneNumber),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  hintText: '९८२२०१२३४५',
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return l10n.phoneNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.emailAddress,
                  hintText: 'example@email.com',
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                ),
              ),

              const SizedBox(height: 20),

              // Address
              _buildSectionTitle(l10n.address),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: l10n.address,
                  hintText: 'उदा. शिवाजी नगर, पुणे',
                  prefixIcon: const Icon(Icons.home_outlined, color: AppColors.primary),
                ),
              ),

              const SizedBox(height: 32),

              // Save & Cancel Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSave,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(l10n.save),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
