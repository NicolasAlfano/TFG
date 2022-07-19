import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../services/services.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  final PetService service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 10),
        width: 400,
        height: 530,
        decoration: _cardBorders(),
        child: Column(
          // alignment: Alignment.bottomRight,
          children: [
            _Image(),
            _Detail(
              service: service,
            ),
            SizedBox(height: 15),
            _ButtonsRows(petId: service.idPet),
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
  const _Detail({
    Key? key,
    required this.service,
  }) : super(key: key);

  List<Icon> buildStars(double count, double qCount) {
    List<Icon> lista = [];
    for (var i = 0; i < count; i++) {
      lista.add(Icon(
        Icons.star_rate,
        color: Colors.amberAccent,
      ));
    }

    for (var i = 0; i < qCount; i++) {
      lista.add(Icon(
        Icons.star_rate,
        color: Colors.grey,
      ));
    }
    return lista;
  }

  final PetService service;
  @override
  Widget build(BuildContext context) {
    var count = service.qualification;
    var qCount = 5 - service.qualification;
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            service.nameWalker!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Row(
                children: buildStars(count, qCount),
              ),
              SizedBox(
                width: 5,
              ),
              Text(service.qualification.toString()),
              Text('(454)'),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(service.description(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.black54)),
          SizedBox(
            height: 5,
          ),
          Text(service.daysDescription,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.black54)),
          SizedBox(
            height: 5,
          ),
          Text(service.typologyAndRideType(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage('https://via.placeholder.com/400x300/f6f6f6'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ButtonsRows extends StatelessWidget {
  const _ButtonsRows({
    Key? key,
    required this.petId,
  }) : super(key: key);

  final String petId;
  @override
  Widget build(BuildContext context) {
    final walkService = Provider.of<WalkService>(context, listen: false);

    return Container(
      height: 50,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: () async {
              final walk = Walk(state: "I");
              await walkService.saveWalk(walk, petId);
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
            child: Text(
              'Contratar',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
