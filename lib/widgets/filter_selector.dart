import 'package:auto_print/widget_fixer.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../constants/filter_constants.dart';

class FilterSelector extends StatelessWidget {
  final ui.Image? userImage;
  final FilterType selectedFilter;
  final Function(FilterType) onFilterSelected;

  const FilterSelector({
    super.key,
    required this.userImage,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: FilterType.values.length,
      itemBuilder: (context, index) {
        final filter = FilterType.values[index];
        return Container(
          width: 80,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedFilter == filter ? Colors.blue : Colors.grey,
              width: selectedFilter == filter ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  child: userImage == null
                      ? Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
                        )
                      : ColorFiltered(
                          colorFilter: filter.filter ??
                              const ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.srcOver,
                              ),
                          child: RawImage(
                            image: userImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      selectedFilter == filter ? Colors.blue : Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(6),
                  ),
                ),
                child: Text(
                  filter.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        selectedFilter == filter ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ).inkWell(onTap: () => onFilterSelected(filter));
      },
    ).sizeBox(height: 60).padding(const EdgeInsets.only(bottom: 16));
  }
}
