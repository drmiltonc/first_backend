// ignore_for_file: public_member_api_docs, non_constant_identifier_names

import 'package:envied/envied.dart';

part 'envs.g.dart';

@Envied()
final class Env {
  @EnviedField()
  static String GEMINI_API_KEY = _Env.GEMINI_API_KEY;
}
