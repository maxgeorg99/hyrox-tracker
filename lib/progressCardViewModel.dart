import 'package:flutter/material.dart';

class ProgressCardViewModel {
  final IconData icon;
  final String title;
  final IconData? diciplineIcon;
  final IconData trendIcon;
  final String trendText;
  final bool isPositiveTrend;

  const ProgressCardViewModel({
    required this.icon,
    required this.title,
    this.diciplineIcon,
    required this.trendIcon,
    required this.trendText,
    required this.isPositiveTrend,
  });

  Color get trendColor => isPositiveTrend ? Colors.green : Colors.red;

  ProgressCardViewModel copyWith({
    IconData? icon,
    String? title,
    IconData? diciplineIcon,
    IconData? trendIcon,
    String? trendText,
    bool? isPositiveTrend,
  }) {
    return ProgressCardViewModel(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      diciplineIcon: diciplineIcon ?? this.diciplineIcon,
      trendIcon: trendIcon ?? this.trendIcon,
      trendText: trendText ?? this.trendText,
      isPositiveTrend: isPositiveTrend ?? this.isPositiveTrend,
    );
  }

  @override
  String toString() {
    return 'ProgressCardViewModel(icon: $icon, title: $title, diciplineIcon: $diciplineIcon, trendIcon: $trendIcon, trendText: $trendText, isPositiveTrend: $isPositiveTrend)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProgressCardViewModel &&
        other.icon == icon &&
        other.title == title &&
        other.diciplineIcon == diciplineIcon &&
        other.trendIcon == trendIcon &&
        other.trendText == trendText &&
        other.isPositiveTrend == isPositiveTrend;
  }

  @override
  int get hashCode {
    return icon.hashCode ^
        title.hashCode ^
        diciplineIcon.hashCode ^
        trendIcon.hashCode ^
        trendText.hashCode ^
        isPositiveTrend.hashCode;
  }
}
