import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'WORKER_KEY', obfuscate: true)
  static final String workerKey = _Env.workerKey;
}
