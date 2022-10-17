#import "SanoPlugin.h"
#if __has_include(<sano/sano-Swift.h>)
#import <sano/sano-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sano-Swift.h"
#endif

@implementation SanoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSanoPlugin registerWithRegistrar:registrar];
}
@end
