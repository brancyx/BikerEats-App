import 'package:bikereats/AllModels/routeDetails.dart';

/// Parent class for sorting strategies. Responsible for sorting [RouteDetails].
abstract class SortingStrategy {
  /// Sorts routes from shortest to longest distance
  sortRoutes(List<Map<String, dynamic>> routes);
}