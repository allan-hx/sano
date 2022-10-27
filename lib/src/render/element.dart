import 'package:flutter/material.dart';
import 'package:sano/src/framework/index.dart';
import 'package:sano/src/render/widgets/index.dart';

typedef UpdateHandler = void Function(Map);

// 创建节点
SanoElement createNodeElement(Map renderObject, SanoElement parent) {
  switch (renderObject['tag'] as String) {
    case 'scaffold':
      return ScaffoldElement(renderObject, parent);
    default:
      return SanoElement(renderObject, parent);
  }
}

class ElementNotifier extends ValueNotifier {
  ElementNotifier(this.element, super.value) {
    Future(() {
      element.root.on(element.id, element.update);
    });
  }

  final SanoElement element;

  @override
  void removeListener(VoidCallback listener) {
    element.root.off(element.id);
    super.removeListener(listener);
  }
}

class SanoElement {
  SanoElement(Map renderObject, this.parent)
      : id = renderObject['id'] as String,
        tag = renderObject['tag'] as String,
        props = renderObject['props'] as Map? ?? {},
        events = (renderObject['events'] as List?)
            ?.map((item) => item as String)
            .toList() {
    _children = (renderObject['children'] as List?)
        ?.map((item) => item as Map)
        .map((item) => createNodeElement(item, this).widget)
        .toList();
    _notifier = ElementNotifier(this, 1);
  }

  // 节点id
  final String id;
  // 标签
  final String tag;
  // 属性
  final Map props;
  // 事件
  final List<String>? events;
  // 父节点
  final SanoElement? parent;
  // 监听器
  late ElementNotifier _notifier;

  // 根节点
  RootElement get root => parent!.root;

  // 子节点
  List<Widget>? _children = [];
  List<Widget>? get children => _children;

  // 更新节点
  void update(Map renderObject) {
    for (String key in renderObject.keys) {
      switch (key) {
        case 'children':
          // 更新子节点
          _children = (renderObject['children'] as List)
              .map((item) => createNodeElement(item as Map, this).widget)
              .toList();
          break;
        case 'props':
          props.addAll(renderObject['props'] as Map);
          break;
      }
    }

    _notifier.value = DateTime.now().millisecondsSinceEpoch;
  }

  // 构建widget
  Widget get widget {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (BuildContext context, _, Widget? child) {
        final builder = widgets[tag];

        if (builder == null) {
          return Center(
            child: Text('$tag:未注册'),
          );
        }

        return builder(this);
      },
    );
  }
}

// 根节点
class RootElement extends SanoElement {
  RootElement(Map children, this.channel)
      : super({
          'id': channel.name,
          'tag': 'root',
          'children': [children],
        }, null);

  final Map<String, UpdateHandler> _listeners = {};

  @override
  RootElement get root => this;

  // 通道
  final Channel channel;

  @override
  Widget get widget => children!.last;

  // 监听
  void on(String id, UpdateHandler listener) {
    _listeners[id] = listener;
  }

  // 移除
  void off(String id) {
    if (_listeners.containsKey(id)) {
      _listeners.remove(id);
    }
  }

  // 通知更新子节点
  void emit(String id, Map renderObject) {
    if (_listeners.containsKey(id)) {
      _listeners[id]!(renderObject);
    }
  }
}

// 插槽节点
abstract class SlotElement extends SanoElement {
  SlotElement(Map renderObject, SanoElement parent)
      : super(renderObject, parent) {
    initSlots(renderObject);
  }

  // 初始化插槽
  void initSlots(Map renderObject) {
    for (String key in slots.keys) {
      if (renderObject.containsKey(key)) {
        final element = SlotFragment(renderObject[key], this);
        slots[key]!(element);
      }
    }
  }

  // 插槽
  Map<String, void Function(SanoElement)> get slots;
}

// 插槽容器节点 - 不参与实际节点的更新
class SlotFragment extends SanoElement {
  SlotFragment(super.renderObject, super.parent);

  @override
  void update(Map renderObject) {
    _children = (renderObject['children'] as List)
        .map((item) => createNodeElement(item as Map, this).widget)
        .toList();

    if (parent is SlotElement) {
      final slots = (parent as SlotElement).slots;

      if (slots.containsKey(tag)) {
        slots[tag]!(this);
      }

      // 更新父节点
      parent!._notifier.value = DateTime.now().millisecondsSinceEpoch;
    }
  }
}

// Scaffold节点
class ScaffoldElement extends SlotElement {
  ScaffoldElement(Map renderObject, SanoElement parent)
      : super(renderObject, parent);

  @override
  Map<String, void Function(SanoElement)> get slots {
    return {
      'floating-action-button-fragment': _floatingActionButtonBuilder,
    };
  }

  // 构建悬浮按钮
  void _floatingActionButtonBuilder(SanoElement element) {
    _floatingActionButton = element.children?[0];
  }

  // 悬浮按钮
  Widget? _floatingActionButton;
  Widget? get floatingActionButton => _floatingActionButton;
}

// // AppBar节点
// class AppBarElement extends SlotElement {
//   AppBarElement(Map renderObject, SanoElement parent)
//       : super(renderObject, parent);

//   _leadingBuilder(List slots) {
//     _leading = createNodeElement(slots[0], this).widget;
//   }

//   _actionsBuilder(List slots) {
//     _actions = slots
//         .map((item) => createNodeElement(item as Map, this).widget)
//         .toList();
//   }

//   @override
//   Map<String, void Function(List)> get slots {
//     return {
//       'leading': _leadingBuilder,
//       'actions': _actionsBuilder,
//     };
//   }

//   // 左边内容
//   Widget? _leading;
//   Widget? get leading => _leading;

//   // 右边内容
//   List<Widget>? _actions;
//   List<Widget>? get actions => _actions;

//   // 悬浮内容
//   Widget? _flexibleSpace;
//   Widget? get flexibleSpace => _flexibleSpace;

//   // 底部内容
//   Widget? _bottom;
//   Widget? get bottom => _bottom;
// }
