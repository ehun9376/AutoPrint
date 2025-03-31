import 'package:auto_print/simple_widget/simple_text.dart';
import 'package:auto_print/widget_fixer.dart';
import 'package:flutter/material.dart';

class SimpleHorizontalScrollList extends StatefulWidget {
  const SimpleHorizontalScrollList(
      {super.key,
      required this.list,
      required this.onTap,
      required this.initText,
      this.scrollTargetToCenter = true});

  final List<String> list;
  final String initText;
  final Function(String) onTap;
  final bool scrollTargetToCenter;

  @override
  SimpleHorizontalScrollListState createState() =>
      SimpleHorizontalScrollListState();
}

class SimpleHorizontalScrollListState
    extends State<SimpleHorizontalScrollList> {
  final screenWidthMaxItemsCount = 4;
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  double itemWidth = 0;
  double totalWidth = 0;
  double barPosition = 25;

  Map<String, GlobalKey> keyMap = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedIndex = widget.list.indexOf(widget.initText);
      _scrollToInitialPosition();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedIndex = widget.list.indexOf(widget.initText);
      _scrollToInitialPosition();
    });
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant SimpleHorizontalScrollList oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedIndex = widget.list.indexOf(widget.initText);
      _scrollToInitialPosition();
    });
    super.didUpdateWidget(oldWidget);
  }

  void _scrollToInitialPosition() async {
    if (selectedIndex >= 0 && selectedIndex < widget.list.length) {
      if (widget.scrollTargetToCenter) {
        _scrollController.jumpTo(selectedIndex * itemWidth - itemWidth / 2);
      }
      await Future.delayed(const Duration(milliseconds: 300));

      _scrollBarToTargetText();
    }
  }

  void _scrollBarToTargetText() {
    RenderBox? renderBox = keyMap[widget.list[selectedIndex]]
        ?.currentContext
        ?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      // 獲取相對於視口的位置，而不是全局位置
      Offset position = renderBox.localToGlobal(Offset.zero);
      // 調整滾動位置
      double scrollOffset = _scrollController.offset;
      barPosition = position.dx - scrollOffset + itemWidth / 2 - itemWidth / 4;
      setState(() {});
    }
  }

  void _onScroll() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollBarToTargetText();
    });
  }

  @override
  Widget build(BuildContext context) {
    itemWidth = MediaQuery.of(context).size.width / screenWidthMaxItemsCount;
    totalWidth = itemWidth * widget.list.length;
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.list.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              keyMap[widget.list[index]] = GlobalKey();
              return Container(
                key: keyMap[widget.list[index]],
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width /
                        screenWidthMaxItemsCount),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SimpleText(
                  text: widget.list[index],
                  fontSize: 16,
                  textColor:
                      selectedIndex == index ? Colors.black : Colors.grey[400],
                  align: TextAlign.center,
                ),
              ).inkWell(onTap: () async {
                selectedIndex = index;
                await _scrollController.animateTo(
                  index * itemWidth - itemWidth / 2,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );

                widget.onTap(widget.list[index]);

                _scrollBarToTargetText();

                // setState(() {
                //   selectedIndex = index;
                // });
              });
            },
          ),
        ),
        Stack(
          children: [
            Container(
              height: 3,
              color: Colors.grey[200],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              left: barPosition,
              child: Container(
                width: itemWidth / 2,
                height: 3,
                color: Colors.black,
              ),
            )
          ],
        ).sizedBox(height: 2),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
