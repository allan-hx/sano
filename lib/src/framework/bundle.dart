import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// 解压参数
class UnpackParams {
  // 文件地址
  final String file;
  // 解压路径
  final String path;

  const UnpackParams(this.file, this.path);
}

abstract class Bundle {
  Bundle({
    required this.url,
    required this.version,
  });

  // 资源地址
  final String url;
  // 版本号
  final String version;

  // 资源目录
  late String _assetsPath;
  String get assetsPath => _assetsPath;

  // 加载资源
  @mustCallSuper
  Future<void> resolve() async {
    final appDirectory = (await getApplicationSupportDirectory()).path;
    // 资源目录
    _assetsPath = path.join(appDirectory, 'sano', version);
  }

  // 新开线程解压
  static Future<void> _zipDecoder(UnpackParams params) async {
    try {
      final bytes = await File(params.file).readAsBytes();
      final Archive archive = ZipDecoder().decodeBytes(bytes);

      for (final ArchiveFile item in archive) {
        final filename = path.join(params.path, item.name);

        // 文件直接创建
        if (item.isFile) {
          final List<int> data = item.content as List<int>;
          final File file = File(filename);

          await file.create(recursive: true);
          await file.writeAsBytes(data);
        } else {
          final Directory dir = Directory(filename);
          await dir.create(recursive: true);
        }
      }
    } catch (_) {
      // 删除目录
      Directory(params.path).delete();
      rethrow;
    }
  }

  // 解压资源
  Future<void> zipDecoder(UnpackParams params) async {
    try {
      await compute(_zipDecoder, params);
    } catch (error) {
      throw 'Bundle解压失败: $error';
    }
  }

  // 查询资源是否存在
  Future<bool> isExist(String filePath) async {
    final file = File(path.join(_assetsPath, filePath));
    return file.exists();
  }

  // 获取文件路径
  String getAssetsPath(String name) {
    // 判断是否存在斜杠开头
    if (name.indexOf('/') == 0) {
      name = name.substring(1);
    }

    return path.join(_assetsPath, name);
  }

  // 获取文件
  File getAssetsFile(String filePath) => File(getAssetsPath(filePath));

  // 异步加载文件
  Future<String> read(String filePath) async {
    final file = File(getAssetsPath(filePath));
    return await file.readAsString();
  }

  // 读取json
  Future<Map?> readJson(String filePath) async {
    if (await isExist(filePath)) {
      final source = await read(filePath);
      return jsonDecode(source);
    }

    return null;
  }

  // 读取二进制
  Future<Uint8List> readAsBytes(String filePath) {
    final file = File(getAssetsPath(filePath));
    return file.readAsBytes();
  }
}

class NetworkBundle extends Bundle {
  NetworkBundle({required super.url, required super.version});

  // 下载
  Future<void> _download(String savePath) async {
    try {
      // 下载
      await Dio(BaseOptions(
        connectTimeout: 5000,
      )).download(
        url,
        savePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
    } catch (_) {
      throw 'sano/bundle: Bundle下载错误';
    }
  }

  @override
  Future<void> resolve() async {
    await super.resolve();
    // 缓存目录
    final cachedirectory = (await getTemporaryDirectory()).path;
    // 判断本地资源是否存在
    final bool isExists =
        kDebugMode ? false : await Directory(_assetsPath).exists();

    if (isExists) {
      return;
    } else {
      await Directory(_assetsPath).create(recursive: true);
    }

    // 文件后缀名
    final extension = path.extension(url);
    // 保存路径
    final savePath = path.join(cachedirectory, '$version$extension');

    // 下载
    await _download(savePath);

    // 判断是否是js文件 - js则移动文件
    if (extension == '.js') {
      final file = File(savePath);
      await file.rename(path.join(_assetsPath, 'main.js'));
      return;
    }

    // 解压
    await zipDecoder(UnpackParams(savePath, _assetsPath));
  }
}

class AssetBundle extends Bundle {
  AssetBundle({required super.url, required super.version});

  @override
  Future<void> resolve() async {
    await super.resolve();
    // 判断本地资源是否存在
    final bool isExists =
        kDebugMode ? false : await Directory(_assetsPath).exists();

    if (!isExists) {
      final extension = path.extension(url);

      // 判断是否是js文件 - js则移动文件
      if (extension == '.js') {
        final file = File(url);
        await file.rename(path.join(_assetsPath, 'main.js'));
        return;
      }

      // 解压
      await zipDecoder(UnpackParams(url, _assetsPath));
    }
  }
}
