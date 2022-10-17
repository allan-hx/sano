import 'package:sano/src/proto/node_ast.pb.dart';

final ast = {
  "tag": "container",
  "children": [
    {
      "tag": "column",
      "children": [
        {
          "tag": "container",
          "attrs": {
            "class": "list"
          },
          "children": [
            {
              "tag": "list-view",
              "children": [
                {
                  "tag": "container",
                  "attrs": {
                    "class": "item",
                    "sn:for": "list"
                  },
                  "children": [
                    {
                      "tag": "text",
                      "attrs": {
                        "text": "{{index}} -- {{item}}"
                      },
                    },
                  ]
                },
              ]
            },
          ]
        },
      ]
    },
  ]
};

NodeAst from(Map data) {
  final NodeAst node = NodeAst.create();

  node.tag = data['tag'] as String;

  if (data['attribs'] != null) {
    for (var key in (data['attribs'] as Map).keys) {
      final Attr attrib = Attr.create();
      attrib.key = key;
      attrib.value = data['attribs'][key] as String;
      node.attrs.add(attrib);
    }
  }

  if (data['children'] != null) {
    for (Map item in (data['children'] as List)) {
      node.children.add(from(item));
    }
  }

  return node;
}

void test() {
  final node = from(ast);
  print(node.writeToBuffer());
}
