import 'package:flutter/material.dart';
import 'package:sano/src/render/index.dart';

Scaffold scaffold(SanoElement element) {
  element = element as ScaffoldElement;

  return Scaffold(
    body: element.children?.last,
    floatingActionButton: element.floatingActionButton,
  );
}

Container container(SanoElement element) {
  final props = element.props;

  return Container(
    alignment: Parse.alignment(props['alignment'] as String?),
    padding: Parse.edgeInsets(props['padding'] as Map?),
    color: Parse.color(props['color'] as String?),
    decoration: Parse.boxDecoration(props['decoration'] as Map?),
    foregroundDecoration:
        Parse.boxDecoration(props['foreground-decoration'] as Map?),
    width: Parse.toDouble(props['width']?.toString()),
    height: Parse.toDouble(props['height']?.toString()),
    // constraints
    margin: Parse.edgeInsets(props['margin'] as Map?),
    // transform
    clipBehavior: Parse.clip(props['clip-behavior'] as String?) ?? Clip.none,
    child: element.children?.last,
  );
}

Text text(SanoElement element) {
  final props = element.props;

  return Text(
    props['text'] as String? ?? '',
    style: Parse.textStyle(props['style'] as Map?),
    textAlign: Parse.textAlign(props['text-align'] as String?),
    textDirection: Parse.textDirection(props['text-direction'] as String?),
    overflow: Parse.overflow(props['overflow'] as String?),
    textScaleFactor: Parse.toDouble(props['text-scale-factor']?.toString()),
    maxLines: Parse.toInt(props['max-lines']?.toString()),
    semanticsLabel: props['semantics-label'] as String?,
    textWidthBasis: Parse.textWidthBasis(props['text-width-basis'] as String?),
  );
}

Row row(SanoElement element) {
  final props = element.props;

  return Row(
    mainAxisAlignment:
        Parse.mainAxisAlignment(props['main-axis-alignment'] as String?),
    crossAxisAlignment:
        Parse.crossAxisAlignment(props['cross-axis-alignment'] as String?),
    mainAxisSize: Parse.mainAxisSize(props['main-axis-size'] as String?),
    textDirection: Parse.textDirection(props['text-direction'] as String?),
    verticalDirection:
        Parse.verticalDirection(props['vertical-direction'] as String?),
    textBaseline: Parse.textBaseline(props['text-baseline'] as String?),
    children: element.children ?? [],
  );
}

Column column(SanoElement element) {
  final props = element.props;

  return Column(
    mainAxisAlignment:
        Parse.mainAxisAlignment(props['main-axis-alignment'] as String?),
    crossAxisAlignment:
        Parse.crossAxisAlignment(props['cross-axis-alignment'] as String?),
    mainAxisSize: Parse.mainAxisSize(props['main-axis-size'] as String?),
    textDirection: Parse.textDirection(props['text-direction'] as String?),
    verticalDirection:
        Parse.verticalDirection(props['vertical-direction'] as String?),
    textBaseline: Parse.textBaseline(props['text-baseline'] as String?),
    children: element.children ?? [],
  );
}
