import 'package:flutter/material.dart';

abstract class NodeElement {
  NodeElement(this.tag);

  final String tag;

  Widget build(BuildContext context, CSSElement style);
}

class CSSElement {
  CSSElement();
}

class DIV extends NodeElement {
  DIV(): super('div');

  @override
  Widget build(BuildContext context, CSSElement style) {
    return Container();
  }
}

class P extends NodeElement {
  P(): super('p');

  @override
  Widget build(BuildContext context, CSSElement style) {
    return Container();
  }
}

class IMG extends NodeElement {
  IMG(): super('img');

  @override
  Widget build(BuildContext context, CSSElement style) {
    return Container();
  }
}
