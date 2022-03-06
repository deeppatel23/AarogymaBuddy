import 'package:translator/translator.dart';

Future<String> translate(String input, String ipLang, String opLang) async {
  if (input == "") return "";
  GoogleTranslator translator = GoogleTranslator();
  var translation = await translator.translate(input, from: ipLang, to: opLang);
  return translation.text;
}
