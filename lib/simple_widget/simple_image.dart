import 'dart:io';
import 'package:auto_print/widget_fixer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SimpleImage extends StatelessWidget {
  final Color? backgroudColor;
  final String? imageName;
  final String? imageURL;

  final File? imageFile;

  final Size? imageSize;
  final double? cornerRadius;
  final double? borderWidth;

  final IconData? icon;
  final Color? color;
  final double? iconSize;

  final Color? borderColor;

  final BoxFit? fit;

  final bool? schedule;

  final Size? size;

  final Function()? onTap;

  const SimpleImage(
      {super.key,
      this.size,
      this.imageName,
      this.imageURL,
      this.imageSize,
      this.cornerRadius,
      this.icon,
      this.color,
      this.iconSize,
      this.backgroudColor,
      this.imageFile,
      this.fit,
      this.borderColor,
      this.borderWidth,
      this.schedule = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    var widget = Container(
      height: size?.height,
      width: size?.width,
      decoration: BoxDecoration(
          color: backgroudColor,
          borderRadius: BorderRadius.circular(cornerRadius ?? 0),
          border: Border.all(
              width: borderWidth ?? 0.0,
              color: borderColor ?? Colors.transparent)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius ?? 0),
        child: imageFile != null
            ? Image.file(
                imageFile!,
                width: imageSize?.width,
                height: imageSize?.height,
                fit: fit ?? BoxFit.fill,
              )
            : icon != null
                ? Icon(
                    icon,
                    size: iconSize,
                    color: color,
                  )
                : (imageURL == null
                    ? Image.asset(
                        imageName != null
                            ? 'asset/$imageName'
                            : "asset/placeholder-image.png",
                        height: imageSize?.height,
                        width: imageSize?.width,
                        fit: fit ?? BoxFit.fill,
                        color: color,
                      )
                    : getImageFromNet(imageURL)),
      ),
    );

    if (onTap != null) {
      return widget.inkWell(onTap: () {
        if (onTap != null) {
          onTap!();
        }
      });
    } else {
      return widget;
    }
  }

  Widget getImageFromNet(String? imageURL) {
    if (imageURL == null || imageURL.isEmpty) {
      return Image.asset(
        imageName != null ? "asset/$imageName" : "asset/placeholder-image.png",
        height: imageSize?.height,
        width: imageSize?.width,
        fit: fit ?? BoxFit.fill,
      );
    }

    if (schedule == true) {
      // return WebImage(
      //   url: imageURL,
      //   width: size?.width ?? 0,
      //   height: size?.height ?? 0,
      // );

      return CachedNetworkImage(
          imageUrl: imageURL,
          height: imageSize?.height,
          width: imageSize?.width,
          fit: fit ?? BoxFit.scaleDown,
          color: color,
          placeholder: (context, url) {
            return const CircularProgressIndicator(
              color: Colors.black,
            ).center().sizedBox(
                height: size?.height ?? 50, width: size?.height ?? 50);
          },
          errorWidget: (context, url, error) {
            debugPrint("Error loading image: $error\n$url");
            return Image.asset(
              imageName != null
                  ? "asset/$imageName"
                  : "asset/placeholder-image.png",
              height: imageSize?.height,
              width: imageSize?.width,
              fit: fit ?? BoxFit.scaleDown,
            );
          });
    } else {
      return Image.network(imageURL,
          height: imageSize?.height,
          width: imageSize?.width,
          fit: fit ?? BoxFit.fill,
          color: color, errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image.asset(
          imageName != null
              ? "asset/$imageName"
              : "asset/placeholder-image.png",
          height: imageSize?.height,
          width: imageSize?.width,
          fit: fit ?? BoxFit.fill,
        );
      }, loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const CircularProgressIndicator(
          color: Colors.black,
        )
            .center()
            .sizedBox(height: size?.height ?? 50, width: size?.height ?? 50);
      });
    }
  }
}
