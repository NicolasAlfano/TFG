import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/widgets/widgets.dart';

class DogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: EdgeInsets.only(bottom: 15, top: 0),
        width: double.infinity,
        height: 60,
        decoration: _buttonDecoration(),
        child: _ButtonsRows(),
      ),
    );
  }

  BoxDecoration _buttonDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 7),
          ),
        ],
      );
}

class _ButtonsRows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, WalksScreen.routeName);
            },
            child: Text('Nuevo Paseo'),
          ),
          MaterialButton(
            onPressed: null,
            child: Text('Pasear'),
          ),
          MaterialButton(
            onPressed: null,
            child: Text('Link'),
          )
        ],
      ),
    );
  }
}
