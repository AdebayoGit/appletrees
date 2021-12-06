import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';

class ItemImage extends StatelessWidget {
  final String? imgSrc;
  const ItemImage({
    Key? key,
    this.imgSrc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CachedNetworkImage(
      width: double.infinity,
      height: size.height * 0.4,
      imageUrl: imgSrc!,
      // Display when there is an error such as 404, 500 etc.
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fadeInCurve: Curves.easeIn ,
      fadeInDuration: const Duration(milliseconds:1000),
      fadeOutCurve: Curves.easeOut,
      fadeOutDuration: const Duration(milliseconds:500),
      imageBuilder: (context, imageProvider) => Container(
        color: Colors.orange,
        child: Image(
          fit: BoxFit.fill,
            image: imageProvider,
        ),
      ),
      //display while fetching image.
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
    );
  }
}
