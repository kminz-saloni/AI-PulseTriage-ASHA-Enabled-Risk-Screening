import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Search bar with filter support
class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearch;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final IconData? prefixIcon;

  const CustomSearchBar({
    Key? key,
    this.hintText = 'Search...',
    required this.onSearch,
    this.onClear,
    this.controller,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onSearch,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: AppTheme.hintText,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          widget.prefixIcon ?? Icons.search,
          color: AppTheme.primaryTeal,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                  widget.onClear?.call();
                  widget.onSearch('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.lg,
          vertical: AppTheme.md,
        ),
        filled: true,
        fillColor: AppTheme.bgLighter,
      ),
    );
  }
}

/// Filter chips for patient filtering
class FilterChips extends StatefulWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onSelectionChanged;

  const FilterChips({
    Key? key,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...widget.options.map((option) {
            final isSelected = _selected.contains(option);
            return Padding(
              padding: const EdgeInsets.only(right: AppTheme.sm),
              child: FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selected.add(option);
                    } else {
                      _selected.remove(option);
                    }
                    widget.onSelectionChanged(_selected);
                  });
                },
                backgroundColor: AppTheme.bgLighter,
                selectedColor: AppTheme.accentTeal,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.darkText,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                side: BorderSide(
                  color: isSelected ? AppTheme.accentTeal : AppTheme.borderColor,
                  width: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

/// Section header with optional action button
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final TextStyle? titleStyle;

  const SectionHeader({
    Key? key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.lg,
        vertical: AppTheme.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ??
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryTeal,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Empty state placeholder
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppTheme.lightText,
            ),
            const SizedBox(height: AppTheme.lg),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.md),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.mediumText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: AppTheme.xl),
              TextButton(
                onPressed: onActionTap,
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryTeal,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Progress indicator with label
class ProgressIndicatorWithLabel extends StatelessWidget {
  final String label;
  final String value;
  final double progress; // 0.0 to 1.0
  final Color color;
  final String? unit;

  const ProgressIndicatorWithLabel({
    Key? key,
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
            ),
            Text(
              '$value${unit != null ? ' $unit' : ''}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

/// Divider with optional text
class CustomDivider extends StatelessWidget {
  final String? text;
  final double height;
  final Color color;

  const CustomDivider({
    Key? key,
    this.text,
    this.height = AppTheme.lg,
    this.color = AppTheme.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return Divider(
        height: height,
        color: color,
        thickness: 0.5,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height / 2),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: color,
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.md),
            child: Text(
              text!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppTheme.mediumText,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: color,
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab bar with custom styling
class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final ValueChanged<int> onTabChanged;
  final int initialIndex;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.onTabChanged,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.cardBg,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            widget.tabs.length,
            (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = index);
                  widget.onTabChanged(index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.lg,
                    vertical: AppTheme.md,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected
                            ? AppTheme.primaryTeal
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.tabs[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primaryTeal
                          : AppTheme.mediumText,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
