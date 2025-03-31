import 'package:auto_print/simple_widget/simple_text.dart';
import 'package:flutter/material.dart';

class SimpleButton extends StatefulWidget {
  ///callback
  final Function()? buttonAction;

  /// 圖片跟字的相對位置 圖->字
  final Segmented? segmented;

  /// input Colors.white
  final Color? backgroundColor;

  final Color? selectedColor;

  /// input Colors
  final Color? titleColor;

  final Color? selectedTitleColor;

  ///  input MaterialStateProperty.all(Colors.white)
  final Color? iconColor;

  final Color? selectedTintColor;

  /// ButtonImage
  final String? imageName;

  /// image size
  final Size? imageSize;

  /// url
  final String? imageURL;

  /// input string
  final String? buttontitle;

  ///圓角
  final double? cornerRadius;

  ///字體大小
  final double? fontSize;

  ///button允許的最小尺寸，預設0
  final Size? buttonMiniSize;

  final Size? buttonMaxize;

  final EdgeInsets? buttonPadding;

  final IconData? buttonIcon;
  final double? iconSize;

  final Color? borderColor;

  final double? borderWidth;

  final FontWeight? fontWeight;

  final bool selected;

  final bool? autoSize;

  final double? imageTextSpace;
  const SimpleButton(
      {super.key,
      this.buttonAction,
      this.segmented,
      this.titleColor,
      this.backgroundColor,
      this.iconColor,
      this.cornerRadius,
      this.buttontitle,
      this.fontSize,
      this.imageName,
      this.imageURL,
      this.imageSize,
      this.buttonMiniSize,
      this.buttonMaxize,
      this.buttonPadding,
      this.buttonIcon,
      this.borderColor,
      this.borderWidth,
      this.fontWeight,
      this.selectedColor,
      this.selected = false,
      this.imageTextSpace,
      this.selectedTitleColor,
      this.selectedTintColor,
      this.iconSize,
      this.autoSize});

  @override
  State<SimpleButton> createState() => _SimpleButtonState();
}

class _SimpleButtonState extends State<SimpleButton> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant SimpleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            side: WidgetStateProperty.all(BorderSide(
                color: widget.borderColor ?? Colors.transparent,
                width: widget.borderWidth ?? 0.0)),
            padding: WidgetStateProperty.all(widget.buttonPadding),
            minimumSize: WidgetStateProperty.all(widget.buttonMiniSize),
            backgroundColor: WidgetStateProperty.all(selected
                ? (widget.selectedColor ?? widget.backgroundColor)
                : widget.backgroundColor),
            foregroundColor: WidgetStateProperty.all(selected
                ? (widget.selectedTintColor ?? widget.iconColor)
                : widget.iconColor),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.cornerRadius ?? 0))),
            shadowColor: WidgetStateProperty.all(Colors.black)),
        onPressed: widget.buttonAction != null
            ? () {
                setState(() {
                  selected = !selected;
                });
                if (widget.buttonAction != null) {
                  widget.buttonAction!();
                }
              }
            : null,
        child: creatButton(widget.segmented ?? Segmented.upToDown));
  }

  Image getImageFromNet(String imageURL) {
    return Image.network(
      imageURL,
      height: widget.imageSize?.height,
      width: widget.imageSize?.width,
      color: widget.iconColor,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Handle the error and return null
        debugPrint("Image loading failed: $exception");
        return Container();
      },
    );
  }

  Widget creatButton(Segmented segmented) {
    Widget text = SimpleText(
      text: widget.buttontitle ?? "",
      fontSize: widget.fontSize,
      textColor: selected
          ? (widget.selectedTitleColor ?? widget.titleColor)
          : widget.titleColor,
      fontWeight: widget.fontWeight,
      lines: 999,
      autoFitWidth: widget.autoSize,
    );

    Image? image = widget.imageName != null
        ? Image.asset(
            "asset/${widget.imageName}",
            height: widget.imageSize?.height,
            width: widget.imageSize?.width,
            color: selected
                ? (widget.selectedTintColor ?? widget.iconColor)
                : widget.iconColor,
          )
        : widget.imageURL != null
            ? getImageFromNet(widget.imageURL!)
            : null;

    SizedBox space = SizedBox(
      height: widget.imageTextSpace,
      width: widget.imageTextSpace,
    );

    if (widget.imageName == null &&
        widget.buttonIcon == null &&
        widget.imageURL == null) {
      return text;
    } else {
      switch (segmented) {
        case Segmented.upToDown:
          List<Widget> dynamicList = [
            image ??
                Icon(
                  widget.buttonIcon,
                  size: widget.iconSize,
                  color: selected
                      ? (widget.selectedTintColor ?? widget.iconColor)
                      : widget.iconColor,
                ),
            space
          ];
          if (widget.buttontitle != null) {
            dynamicList.add(text);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: dynamicList,
          );
        case Segmented.downToUp:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.buttontitle != null) text,
              space,
              image ??
                  Icon(
                    widget.buttonIcon,
                    size: widget.iconSize,
                    color: selected
                        ? (widget.selectedTintColor ?? widget.iconColor)
                        : widget.iconColor,
                  ),
            ],
          );
        case Segmented.leftToRight:
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image ??
                  Icon(
                    widget.buttonIcon,
                    size: widget.iconSize,
                    color: selected
                        ? (widget.selectedTintColor ?? widget.iconColor)
                        : widget.iconColor,
                  ),
              space,
              if (widget.buttontitle != null) text,
            ],
          );
        case Segmented.rightToLeft:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.buttontitle != null) text,
              space,
              image ??
                  Icon(
                    widget.buttonIcon,
                    size: widget.iconSize,
                    color: selected
                        ? (widget.selectedTintColor ?? widget.iconColor)
                        : widget.iconColor,
                  ),
            ],
          );
      }
    }
  }
}

enum Segmented { upToDown, leftToRight, rightToLeft, downToUp }
