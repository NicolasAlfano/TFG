// To parse this JSON data, do
//
//     final placeSearch = placeSearchFromMap(jsonString);

class PlaceSearch {
  PlaceSearch({
    required this.placeId,
    required this.description,
  });

  String placeId;
  String description;

  factory PlaceSearch.fromMap(Map<String, dynamic> json) => PlaceSearch(
        placeId: json["place_id"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "place_id": placeId,
        "description": description,
      };
}
