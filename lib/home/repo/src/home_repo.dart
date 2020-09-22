import 'package:covid_tracing/home/repo/models/models.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeRepo {
  static final _rootRef = FirebaseDatabase.instance.reference();
  final _locationsRef = _rootRef.child('locations');
  final _casesRef = _rootRef.child('cases');

  Future<List<Location>> fetchLocations() async {
    final snapshot = await _locationsRef.once();
    var locations = <Location>[];

    for (MapEntry entry in snapshot.value.entries) {
      final data = Map<String, dynamic>.from(entry.value);
      data['postcode'] = entry.key;
      locations.add(Location.fromJson(data));
    }

    return locations;
  }

  Future<List<Case>> fetchCases([String postcode]) async {
    var query = _casesRef;
    if (postcode != null) {
      query = query.orderByChild('postcode').equalTo(postcode);
    }

    final snapshot = await query.once();
    var cases = <Case>[];

    for (MapEntry entry in snapshot.value.entries) {
      final data = Map<String, dynamic>.from(entry.value);
      cases.add(Case.fromJson(data));
    }

    return cases;
  }
}
