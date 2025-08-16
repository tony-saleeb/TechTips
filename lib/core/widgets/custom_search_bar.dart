import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../constants/app_icons.dart';

/// Custom search bar widget
class CustomSearchBar extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool autofocus;
  
  const CustomSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.controller,
    this.autofocus = false,
  });
  
  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  bool _showClearButton = false;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _showClearButton = _controller.text.isNotEmpty;
  }
  
  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }
  
  void _onTextChanged() {
    final showClear = _controller.text.isNotEmpty;
    if (_showClearButton != showClear) {
      setState(() {
        _showClearButton = showClear;
      });
    }
    widget.onChanged?.call(_controller.text);
  }
  
  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText ?? AppStrings.searchHint,
          prefixIcon: const Icon(AppIcons.search),
          suffixIcon: _showClearButton
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _onClear,
                  tooltip: 'Clear search',
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
