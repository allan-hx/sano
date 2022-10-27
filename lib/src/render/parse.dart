import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Parse {
  Parse._();

  static double? toDouble(String? value) {
    if (value == null) {
      return null;
    }

    if (value == 'infinity') {
      return double.infinity;
    }

    return double.parse(value);
  }

  static int? toInt(String? value) {
    if (value == null) {
      return null;
    }

    return int.parse(value.toString());
  }

  static Color? color(String? value) {
    if (value != null) {
      try {
        return Color(int.parse('0xFF$value'));
      } catch (_) {}
    }

    return null;
  }

  static Alignment? alignment(String? alignment) {
    switch (alignment) {
      case 'top-left':
        return Alignment.topLeft;
      case 'top-center':
        return Alignment.topCenter;
      case 'top-right':
        return Alignment.topRight;
      case 'bottom-left':
        return Alignment.bottomLeft;
      case 'bottom-center':
        return Alignment.bottomCenter;
      case 'bottom-right':
        return Alignment.bottomRight;
      case 'center-left':
        return Alignment.centerLeft;
      case 'center':
        return Alignment.center;
      case 'center-right':
        return Alignment.centerRight;
      default:
        return null;
    }
  }

  static EdgeInsets? edgeInsets(Map? value) {
    if (value == null) {
      return null;
    }

    if (value.containsKey('all')) {
      return EdgeInsets.all(toDouble(value['all']?.toString()) ?? 0);
    } else if (value.containsKey('vertical') ||
        value.containsKey('horizontal')) {
      return EdgeInsets.symmetric(
        vertical: toDouble(value['vertical']?.toString()) ?? 0,
        horizontal: toDouble(value['horizontal']?.toString()) ?? 0,
      );
    }

    return EdgeInsets.only(
      top: toDouble(value['top']?.toString()) ?? 0,
      right: toDouble(value['right']?.toString()) ?? 0,
      bottom: toDouble(value['bottom']?.toString()) ?? 0,
      left: toDouble(value['left']?.toString()) ?? 0,
    );
  }

  static Clip? clip(String? value) {
    switch (value) {
      case 'antiAlias':
        return Clip.antiAlias;
      case 'antiAliasWithSaveLayer':
        return Clip.antiAliasWithSaveLayer;
      case 'hardEdge':
        return Clip.hardEdge;
      default:
        return null;
    }
  }

  static BoxDecoration? boxDecoration(Map? value) {
    if (value == null) {
      return null;
    }

    return BoxDecoration(
      color: color(value['color'] as String?),
      image: decorationImage(value['image'] as Map?),
      border: border(value['border'] as Map?),
      borderRadius: borderRadius(value['border-radius'] as Map?),
      // boxShadow:
      // gradient
      shape: boxShape(value['shape'] as String?),
    );
  }

  static DecorationImage? decorationImage(Map? value) {
    final image = value?['image'] as String?;

    if (value != null) {
      if (image != null) {
        return DecorationImage(
          image: imageProvider(image),
          fit: boxFit(value['fit']),
          alignment:
              alignment(value['alignment'] as String?) ?? Alignment.center,
          repeat: imageRepeat(value['repeat'] as String?),
          matchTextDirection: value['match-text-direction'] as bool? ?? false,
          scale: toDouble(value['scale']?.toString()) ?? 1.0,
          opacity: toDouble(value['opacity']?.toString()) ?? 1.0,
          filterQuality: filterQuality(value['filter-quality'] as String?) ??
              FilterQuality.low,
          invertColors: value['invert-colors'] as bool? ?? false,
          isAntiAlias: value['is-anti-alias'] as bool? ?? false,
        );
      }
    }

    return null;
  }

  static BoxFit? boxFit(String? fit) {
    switch (fit) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fit-width':
        return BoxFit.fitWidth;
      case 'fit-height':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scale-down':
        return BoxFit.scaleDown;
      default:
        return null;
    }
  }

  static ImageProvider imageProvider(
    String image, {
    bool? cache = false,
    String? key,
  }) {
    final list = image.split('://');
    final protocol = list[0];
    final url = list[1];

    switch (protocol) {
      case 'http':
      case 'https':
        if (cache == true) {
          return CachedNetworkImageProvider(image);
        }

        return NetworkImage(image);
      case 'assets':
        return AssetImage(url);
      default:
        return FileImage(File(url));
    }
  }

  static BoxShape boxShape(String? value) {
    switch (value) {
      case 'rectangle':
        return BoxShape.circle;
      default:
        return BoxShape.rectangle;
    }
  }

  static ImageRepeat imageRepeat(String? value) {
    switch (value) {
      case 'repeat':
        return ImageRepeat.repeat;
      case 'repeat-y':
        return ImageRepeat.repeatY;
      case 'repeat-x':
        return ImageRepeat.repeatX;
      default:
        return ImageRepeat.noRepeat;
    }
  }

  static FilterQuality? filterQuality(String? value) {
    switch (value) {
      case 'high':
        return FilterQuality.high;
      case 'low':
        return FilterQuality.low;
      case 'medium':
        return FilterQuality.medium;
      default:
        return null;
    }
  }

  static BoxBorder? border(Map? value) {
    if (value == null) {
      return null;
    }

    if (value.containsKey('all')) {
      final data = value['all'] as Map;

      return Border.all(
        width: toDouble(data['width']?.toString()) ?? 1.0,
        color: color(data['color'] as String?) ?? const Color(0xFF000000),
        style: borderStyle(data['style'] as String?),
      );
    }

    return Border(
      top: borderSide(value['top'] as Map?),
      right: borderSide(value['right'] as Map?),
      bottom: borderSide(value['bottom'] as Map?),
      left: borderSide(value['left'] as Map?),
    );
  }

  static BorderStyle borderStyle(String? value) {
    switch (value) {
      case 'none':
        return BorderStyle.none;
      default:
        return BorderStyle.solid;
    }
  }

  static BorderSide borderSide(Map? value) {
    if (value == null) {
      return BorderSide.none;
    }

    return BorderSide(
      width: toDouble(value['width']?.toString()) ?? 1.0,
      color: color(value['color'] as String?) ?? const Color(0xFF000000),
      style: borderStyle(value['style'] as String?),
    );
  }

  static BorderRadiusGeometry? borderRadius(Map? value) {
    if (value == null) {
      return null;
    }

    if (value.containsKey('all')) {
      return BorderRadius.circular(toDouble(value['all']?.toString()) ?? 0);
    }

    return BorderRadius.only(
      topLeft: value.containsKey('top-left')
          ? Radius.circular(toDouble(value['top-left']?.toString()) ?? 0)
          : Radius.zero,
      topRight: value.containsKey('top-right')
          ? Radius.circular(toDouble(value['top-right']?.toString()) ?? 0)
          : Radius.zero,
      bottomLeft: value.containsKey('bottom-left')
          ? Radius.circular(toDouble(value['bottom-left']?.toString()) ?? 0)
          : Radius.zero,
      bottomRight: value.containsKey('bottom-right')
          ? Radius.circular(toDouble(value['bottom-right']?.toString()) ?? 0)
          : Radius.zero,
    );
  }

  static MainAxisAlignment mainAxisAlignment(String? value) {
    switch (value) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'space-between':
        return MainAxisAlignment.spaceBetween;
      case 'space-around':
        return MainAxisAlignment.spaceAround;
      case 'space-evenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment crossAxisAlignment(String? value) {
    switch (value) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      default:
        return CrossAxisAlignment.center;
    }
  }

  static MainAxisSize mainAxisSize(String? value) {
    switch (value) {
      case 'min':
        return MainAxisSize.min;
      default:
        return MainAxisSize.max;
    }
  }

  static TextDirection? textDirection(String? value) {
    switch (value) {
      case 'rtl':
        return TextDirection.rtl;
      case 'ltr':
        return TextDirection.ltr;
      default:
        return null;
    }
  }

  static VerticalDirection verticalDirection(String? value) {
    switch (value) {
      case 'up':
        return VerticalDirection.up;
      default:
        return VerticalDirection.down;
    }
  }

  static TextBaseline? textBaseline(String? value) {
    switch (value) {
      case 'alphabetic':
        return TextBaseline.alphabetic;
      case 'ideographic':
        return TextBaseline.ideographic;
      default:
        return null;
    }
  }

  static TextAlign? textAlign(String? value) {
    switch (value) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'end':
        return TextAlign.end;
      default:
        return null;
    }
  }

  static TextStyle? textStyle(Map? value) {
    if (value == null) {
      return null;
    }

    return TextStyle(
      inherit: value['inherit'] as bool? ?? true,
      color: color(value['color'] as String?),
      backgroundColor: color(value['background-color'] as String?),
      fontSize: toDouble(value['font-size']?.toString()),
      fontWeight: fontWeight(value['font-weight']?.toString()),
      fontStyle: fontStyle(value['font-style'] as String?),
      letterSpacing: toDouble(value['letter-spacing']?.toString()),
      wordSpacing: toDouble(value['word-spacing']?.toString()),
      textBaseline: textBaseline(value['text-baseline'] as String?),
      height: toDouble(value['line-height']?.toString()),
      leadingDistribution:
          textLeadingDistribution(value['leading-distribution'] as String?),
      // shadows
      decoration: textDecoration(value['text-decoration'] as String?),
      decorationColor: Parse.color(value['text-decoration-color'] as String?),
      package: value['package'] as String?,
    );
  }

  static FontWeight? fontWeight(String? value) {
    switch (value) {
      case '100':
        return FontWeight.w100;
      case '200':
        return FontWeight.w200;
      case '300':
        return FontWeight.w300;
      case '400':
        return FontWeight.w400;
      case '500':
        return FontWeight.w500;
      case '600':
        return FontWeight.w600;
      case '700':
        return FontWeight.w700;
      case '800':
        return FontWeight.w800;
      case '900':
        return FontWeight.w900;
      case 'bold':
        return FontWeight.bold;
      case 'normal':
        return FontWeight.normal;
      default:
        return null;
    }
  }

  static TextDecoration? textDecoration(String? value) {
    switch (value) {
      case 'line-through':
        return TextDecoration.lineThrough;
      case 'overline':
        return TextDecoration.overline;
      case 'underline':
        return TextDecoration.underline;
      case 'none':
        return TextDecoration.none;
      default:
        return null;
    }
  }

  static TextOverflow? overflow(String? value) {
    switch (value) {
      case 'clip':
        return TextOverflow.clip;
      case 'ellipsis':
        return TextOverflow.ellipsis;
      case 'fade':
        return TextOverflow.fade;
      case 'visible':
        return TextOverflow.visible;
      default:
        return null;
    }
  }

  static TextWidthBasis? textWidthBasis(String? value) {
    switch (value) {
      case 'longest-line':
        return TextWidthBasis.longestLine;
      case 'parent':
        return TextWidthBasis.parent;
      default:
        return null;
    }
  }

  static FontStyle? fontStyle(String? value) {
    switch (value) {
      case 'italic':
        return FontStyle.italic;
      case 'normal':
        return FontStyle.normal;
      default:
        return null;
    }
  }

  static TextLeadingDistribution? textLeadingDistribution(String? value) {
    switch (value) {
      case 'even':
        return TextLeadingDistribution.even;
      case 'proportional':
        return TextLeadingDistribution.proportional;
      default:
        return null;
    }
  }

  static StackFit? stackFit(String? value) {
    switch (value) {
      case 'expand':
        return StackFit.expand;
      case 'loose':
        return StackFit.loose;
      case 'passthrough':
        return StackFit.passthrough;
      default:
        return null;
    }
  }

  static BlendMode? blendMode(String? value) {
    switch (value) {
      case 'clear':
        return BlendMode.clear;
      case 'color':
        return BlendMode.color;
      case 'color-burn':
        return BlendMode.colorBurn;
      case 'color-dodge':
        return BlendMode.colorDodge;
      case 'darken':
        return BlendMode.darken;
      case 'difference':
        return BlendMode.difference;
      case 'dst':
        return BlendMode.dst;
      case 'dst-a-top':
        return BlendMode.dstATop;
      case 'dst-in':
        return BlendMode.dstIn;
      case 'dst-out':
        return BlendMode.dstOut;
      case 'dst-over':
        return BlendMode.dstOver;
      case 'exclusion':
        return BlendMode.exclusion;
      case 'hard-light':
        return BlendMode.hardLight;
      case 'hue':
        return BlendMode.hue;
      case 'lighten':
        return BlendMode.lighten;
      case 'luminosity':
        return BlendMode.luminosity;
      case 'modulate':
        return BlendMode.modulate;
      case 'multiply':
        return BlendMode.multiply;
      case 'overlay':
        return BlendMode.overlay;
      case 'plus':
        return BlendMode.plus;
      case 'saturation':
        return BlendMode.saturation;
      case 'screen':
        return BlendMode.screen;
      case 'soft-light':
        return BlendMode.softLight;
      case 'src':
        return BlendMode.src;
      case 'src-a-top':
        return BlendMode.srcATop;
      case 'src-in':
        return BlendMode.srcIn;
      case 'src-out':
        return BlendMode.srcOut;
      case 'src-over':
        return BlendMode.srcOver;
      case 'xor':
        return BlendMode.xor;
      default:
        return null;
    }
  }

  static Axis? axis(String? value) {
    switch (value) {
      case 'horizontal':
        return Axis.horizontal;
      case 'vertical':
        return Axis.vertical;
      default:
        return null;
    }
  }

  static DecorationPosition? decorationPosition(String? value) {
    switch (value) {
      case 'foreground':
        return DecorationPosition.foreground;
      case 'background':
        return DecorationPosition.background;
      default:
        return null;
    }
  }

  static PlaceholderAlignment? placeholderAlignment(String? value) {
    switch (value) {
      case 'above-baseline':
        return PlaceholderAlignment.aboveBaseline;
      case 'baseline':
        return PlaceholderAlignment.baseline;
      case 'below-baseline':
        return PlaceholderAlignment.belowBaseline;
      case 'bottom':
        return PlaceholderAlignment.bottom;
      case 'middle':
        return PlaceholderAlignment.middle;
      case 'top':
        return PlaceholderAlignment.top;
      default:
        return null;
    }
  }

  static ButtonStyle? buttonStyle(Map? value) {
    if (value == null) {
      return null;
    }

    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> status) {
        if (status.contains(MaterialState.pressed)) {
          return color(value['background-color-pressed'] as String?);
        }

        return color(value['background-color'] as String?);
      }),
      foregroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> status) {
        if (status.contains(MaterialState.pressed)) {
          return color(value['foreground-color-pressed'] as String?);
        }

        return color(value['foreground-color'] as String?);
      }),
      overlayColor: MaterialStateProperty.resolveWith((Set<MaterialState> status) {
        if (status.contains(MaterialState.pressed)) {
          return color(value['overlay-color-pressed'] as String?);
        }

        return color(value['overlay-color'] as String?);
      }),
      shadowColor: MaterialStateProperty.resolveWith((Set<MaterialState> status) {
        if (status.contains(MaterialState.pressed)) {
          return color(value['shadow-color-pressed'] as String?);
        }

        return color(value['shadow-color'] as String?);
      }),
    );
  }

  static WrapAlignment? wrapAlignment(String? value) {
    switch(value) {
      case 'start':
        return  WrapAlignment.start;
      case 'end':
        return  WrapAlignment.end;
      case 'center':
        return  WrapAlignment.center;
      case 'space-around':
        return  WrapAlignment.spaceAround;
      case 'space-between':
        return  WrapAlignment.spaceBetween;
      case 'space-evenly':
        return  WrapAlignment.spaceEvenly;
      default:
        return null;
    }
  }

  static WrapCrossAlignment? wrapCrossAlignment(String? value) {
    switch(value) {
      case 'center':
        return  WrapCrossAlignment.center;
      case 'end':
        return  WrapCrossAlignment.end;
      case 'start':
        return  WrapCrossAlignment.start;
      default:
        return null;
    }
  }
}
