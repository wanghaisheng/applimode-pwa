import 'package:applimode_app/src/utils/remote_config_service.dart';

MainCategory checkCategory(List<MainCategory> categoryList, int category) {
  return category > categoryList.length - 1
      ? categoryList[0]
      : categoryList[category];
}
