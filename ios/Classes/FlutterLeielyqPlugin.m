#import "FlutterLeielyqPlugin.h"
#import <flutter_leielyq_plugin/flutter_leielyq_plugin-Swift.h>

@implementation FlutterLeielyqPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLeielyqPlugin registerWithRegistrar:registrar];
}
@end
