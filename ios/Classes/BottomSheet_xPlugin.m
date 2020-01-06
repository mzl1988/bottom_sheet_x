#import "BottomSheet_xPlugin.h"
#if __has_include(<bottom_sheet_x/bottom_sheet_x-Swift.h>)
#import <bottom_sheet_x/bottom_sheet_x-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bottom_sheet_x-Swift.h"
#endif

@implementation BottomSheet_xPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBottomSheet_xPlugin registerWithRegistrar:registrar];
}
@end
