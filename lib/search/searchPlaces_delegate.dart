import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';

class SearchPlacesDelegate extends SearchDelegate {
  //TO DO: forma de tener function en constructor
  // Function onSearch;
  // SearchPlacesDelegate({required Function this.onSearch});

  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(
          Icons.place,
          color: Colors.black38,
          size: 100,
        ),
      ),
    );
  }

  @override
  String? get searchFieldLabel => 'Indique lugar del paseo';

  //  late Place place;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('data');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final geolocatorProvider = Provider.of<GeolocatorProvider>(context);

    return FutureBuilder(
      future: geolocatorProvider.searchListPlaces(query),
      builder: (_, AsyncSnapshot<List<PlaceSearch>> snapShot) {
        if (!snapShot.hasData) return _emptyContainer();

        final places = snapShot.data;

        return ListView.builder(
          itemCount: places!.length,
          itemBuilder: (_, index) =>
              _SuggestionItem(placeSearch: places[index]),
        );
      },
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  final PlaceSearch placeSearch;

  const _SuggestionItem({Key? key, required this.placeSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final geolocatorProvider = Provider.of<GeolocatorProvider>(context);

    return ListTile(
      selectedTileColor: Colors.amber,
      tileColor: Colors.deepPurple,
      leading: Icon(
        Icons.location_on,
        color: Colors.white,
      ),
      title: Text(
        placeSearch.description,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        geolocatorProvider.setSelectedPlace(placeSearch.placeId);
      },
    );
  }
}
