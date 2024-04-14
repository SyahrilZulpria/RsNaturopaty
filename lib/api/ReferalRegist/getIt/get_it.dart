import 'package:get_it/get_it.dart';
import 'package:rsnaturopaty/api/ReferalRegist/service/service_api.dart';

void setUpGetIt() {
  GetIt.I.registerSingleton<DynamicLinksApi>(DynamicLinksApi());
}
