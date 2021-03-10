#import <Flutter/Flutter.h>
#import "QPOSService.h"
#import "BTDeviceFinder.h"
#import "QPOSUtil.h"
@interface FlutterPluginQposPlugin : NSObject<FlutterPlugin,FlutterStreamHandler,QPOSServiceListener,BluetoothDelegate2Mode,UIActionSheetDelegate>
@end
