import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class FilterChips extends StatelessWidget {
  final List<String> filters;
  final String active;
  final ValueChanged<String> onSelected;

  const FilterChips({super.key, required this.filters, required this.active, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    final safeActive = filters.contains(active) ? active : (filters.isNotEmpty ? filters.first : 'All');

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: AppTheme.chipBackground, borderRadius: BorderRadius.circular(10)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: safeActive,
            items: filters
                .map(
                  (f) => DropdownMenuItem(
                    value: f,
                    child: Text(f, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onSelected(v);
            },
            dropdownColor: AppTheme.cardBackground,
            style: TextStyle(color: AppTheme.primaryText, fontSize: 14),
            iconEnabledColor: AppTheme.accent,
          ),
        ),
      ),
    );
  }
}
