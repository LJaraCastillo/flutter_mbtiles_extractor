#import "FlutterMbtilesExtractorPlugin.h"
#import <flutter_mbtiles_extractor/flutter_mbtiles_extractor-Swift.h>

@implementation FlutterMbtilesExtractorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMbtilesExtractorPlugin registerWithRegistrar:registrar];
}
@end
