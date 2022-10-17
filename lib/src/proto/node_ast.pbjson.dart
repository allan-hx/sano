///
//  Generated code. Do not modify.
//  source: node_ast.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use attrDescriptor instead')
const Attr$json = const {
  '1': 'Attr',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `Attr`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attrDescriptor = $convert.base64Decode('CgRBdHRyEhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZQ==');
@$core.Deprecated('Use nodeAstDescriptor instead')
const NodeAst$json = const {
  '1': 'NodeAst',
  '2': const [
    const {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
    const {'1': 'isStatic', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'isStatic', '17': true},
    const {'1': 'attrs', '3': 3, '4': 3, '5': 11, '6': '.node_ast.Attr', '10': 'attrs'},
    const {'1': 'events', '3': 4, '4': 3, '5': 9, '10': 'events'},
    const {'1': 'children', '3': 5, '4': 3, '5': 11, '6': '.node_ast.NodeAst', '10': 'children'},
  ],
  '8': const [
    const {'1': '_isStatic'},
  ],
};

/// Descriptor for `NodeAst`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodeAstDescriptor = $convert.base64Decode('CgdOb2RlQXN0EhAKA3RhZxgBIAEoCVIDdGFnEh8KCGlzU3RhdGljGAIgASgISABSCGlzU3RhdGljiAEBEiQKBWF0dHJzGAMgAygLMg4ubm9kZV9hc3QuQXR0clIFYXR0cnMSFgoGZXZlbnRzGAQgAygJUgZldmVudHMSLQoIY2hpbGRyZW4YBSADKAsyES5ub2RlX2FzdC5Ob2RlQXN0UghjaGlsZHJlbkILCglfaXNTdGF0aWM=');
