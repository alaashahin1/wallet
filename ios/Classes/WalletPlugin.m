#import "WalletPlugin.h"
#if __has_include(<wallet/wallet-Swift.h>)
#import <wallet/wallet-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "wallet-Swift.h"
#endif

@implementation WalletPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWalletPlugin registerWithRegistrar:registrar];
}
@end
