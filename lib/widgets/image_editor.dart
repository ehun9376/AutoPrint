import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../constants/filter_constants.dart';

class ImageEditor extends StatelessWidget {
  final ui.Image? userImage;
  final double scale;
  final Offset position;
  final Function(Offset) onPositionChanged;
  final String selectedFrame;
  final FilterType selectedFilter;
  final GlobalKey previewKey;

  const ImageEditor({
    super.key,
    required this.userImage,
    required this.scale,
    required this.position,
    required this.onPositionChanged,
    required this.selectedFrame,
    required this.selectedFilter,
    required this.previewKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        onPositionChanged(details.delta);
      },
      child: Container(
        width: 276,
        height: 378,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: RepaintBoundary(
          key: previewKey,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                if (userImage != null)
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(position.dx, position.dy)
                      ..scale(scale),
                    child: ColorFiltered(
                      colorFilter: selectedFilter.filter ??
                          const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.srcOver,
                          ),
                      child: RawImage(
                        image: userImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: Image.asset(
                    selectedFrame,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
