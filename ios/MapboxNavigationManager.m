#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(MapboxNavigationManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(onProgressChange, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(numberoflocations, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(origin, NSArray)
RCT_EXPORT_VIEW_PROPERTY(destination, NSArray)
RCT_EXPORT_VIEW_PROPERTY(waypoints, NSArray)
RCT_EXPORT_VIEW_PROPERTY(waypointOne, NSArray)
RCT_EXPORT_VIEW_PROPERTY(waypointTwo, NSArray)
RCT_EXPORT_VIEW_PROPERTY(waypointThree, NSArray)
RCT_EXPORT_VIEW_PROPERTY(waypointFour, NSArray)
RCT_EXPORT_VIEW_PROPERTY(waypointFive, NSArray)
RCT_EXPORT_VIEW_PROPERTY(waypointSix, NSArray)
RCT_EXPORT_VIEW_PROPERTY(waypointSeven, NSArray)
RCT_EXPORT_VIEW_PROPERTY(isMuted, BOOL)
RCT_EXPORT_VIEW_PROPERTY(shouldSimulateRoute, BOOL)

@end
