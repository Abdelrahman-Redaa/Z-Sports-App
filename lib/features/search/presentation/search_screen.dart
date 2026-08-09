import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/core/widgets/category_chip.dart';
import 'package:z_sports_booking/core/widgets/pitch_card.dart';
import 'package:z_sports_booking/core/widgets/search_bar_widget.dart';
import 'package:z_sports_booking/data/models/pitch_model.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_cubit.dart';
import 'package:z_sports_booking/features/home/presentation/cubit/stadium_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PitchModel> _applyFilters(List<PitchModel> all, List<dynamic> categories) {
    var results = all;

    if (_selectedCategoryIndex > 0 && categories.isNotEmpty) {
      final cat = categories[_selectedCategoryIndex - 1];
      final catName = cat.name as String;
      results = results.where((p) {
        return p.category.toLowerCase().contains(catName.toLowerCase()) ||
            catName.toLowerCase().contains(p.category.toLowerCase());
      }).toList();
    }

    if (_query.isNotEmpty) {
      final lower = _query.toLowerCase();
      results = results.where((p) {
        return p.name.toLowerCase().contains(lower) ||
            p.location.toLowerCase().contains(lower) ||
            p.category.toLowerCase().contains(lower);
      }).toList();
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<StadiumCubit, StadiumState>(
          builder: (context, state) {
            final allStadiums = state is StadiumLoaded ? state.stadiums : <PitchModel>[];
            final categories = state is StadiumLoaded ? state.categories : [];
            final filtered = _applyFilters(allStadiums, categories);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Text(
                    AppStrings.search,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
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
                    itemCount: categories.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      final label = index == 0 ? 'الكل' : categories[index - 1].name as String;
                      return CategoryChip(
                        label: label,
                        isSelected: _selectedCategoryIndex == index,
                        onTap: () => setState(() => _selectedCategoryIndex = index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (state is StadiumLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
                else
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                                const SizedBox(height: 12),
                                Text(
                                  'لا توجد نتائج',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (_, index) {
                              final pitch = filtered[index];
                              return PitchCard(
                                pitch: pitch,
                                onTap: () => context.push('/pitch/${pitch.id}'),
                              );
                            },
                          ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
