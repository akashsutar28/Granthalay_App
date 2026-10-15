import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;
  final bool autofocus;

  const SearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.onClear,
    this.autofocus = false,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _internalController;
  TextEditingController get _controller => widget.controller ?? _internalController;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_updateHasText);
  }

  void _updateHasText() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateHasText);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.textMuted,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textSecondary),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    widget.onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
