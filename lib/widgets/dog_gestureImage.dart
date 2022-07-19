import 'dart:io';

import 'package:flutter/material.dart';

import 'package:productos_app/models/models.dart';

class GestureImage extends StatelessWidget {
  final Pet pet;

  const GestureImage({
    Key? key,
    required this.pet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: EdgeInsets.only(top: 15, bottom: 0),
        width: double.infinity,
        height: 250,
        decoration: _cardBorders(),
        // child: _TitleAndImage(name: pet.name, image: pet.photo),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            _BackgroundImage(image: pet.photo),
            _DogName(name: pet.name),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      );
}

class _DogName extends StatelessWidget {
  final String name;

  const _DogName({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 230),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 50,
        child: FittedBox(
            fit: BoxFit.contain,
            child: Text(name,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                maxLines: 1)),
        decoration: _buildBoxDecoration(),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(15), bottomLeft: Radius.circular(15)));
}

class _BackgroundImage extends StatelessWidget {
  final String image;

  const _BackgroundImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      child: Container(
        width: double.infinity,
        height: 250,
        child: getImage(this.image),
        // : AssetImage(this.image),
      ),
    );
  }

  Widget getImage(String? picture) {
    if (picture == null || picture == "")
      return Image(
        image: AssetImage('assets/without_pic.jpg'),
        fit: BoxFit.cover,
      );

    if (picture.startsWith('http'))
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(picture),
        fit: BoxFit.cover,
      );

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

class _TitleAndImage extends StatelessWidget {
  final String name;
  final String image;

  const _TitleAndImage({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: 160,
            height: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(this.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'La perra mas odiada del mundo la lslss lsl sls sllsls s La perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls sLa perra mas odiada del mundo la lslss lsl sls sllsls s',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          FadeInImage(
            width: 130,
            height: 130,
            placeholder: AssetImage('assets/jar-loading.gif'),
            // image: NetworkImage('https://via.placeholder.com/120x120/f6f6f6'),
            image: this.image == null || this.image == ""
                ? AssetImage('assets/whithout_pic.jpg')
                : AssetImage(this.image),
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
