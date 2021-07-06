import Mapbox
import MapboxCoreNavigation
import MapboxDirections
import MapboxNavigation


class MapboxNavigationView: UIView, NavigationViewControllerDelegate {
  var voiceController: CustomVoiceController?
  
  //var options: NavigationRouteOptions!
  @objc var origin: NSArray = [] {
    didSet { startNavigation() }
  }
  @objc var waypointOne: NSArray = [] {
    didSet { startNavigation() }
  }

    @objc var numberoflocations: Int = 0 {
      didSet { startNavigation() }
    }

    @objc var waypoints: NSArray = [] {
      didSet { startNavigation() }
    }

    @objc var waypointTwo: NSArray = [] {
      didSet { startNavigation() }
    }
    @objc var waypointThree: NSArray = [] {
      didSet { startNavigation() }
    }
    @objc var waypointFour: NSArray = [] {
      didSet { startNavigation() }
    }
    @objc var waypointFive: NSArray = [] {
      didSet { startNavigation() }
    }
    @objc var waypointSix: NSArray = [] {
      didSet { startNavigation() }
    }
    @objc var waypointSeven: NSArray = [] {
      didSet { startNavigation() }
    }

  @objc var destination: NSArray = [] {
    didSet { startNavigation() }
  }

  @objc var shouldSimulateRoute: Bool = false
  
  @objc var isMuted: Bool = false {
    didSet {
      guard voiceController != nil else { return }
      voiceController?.isMuted = isMuted
    }
  }
  
  @objc var onProgressChange: RCTDirectEventBlock?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func startNavigation() {
    guard numberoflocations > 1 && origin.count == 2 && destination.count == 2 else { return }
     if numberoflocations == 4 && ((origin.count == 2 && destination.count == 2 && waypointOne.count == 2 && waypoints.count == 2) == false) {
         return
     }
     if numberoflocations == 6 && ((origin.count == 2 && destination.count == 2 && waypointOne.count == 2 && waypoints.count == 2 && waypointTwo.count == 2 && waypointThree.count == 2) == false) {
         return
     }
     if numberoflocations == 8 && ((origin.count == 2 && destination.count == 2 && waypointOne.count == 2 && waypoints.count == 2 && waypointTwo.count == 2 && waypointThree.count == 2 && waypointFour.count == 2 && waypointFive.count == 2) == false) {
         return
     }
    let originWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: origin[1] as! CLLocationDegrees, longitude: origin[0] as! CLLocationDegrees))
    let destinationWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: destination[1] as! CLLocationDegrees, longitude: destination[0] as! CLLocationDegrees))
    let origin = Waypoint(coordinate: CLLocationCoordinate2DMake(22.7532848, 75.8936962))
    let waypointOnes = Waypoint(coordinate: CLLocationCoordinate2DMake(22.7555131, 75.8977850))
    let destination = Waypoint(coordinate: CLLocationCoordinate2DMake(22.724355, 75.8838944))
    var options = NavigationRouteOptions(waypoints: [origin, waypointOnes, destination])
    if waypointSeven.count == 2 && waypointFive.count == 2 && waypointFour.count == 2 && waypointThree.count == 2 && waypointTwo.count == 2 && waypointOne.count == 2 && waypoints.count == 2 {
        let waypointsWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoints[1] as! CLLocationDegrees, longitude: waypoints[0] as! CLLocationDegrees))
        let waypointOneWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointOne[1] as! CLLocationDegrees, longitude: waypointOne[0] as! CLLocationDegrees))
        let waypointTwoWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointTwo[1] as! CLLocationDegrees, longitude: waypointTwo[0] as! CLLocationDegrees))
        let waypointThreeWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointThree[1] as! CLLocationDegrees, longitude: waypointThree[0] as! CLLocationDegrees))
        let waypointFourWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointFour[1] as! CLLocationDegrees, longitude: waypointFour[0] as! CLLocationDegrees))
        let waypointFiveWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointFive[1] as! CLLocationDegrees, longitude: waypointFive[0] as! CLLocationDegrees))
        let waypointSixWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointSix[1] as! CLLocationDegrees, longitude: waypointSix[0] as! CLLocationDegrees))
        let waypointSevenWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointSeven[1] as! CLLocationDegrees, longitude: waypointSeven[0] as! CLLocationDegrees))
        options = NavigationRouteOptions(waypoints: [waypointsWaypoint, waypointOneWaypoint, waypointTwoWaypoint, waypointThreeWaypoint, waypointFourWaypoint, waypointFiveWaypoint, waypointSixWaypoint, waypointSevenWaypoint, destinationWaypoint], profileIdentifier: .automobile)
    }
    else if waypointFive.count == 2 && waypointFour.count == 2 && waypointThree.count == 2 && waypointTwo.count == 2 && waypointOne.count == 2 && waypoints.count == 2 {
        let waypointsWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoints[1] as! CLLocationDegrees, longitude: waypoints[0] as! CLLocationDegrees))
        let waypointOneWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointOne[1] as! CLLocationDegrees, longitude: waypointOne[0] as! CLLocationDegrees))
        let waypointTwoWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointTwo[1] as! CLLocationDegrees, longitude: waypointTwo[0] as! CLLocationDegrees))
        let waypointThreeWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointThree[1] as! CLLocationDegrees, longitude: waypointThree[0] as! CLLocationDegrees))
        let waypointFourWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointFour[1] as! CLLocationDegrees, longitude: waypointFour[0] as! CLLocationDegrees))
        let waypointFiveWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointFive[1] as! CLLocationDegrees, longitude: waypointFive[0] as! CLLocationDegrees))
        options = NavigationRouteOptions(waypoints: [waypointsWaypoint, waypointOneWaypoint, waypointTwoWaypoint, waypointThreeWaypoint, waypointFourWaypoint, waypointFiveWaypoint, destinationWaypoint], profileIdentifier: .automobile)
    }
    else if waypointFour.count == 2 && waypointThree.count == 2 && waypointTwo.count == 2 && waypointOne.count == 2 && waypoints.count == 2 {
        let waypointsWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoints[1] as! CLLocationDegrees, longitude: waypoints[0] as! CLLocationDegrees))
        let waypointOneWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointOne[1] as! CLLocationDegrees, longitude: waypointOne[0] as! CLLocationDegrees))
        let waypointTwoWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointTwo[1] as! CLLocationDegrees, longitude: waypointTwo[0] as! CLLocationDegrees))
        let waypointThreeWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointThree[1] as! CLLocationDegrees, longitude: waypointThree[0] as! CLLocationDegrees))
        let waypointFourWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointFour[1] as! CLLocationDegrees, longitude: waypointFour[0] as! CLLocationDegrees))
        options = NavigationRouteOptions(waypoints: [waypointsWaypoint, waypointOneWaypoint, waypointTwoWaypoint, waypointThreeWaypoint, waypointFourWaypoint, destinationWaypoint], profileIdentifier: .automobile)
    }
    else if waypointThree.count == 2 && waypointTwo.count == 2 && waypointOne.count == 2 && waypoints.count == 2 {
        let waypointsWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoints[1] as! CLLocationDegrees, longitude: waypoints[0] as! CLLocationDegrees))
        let waypointOneWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointOne[1] as! CLLocationDegrees, longitude: waypointOne[0] as! CLLocationDegrees))
        let waypointTwoWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointTwo[1] as! CLLocationDegrees, longitude: waypointTwo[0] as! CLLocationDegrees))
        let waypointThreeWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointThree[1] as! CLLocationDegrees, longitude: waypointThree[0] as! CLLocationDegrees))
        options = NavigationRouteOptions(waypoints: [originWaypoint, waypointsWaypoint, waypointOneWaypoint, waypointTwoWaypoint, waypointThreeWaypoint, destinationWaypoint], profileIdentifier: .automobile)
    }
    else if waypointTwo.count == 2 && waypointOne.count == 2 && waypoints.count == 2 {
        let waypointsWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoints[1] as! CLLocationDegrees, longitude: waypoints[0] as! CLLocationDegrees))
        let waypointOneWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointOne[1] as! CLLocationDegrees, longitude: waypointOne[0] as! CLLocationDegrees))
        let waypointTwoWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointTwo[1] as! CLLocationDegrees, longitude: waypointTwo[0] as! CLLocationDegrees))
        options = NavigationRouteOptions(waypoints: [originWaypoint, waypointsWaypoint, waypointOneWaypoint, waypointTwoWaypoint, destinationWaypoint])
    }
    else if waypointOne.count == 2 && waypoints.count == 2 {
        let waypointsWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoints[1] as! CLLocationDegrees, longitude: waypoints[0] as! CLLocationDegrees))
        let waypointOneWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypointOne[1] as! CLLocationDegrees, longitude: waypointOne[0] as! CLLocationDegrees))
        options = NavigationRouteOptions(waypoints: [originWaypoint, waypointsWaypoint, waypointOneWaypoint, destinationWaypoint], profileIdentifier: .automobile)
    }
    else if waypoints.count == 2 {
        let waypointsWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoints[1] as! CLLocationDegrees, longitude: waypoints[0] as! CLLocationDegrees))
        options = NavigationRouteOptions(waypoints: [originWaypoint, waypointsWaypoint, destinationWaypoint], profileIdentifier: .automobile)
    }
    else{
        options = NavigationRouteOptions(waypoints: [originWaypoint, destinationWaypoint], profileIdentifier: .automobile)
    }
    //let options = NavigationRouteOptions(coordinates: [origin, destination])

    Directions.shared.calculate(options) {  [weak self] (session, result) in
      switch result {
        case .failure(let error):
        print(error.localizedDescription)
        case .success(let response):
        guard let route = response.routes?.first, let strongSelf = self else {
          return
        }
        let navigationService = MapboxNavigationService(route: route, routeOptions: options, simulating: .onPoorGPS)
        let navigationOptions = NavigationOptions(navigationService: navigationService)
        let navigationViewController = NavigationViewController(for: route, routeOptions: options, navigationOptions: navigationOptions)
        navigationViewController.delegate = self
        DispatchQueue.main.async {
            if let controller = UIApplication.shared.keyWindow?.rootViewController {
                controller.addChild(navigationViewController)
                navigationViewController.view.frame = CGRect(x: 0, y: controller.view.frame.height*0.25, width: controller.view.frame.width, height: controller.view.frame.height-(controller.view.frame.height*0.25))
                controller.view.addSubview(navigationViewController.view)
                navigationViewController.didMove(toParent: controller)
//                controller.navigationController?.pushViewController(navigationViewController, animated: true)
            }
        }
//        let view = navigationViewController.view!
//        //view.bounds = strongSelf.bounds
//        //view.frame = self!.frame
//        //view.bounds = self!.bounds
//        //parentVC.addChild(navigationViewController)
//        strongSelf.addSubview(view)
//        view.frame = strongSelf.bounds
//        //navigationViewController.didMove(toParent: parentVC)


      }
    }
  }
    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        debugPrint(#function)
        if let controller = UIApplication.shared.keyWindow?.rootViewController {
            for child in controller.children {
                if child.isKind(of: NavigationViewController.self) {
                    child.removeFromParent()
                    child.view.removeFromSuperview()
                    controller.navigationController?.popViewController(animated: true)
                    break
                }
            }
        }
    }
  func navigationViewController(_ navigationViewController: NavigationViewController, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
    if let onProgress = self.onProgressChange {
        DispatchQueue.main.async {
            onProgress(["longitude": location.coordinate.longitude, "latitude": location.coordinate.latitude])
        }
    }
  }
}

class CustomVoiceController: MapboxVoiceController {
  var isMuted = false
  
  override func didPassSpokenInstructionPoint(notification: NSNotification) {
    if isMuted == false {
      super.didPassSpokenInstructionPoint(notification: notification)
    }
  }
}
