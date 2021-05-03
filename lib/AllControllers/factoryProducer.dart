import 'package:bikereats/AllControllers/abstractFactory.dart';
import 'package:bikereats/AllControllers/bicycleRackFactory.dart';

class FactoryProducer {

  AbstractFactory getFactory(String factoryType) {
    if (factoryType == "bicycle") {
      return new BicycleRackFactory();
    }
    else {
      return null;
    }
  }
}