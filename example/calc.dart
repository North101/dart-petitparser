/// Calculator from the tutorial.
import 'dart:io';
import 'dart:math';

import 'package:petitparser/petitparser.dart';

Parser buildParser() {
  final builder = ExpressionBuilder();
  builder.group()
    ..primitive((pattern('+-').optional() &
            digit().plus() &
            (char('.') & digit().plus()).optional() &
            (pattern('eE') & pattern('+-').optional() & digit().plus())
                .optional())
        .flatten('number expected')
        .trim()
        .map(num.tryParse))
    ..wrapper(
        char('(').trim(), char(')').trim(), (left, value, right) => value);
  builder.group().prefix(char('-').trim(), (op, num a) => -a);
  builder.group().right(char('^').trim(), (num a, op, num b) => pow(a, b));
  builder.group()
    ..left(char('*').trim(), (num a, op, num b) => a * b)
    ..left(char('/').trim(), (num a, op, num b) => a / b);
  builder.group()
    ..left(char('+').trim(), (num a, op, num b) => a + b)
    ..left(char('-').trim(), (num a, op, num b) => a - b);
  return builder.build().end();
}

void main(List<String> arguments) {
  final parser = buildParser();
  final input = arguments.join(' ');
  final result = parser.parse(input);
  if (result.isSuccess) {
    stdout.writeln(' = ${result.value}');
  } else {
    stderr.writeln(input);
    stderr.writeln('${' ' * (result.position - 1)}^-- ${result.message}');
    exit(1);
  }
}
