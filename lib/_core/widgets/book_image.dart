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
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [StandardBoxShadow()],
      ),
      child: FadeInImage.memoryNetwork(
        height: height,
        width: width,
        placeholder: kTransparentImage,
        image: //TODO IMAGE
            "https://kbimages1-a.akamaihd.net/fdcc4f79-59c4-4147-b750-6f2510096f69/1200/1200/False/nevernight-the-nevernight-chronicle-book-1.jpg",
        fit: BoxFit.cover,
      ),
    );
  }
}
