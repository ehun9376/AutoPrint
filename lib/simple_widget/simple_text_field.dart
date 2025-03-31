import 'package:auto_print/simple_widget/simple_image.dart';
import 'package:flutter/material.dart';

class SimpleTextField extends StatefulWidget {
  final TextInputType? keyboardType;
  final String? defaultText;
  final String? placeHolder;
  final Color? backgroundColor;
  final Function(String newValue)? onEditValue;
  final Function(String newValue)? subAction;
  final Function()? onTap;
  final double? cornerRadius;
  final Color? borderColor;
  final double? borderWidth;
  final int? maxLines;
  final bool? readOnly;
  final FocusNode? textFieldFocusNode;
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final bool showClearButton;
  final bool showSearchButton; // 新增搜尋按鈕控制
  const SimpleTextField({
    super.key,
    this.defaultText,
    this.backgroundColor,
    this.cornerRadius,
    this.borderColor,
    this.borderWidth,
    this.placeHolder,
    this.onEditValue,
    this.subAction,
    this.keyboardType,
    this.maxLines,
    this.readOnly,
    this.textFieldFocusNode,
    this.width,
    this.height,
    this.controller,
    this.onTap,
    this.showClearButton = false,
    this.showSearchButton = false, // 新增搜尋按鈕控制
  });

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.textFieldFocusNode ?? FocusNode();

    // 監聽焦點變化
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // 當 TextField 獲得焦點時觸發

        widget.onTap?.call();
        // 確保焦點設置
        if (!_focusNode.hasPrimaryFocus) {
          _focusNode.requestFocus();
        }
      }
    });
  }

  @override
  void dispose() {
    if (widget.textFieldFocusNode == null) {
      _focusNode.dispose(); // 僅在本地創建時釋放
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController localController =
        widget.controller ?? TextEditingController(text: widget.defaultText);

    return Container(
      width: widget.width,
      height: widget.height, // 動態調整高度
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(widget.cornerRadius ?? 0),
      ),
      child: TextField(
        focusNode: _focusNode,
        cursorColor: Colors.black,
        readOnly: widget.readOnly ?? false,
        textAlignVertical:
            widget.height != null ? TextAlignVertical.center : null, // 根據高度居中對齊
        maxLines: widget.maxLines ?? 1,
        textInputAction: (widget.maxLines ?? 1) > 1
            ? TextInputAction.newline
            : TextInputAction.done,
        keyboardType: widget.keyboardType,
        controller: localController,
        decoration: InputDecoration(
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showClearButton)
                SimpleImage(
                  icon: Icons.clear,
                  onTap: () {
                    localController.clear();
                    widget.onEditValue?.call('');
                  },
                ),
              if (widget.showSearchButton)
                SimpleImage(
                  icon: Icons.search,
                  onTap: () {
                    widget.subAction?.call(localController.text);

                    _focusNode.unfocus();
                  },
                ),
            ],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.cornerRadius ?? 0),
            borderSide: BorderSide(
              color: widget.borderColor ?? Colors.transparent,
              width: widget.borderWidth ?? 0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.cornerRadius ?? 0),
            borderSide: BorderSide(
              color: widget.borderColor ?? Colors.transparent,
              width: widget.borderWidth ?? 0,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical:
                widget.height != null ? widget.height! * 0.3 : 5, // 動態調整內邊距
            horizontal: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.cornerRadius ?? 0),
            borderSide: BorderSide(
              color: widget.borderColor ?? Colors.transparent,
              width: widget.borderWidth ?? 0,
            ),
          ),
          hintText: widget.placeHolder,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        onChanged: widget.onEditValue,
        onSubmitted: (text) {
          _focusNode.unfocus();
          widget.subAction?.call(text);
        },

        // onTap: widget.onTap,
      ),
    );
  }
}

class AdaptiveTextField extends StatefulWidget {
  final FocusNode textFieldFocusNode;
  final TextEditingController controller;
  final Function(String) subAction;
  final String placeHolder;
  final Color backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;

  const AdaptiveTextField({
    super.key,
    required this.textFieldFocusNode,
    required this.controller,
    required this.subAction,
    required this.placeHolder,
    required this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.textColor,
  });

  @override
  AdaptiveTextFieldState createState() => AdaptiveTextFieldState();
}

class AdaptiveTextFieldState extends State<AdaptiveTextField> {
  double _textWidth = 0;
  double _textHeight = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateTextWidth);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTextWidth();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextWidth);
    super.dispose();
  }

  void _updateTextWidth() {
    final text = widget.controller.text.isEmpty
        ? widget.placeHolder
        : widget.controller.text;
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: widget.fontSize ?? 18,
          fontWeight: widget.fontWeight ?? FontWeight.w600,
          color: widget.textColor ?? Colors.black,
        ),
      ),
      maxLines: 1,
    )..layout();
    final textScaler = MediaQuery.textScalerOf(context).scale(1);

    setState(() {
      _textWidth = (textPainter.size.width * textScaler)
          .clamp(0.0, MediaQuery.of(context).size.width - 80);
      _textHeight = textPainter.size.height * textScaler;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: SizedBox(
        height: _textHeight + 20, // 加點間距
        width: _textWidth + 20, // 加點間距
        child: TextField(
          cursorColor: Colors.black,
          textAlign: TextAlign.left,
          focusNode: widget.textFieldFocusNode,
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.placeHolder,
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          maxLines: 1,
          onSubmitted: widget.subAction,
          onChanged: (value) {
            setState(() {
              _updateTextWidth();
            });
          },
        ),
      ),
    );
  }
}
