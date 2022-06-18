import 'package:flutter/material.dart';
import 'package:readee/_core/widgets/standard_box_shadow.dart';
import 'package:transparent_image/transparent_image.dart';

class BookImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  final EdgeInsets? margin;

  const BookImage({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [StandardBoxShadow()],
      ),
      child: FadeInImage.memoryNetwork(
        height: height,
        width: width,
        placeholder: kTransparentImage,
        image: url,
        fit: BoxFit.cover,
      ),
    );
  }
}
