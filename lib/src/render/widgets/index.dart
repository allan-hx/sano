import 'package:flutter/widgets.dart';
import 'package:sano/src/render/index.dart';

import 'widget.dart';

final Map<String, Widget Function(SanoElement)> widgets = {
  'container': container,
  'text': text,
  'row': row,
  'column': column,
  'scaffold': scaffold,
};
