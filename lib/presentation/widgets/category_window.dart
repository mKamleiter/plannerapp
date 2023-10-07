// In presentation/widgets/category_window.dart

import 'package:flutter/material.dart';
import 'package:mallorcaplanner/entities/category.dart';

class CategoryWindow extends StatelessWidget {
  final List<Category> categories;
  final Set<Category> selectedCategories;
  final ValueChanged<Set<Category>> onCategorySelectionChanged;

  CategoryWindow({
    required this.categories,
    required this.selectedCategories,
    required this.onCategorySelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: 1, // Sie können die Logik für die Sichtbarkeit hier oder außerhalb des Widgets steuern
      child: GestureDetector(
        onTap: () {
          // Logik für das Tippen auf das gesamte Widget
        },
        child: Container(
          height: 200,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white.withOpacity(0.7),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: categories.map((category) {
              bool isSelected = selectedCategories.contains(category);
              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    selectedCategories.remove(category);
                  } else {
                    selectedCategories.add(category);
                  }
                  onCategorySelectionChanged(selectedCategories);
                },
                // ... (Rest des Codes bleibt gleich)
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    category.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
