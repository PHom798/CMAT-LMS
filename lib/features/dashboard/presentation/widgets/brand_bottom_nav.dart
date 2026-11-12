import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:w3_lms/core/design_system/design_system.dart';
import 'package:w3_lms/features/dashboard/presentation/main_tab.dart';

/// Bottom navigation in the brand style: the selected tab gets a soft
/// orange pill behind its icon.
class BrandBottomNav extends StatelessWidget {
  const BrandBottomNav({super.key, required this.current, required this.onSelected});

  final MainTab current;
  final ValueChanged<MainTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line, width: 1.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: [
              for (final tab in MainTab.values)
                Expanded(
                  child: _NavItem(
                    tab: tab,
                    isSelected: tab == current,
                    onTap: () {
                      if (tab != current) HapticFeedback.selectionClick();
                      onSelected(tab);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.tab, required this.isSelected, required this.onTap});

  final MainTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.orangeDeep : AppColors.muted;
    return Semantics(
      button: true,
      selected: isSelected,
      label: tab.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: AppMotion.fast,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orangeSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Icon(isSelected ? tab.selectedIcon : tab.icon, color: color, size: 24),
            ),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: AppText.caption.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
