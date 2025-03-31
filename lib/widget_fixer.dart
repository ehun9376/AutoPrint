import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension DateTimeExtensions on DateTime {
  bool isAfterToday() {
    final now = DateTime.now();
    return isAfter(now);
  }
}

extension ListWidgetStyles on List<Widget> {
  Widget paddingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: this,
    ).padding(const EdgeInsets.all(20));
  }
}

extension Styles on Widget {
  SliverPersistentHeader sliverPersistentHeader({
    required double maxHeight,
  }) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SliverHeaderDelegate(
        child: this,
        minHeight: maxHeight,
        maxHeight: maxHeight,
      ),
    );
  }

  SliverToBoxAdapter sliverToBoxAdapter() {
    return SliverToBoxAdapter(
      child: this,
    );
  }

  SizedBox sizeBox({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  InkWell inkWell({
    Function()? onTap,
    Function()? onLongPress,
    Function()? onDoubleTap,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      child: this,
    );
  }

  GestureDetector gestureDetector({
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    Function(DragUpdateDetails)? onVerticalDragUpdate,
  }) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: this,
    );
  }

  Visibility visibility(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: this,
    );
  }

  Widget hero(String tag) {
    return Hero(tag: tag, child: this);
  }

  Widget blurWidget({double blur = 5, Color color = Colors.white}) {
    return Blur(
      blurColor: color,
      blur: blur,
      child: this,
    );
  }

  Widget buildBorderAround({required BuildContext context}) {
    return sizedBox(
      height: 120,
    )
        .container(
            decoration: BoxDecoration(
                border: Border.all(
          width: 1,
          color: Theme.of(context).dividerColor,
        )))
        .padding(const EdgeInsets.symmetric(horizontal: 20));
  }

  SizedBox sizedBox({double? width, double? height}) {
    return SizedBox(
      height: height,
      width: width,
      child: this,
    );
  }

  Widget card() {
    return Card(
      child: this,
    );
  }

  Widget center() {
    return Center(child: this);
  }

  Widget padding([EdgeInsets defaultValue = const EdgeInsets.all(20)]) {
    return Padding(
      padding: defaultValue,
      child: this,
    );
  }

  Widget compositedTransformTarget(LayerLink link) {
    return CompositedTransformTarget(
      link: link,
      child: this,
    );
  }

  Widget position({double? left, double? top, double? right, double? bottom}) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: this,
    );
  }

  CustomScrollView customScrollView({
    List<Widget> slivers = const [],
  }) {
    return CustomScrollView(
      slivers: slivers,
    );
  }

  Flexible flexible([int defaultValue = 1, FlexFit fit = FlexFit.tight]) {
    return Flexible(
      flex: defaultValue,
      fit: fit,
      child: this,
    );
  }

  Widget column([
    MainAxisAlignment mainDefault = MainAxisAlignment.center,
    CrossAxisAlignment crossDefault = CrossAxisAlignment.center,
  ]) {
    return Column(
      mainAxisAlignment: mainDefault,
      crossAxisAlignment: crossDefault,
      children: [this],
    );
  }

  Widget container({
    double? width,
    double? height,
    Color? color,
    BoxConstraints? constraints,
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: decoration,
      color: color,
      constraints: constraints,
      child: this,
    );
  }

  Widget widgetWithRow(
      {MainAxisSize mainAxisSize = MainAxisSize.max,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [this],
    );
  }

  Widget flexWidgetWithRow([MainAxisSize mainAxisSize = MainAxisSize.max]) {
    return Row(
      mainAxisSize: mainAxisSize,
      children: [this].map((e) => e.flexible()).toList(),
    );
  }

  Widget singleChildScrollView(
      {bool scrollAble = true, Axis scrollDirection = Axis.vertical}) {
    return SingleChildScrollView(
      physics:
          scrollAble ? ClampingScrollPhysics() : NeverScrollableScrollPhysics(),
      scrollDirection: scrollDirection,
      child: this,
    );
  }

  ChangeNotifierProvider<T> provider<T extends ChangeNotifier>(
      {required T value}) {
    return ChangeNotifierProvider.value(
      value: value,
      builder: (context, child) {
        return this;
      },
    );
  }

  AnimatedSwitcher animatedSwitcher() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: this,
    );
  }

  AbsorbPointer absorbPointer({bool absorbing = true}) {
    return AbsorbPointer(
      absorbing: absorbing,
      child: this,
    );
  }
}

extension Layouts on List<Widget> {
  Widget column([
    MainAxisAlignment mainDefault = MainAxisAlignment.center,
    CrossAxisAlignment crossDefault = CrossAxisAlignment.center,
  ]) {
    return Column(
      mainAxisAlignment: mainDefault,
      crossAxisAlignment: crossDefault,
      children: this,
    );
  }

  Row row(
      [MainAxisAlignment defaultValue = MainAxisAlignment.center,
      CrossAxisAlignment cross = CrossAxisAlignment.center]) {
    return Row(
      mainAxisAlignment: defaultValue,
      crossAxisAlignment: cross,
      children: this,
    );
  }

  Widget listView({
    Axis scrollDirection = Axis.vertical,
  }) {
    return ListView(
      scrollDirection: scrollDirection,
      children: this,
    );
  }

  Widget stack({
    AlignmentDirectional alignment = AlignmentDirectional.topEnd,
  }) {
    return Stack(
      alignment: alignment,
      children: this,
    );
  }
}

extension ListExtensions<T> on List<T> {
  List<T> copy() {
    return List<T>.from(this);
  }
}

extension Actions on Widget {
  //refresh list

  Widget refreshIndicator({required Future Function() onRefresh}) {
    return RefreshIndicator(
      color: Colors.black, // 自訂刷新圈的顏色
      backgroundColor: Colors.white, // 背景色
      strokeWidth: 2.0, // 加粗刷新圈
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 300));
        onRefresh();
      },
      child: this,
    );
  }

  Widget withCustomRefreshIndicator(
      {required Future<void> Function() onRefresh}) {
    return CustomRefreshIndicator(onRefresh: onRefresh, child: this);
  }

  Widget addLoadMoreBehavior({
    required Future Function() loadMore,
    required BuildContext context,
  }) {
    return NotificationListener<ScrollNotification>(
      onNotification: (p0) {
        // debugPrint("現在位置 ${p0.metrics.pixels}");
        // debugPrint("還有多少到底 ${p0.metrics.extentAfter}");
        // debugPrint("最多有多少 ${p0.metrics.maxScrollExtent}");

        if (p0.metrics.extentAfter < 300) {
          loadMore();
        }
        return true;
      },
      child: this,
    );
  }

  Widget notificationListener<T extends Notification>({
    bool Function(T)? onNotification,
  }) {
    return NotificationListener<T>(
      onNotification: onNotification,
      child: this,
    );
  }

  SizedBox sizebox({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  Widget changeNotifierProvider<T extends ChangeNotifier>({required T value}) {
    return ChangeNotifierProvider.value(
      value: value,
      builder: (context, child) {
        return this;
      },
    );
  }
}

extension NumberExtension on int {
  bool andOperation(int otherNumber) {
    return this & otherNumber > 0;
  }
}

extension NavigatorStateExtension on NavigatorState {
  void pushPage(Widget page) {
    push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void replacePage(Widget page) {
    pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  SliverHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  CustomRefreshIndicatorState createState() => CustomRefreshIndicatorState();
}

class CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  bool _isRefreshing = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  void _startRefresh() async {
    setState(() => _isRefreshing = true);
    await widget.onRefresh();
    setState(() => _isRefreshing = false);
    _animationController.reverse(); // 結束後動畫回到原始狀態
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            debugPrint("notification.overscroll $notification");
            if (notification is OverscrollNotification) {
              setState(() => _dragOffset = notification.overscroll);
              _animationController.value = (_dragOffset / 100).clamp(0.0, 1.0);
            }
            if (notification is ScrollEndNotification &&
                _dragOffset > 80 &&
                !_isRefreshing) {
              _startRefresh();
            }
            return true;
          },
          child: widget.child,
        ),

        /// 自訂動畫區域
        Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.5 + _animationController.value * 0.5,
                child: Opacity(
                  opacity: _animationController.value,
                  child: _isRefreshing
                      ? CircularProgressIndicator(color: Colors.blue)
                      : Icon(Icons.refresh, size: 30, color: Colors.blue),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
