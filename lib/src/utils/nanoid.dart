import 'dart:math';

const urlAlphabet =
    'useandom-26T198340PX75pxJACKVERYMINDBUSHWOLF_GQZbfghjklqvwyzrict';

/*
const urlAlphabet =
    'useandom26T198340PX75pxJACKVERYMINDBUSHWOLFGQZbfghjklqvwyzrict';
*/

final _random = Random.secure();

String nanoid([int size = 21]) {
  return customAlphabet(urlAlphabet, size);
}

String customAlphabet(String alphabet, int size) {
  final len = alphabet.length;
  String id = '';
  while (0 < size--) {
    id += alphabet[_random.nextInt(len)];
  }
  return id;
}
