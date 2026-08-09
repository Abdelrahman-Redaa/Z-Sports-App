import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/core/widgets/category_chip.dart';
import 'package:z_sports_booking/core/widgets/pitch_card.dart';
import 'package:z_sports_booking/core/widgets/search_bar_widget.dart';
import 'package:z_sports_booking/data/mock/mock_data.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  int _selectedCategory = 0;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PitchModel> get _filteredPitches {
    var results = MockData.pitches;
    if (_selectedCategory > 0) {
      final category = MockData.categories[_selectedCategory];
      results = results.where((p) => p.category == category).toList();
    }
    if (_query.isNotEmpty) {
      results = results
          .where((p) => p.name.contains(_query) || p.location.contains(_query))
          .toList();
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                AppStrings.search,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SearchBarWidget(
                hint: AppStrings.searchHint,
                readOnly: false,
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: MockData.categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final label = index == 0 ? 'الكل' : MockData.categories[index - 1];
                  return CategoryChip(
                    label: label,
                    isSelected: _selectedCategory == index,
                    onTap: () => setState(() => _selectedCategory = index),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredPitches.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            'لا توجد نتائج',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: _filteredPitches.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final pitch = _filteredPitches[index];
                        return PitchCard(
                          pitch: pitch,
                          onTap: () => context.push('/pitch/${pitch.id}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
