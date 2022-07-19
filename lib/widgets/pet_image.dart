import 'dart:io';

import 'package:flutter/material.dart';

class PetImage extends StatelessWidget {
  final String? url;

  const PetImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
        child: Container(
          decoration: _buildBoxDecoration,
          width: double.infinity,
          height: 450,
          child: Opacity(
            opacity: 0.9,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: getImage(url),
            ),
          ),
        ));
  }

  BoxDecoration get _buildBoxDecoration => BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ]);

  Widget getImage(String? picture) {
    if (picture == null || picture == "")
      return Image(
        image: AssetImage('assets/without_pic.jpg'),
        fit: BoxFit.cover,
      );

    if (picture.startsWith('http')) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(picture),
        fit: BoxFit.cover,
      );
    }

    // if (picture.endsWith('.jpg') || picture.endsWith('.png') ) {
    //   return FadeInImage(
    //     placeholder: AssetImage('assets/jar-loading.gif'),
    //     image: AssetImage(this.url.toString()),
    //     fit: BoxFit.cover,
    //   );
    // }

    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}
