#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <AppKit/AppKit.h>

@interface InputSourceTracker : NSObject
@property(retain) NSMutableDictionary* applicationInputSources;
- (void)handleInputSourceChange;
- (void)activeAppDidChange:(NSNotification *)notification;
@end

@implementation InputSourceTracker
- (id)init {
  self = [super init];

  if (self) {
    self.applicationInputSources = [[NSMutableDictionary alloc] init];
  }

  return self;
}

- (void)handleInputSourceChange {
  TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();

  CFStringRef inputSourceName = TISGetInputSourceProperty(source, kTISPropertyLocalizedName);

  NSRunningApplication* application = [[NSWorkspace sharedWorkspace] frontmostApplication];

  self.applicationInputSources[application.localizedName] = (__bridge NSString*)inputSourceName;

  CFRelease(source);
}

- (void)activeAppDidChange:(NSNotification *)notification {
  NSRunningApplication* application = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
  CFStringRef inputSourceName = (__bridge CFStringRef)self.applicationInputSources[application.localizedName];

  CFArrayRef inputArray = TISCreateInputSourceList(NULL, false);

  if (inputSourceName == NULL) {
    inputSourceName = (__bridge CFStringRef)@"U.S.";
  }

  int inputCount = CFArrayGetCount(inputArray);

  for (int i = 0; i < inputCount; i++) {
    TISInputSourceRef input = (TISInputSourceRef) CFArrayGetValueAtIndex(inputArray, i);

    CFStringRef inputName = TISGetInputSourceProperty(input, kTISPropertyLocalizedName);

    if (CFStringCompare(inputName, inputSourceName, 0) == 0) {
      TISSelectInputSource(input);
    }
  }

  CFRelease(inputArray);
}
@end

int main (int argc, const char * argv[]) {
  [NSApplication sharedApplication];

  NSStatusItem* statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];

  statusItem.title = @"Quit";
  statusItem.action = @selector(terminate:);

  InputSourceTracker* tracker = [[InputSourceTracker alloc] init];

  [[NSNotificationCenter defaultCenter]
    addObserver:tracker
       selector:@selector(handleInputSourceChange)
           name:NSTextInputContextKeyboardSelectionDidChangeNotification object:nil
  ];

  [[[NSWorkspace sharedWorkspace] notificationCenter]
    addObserver:tracker
       selector:@selector(activeAppDidChange:)
           name:NSWorkspaceDidActivateApplicationNotification
         object:nil
  ];

  [NSApp run];
 }
