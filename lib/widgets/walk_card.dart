import 'package:flutter/material.dart';
import 'package:productos_app/models/petService.dart';
import 'package:productos_app/screens/screens.dart';

class WalkCard extends StatelessWidget {
  const WalkCard({Key? key, required this.petService}) : super(key: key);

  final PetService petService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 10),
        width: double.infinity,
        height: 170,
        decoration: _cardBorders(),
        child: Column(
          // alignment: Alignment.bottomRight,
          children: [
            _Detail(
              petService: petService,
            ),
            _ButtonsRows()
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 7),
          ),
        ],
      );
}

class _Detail extends StatelessWidget {
  final PetService petService;

  const _Detail({Key? key, required this.petService}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Container(
              color: Colors.amber,
              width: 225,
              height: 100,
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 400,
                    height: 10,
                  ),
                  Text(
                    petService.description(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    petService.typologyAndRideType(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.red,
              alignment: Alignment.topRight,
              width: 75,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 400,
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '3',
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(petService.daysDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text(petService.hoursDescription(),
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonsRows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      margin: EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, TrackingMapScreen.routeName);
            },
            child: Text('Iniciar Paseo'),
          ),
          MaterialButton(
            onPressed: null,
            child: Text('Ver'),
          )
        ],
      ),
    );
  }
}
