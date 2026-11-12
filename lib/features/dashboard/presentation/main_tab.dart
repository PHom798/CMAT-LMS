import 'package:flutter/material.dart';

/// Bottom navigation destinations. Add a value here (and a case in
/// MainShell) to add a tab; nothing else needs restructuring.
enum MainTab {
  home('Home', Icons.home_rounded, Icons.home_outlined),
  practice('Practice', Icons.school_rounded, Icons.school_outlined),
  profile('Profile', Icons.person_rounded, Icons.person_outline_rounded);

  const MainTab(this.label, this.selectedIcon, this.icon);

  final String label;
  final IconData selectedIcon;
  final IconData icon;
}
