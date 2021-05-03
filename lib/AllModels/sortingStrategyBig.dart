import 'package:bikereats/AllModels/sortingStrategy.dart';
import 'package:sort/sort.dart';

class SortingStrategySmall implements SortingStrategy {
  @override
  sortRoutes(List<Map<String, dynamic>> routes) {
    return routes.quickSort(sortBy: 'distance');
  }
}