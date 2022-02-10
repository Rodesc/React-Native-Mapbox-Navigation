import Mapbox
import MapboxCoreNavigation
import MapboxDirections
import MapboxNavigation


class MapboxNavigationView: UIView, NavigationViewControllerDelegate {
  
  //var options: NavigationRouteOptions!
  @objc var origin: NSArray = [] {
    didSet { startNavigation() }
  }

  @objc var numberoflocations: Int = 0 {
    didSet { startNavigation() }
  }

  @objc var waypoints: NSArray = [] {
    didSet { startNavigation() }
  }

  @objc var destination: NSArray = [] {
    didSet { startNavigation() }
  }

  @objc var shouldSimulateRoute: Bool = false
  
  
  @objc var onProgressChange: RCTDirectEventBlock?
  @objc var onLocationChange: RCTDirectEventBlock?
  @objc var onRouteProgressChange: RCTDirectEventBlock?
  @objc var onError: RCTDirectEventBlock?
  @objc var onCancelNavigation: RCTDirectEventBlock?
  @objc var onArrive: RCTDirectEventBlock?

  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func startNavigation() {
    guard numberoflocations > 1 && origin.count == 2 && destination.count == 2 else { return }
     if numberoflocations == 4 && ((waypoints.count >= 2) == false) {
         return
     }
    let originWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: origin[1] as! CLLocationDegrees, longitude: origin[0] as! CLLocationDegrees))
    let destinationWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: destination[1] as! CLLocationDegrees, longitude: destination[0] as! CLLocationDegrees))
    let origin = Waypoint(coordinate: CLLocationCoordinate2DMake(23.2599, 77.4126))
    let destination = Waypoint(coordinate: CLLocationCoordinate2DMake(23.0225, 72.5714))
    var options = NavigationRouteOptions(waypoints: [origin, destination])
    var i = 1
    var waypointsWaypoint = [Waypoint]()
    for item in waypoints {
      if i%2 == 0 {
        waypointsWaypoint.append(Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoints[i-1] as! CLLocationDegrees, longitude: waypoints[i-2] as! CLLocationDegrees)))
      }
      i=i+1
    }
    if waypointsWaypoint.count >= 2 {
        options = NavigationRouteOptions(waypoints: waypointsWaypoint, profileIdentifier: .automobile)
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
            let navigationService = MapboxNavigationService(route: route, routeIndex: 0, routeOptions: options, simulating: .onPoorGPS)
            let navigationOptions = NavigationOptions(navigationService: navigationService)
            let navigationViewController = NavigationViewController(for: route, routeIndex: 0, routeOptions: options, navigationOptions: navigationOptions)
        navigationViewController.delegate = self
        DispatchQueue.main.async {
            if let controller = UIApplication.shared.keyWindow?.rootViewController {
                controller.addChild(navigationViewController)
                navigationViewController.view.frame = CGRect(x: 0, y: 0, width: controller.view.frame.width, height: controller.view.frame.height)
                controller.view.addSubview(navigationViewController.view)
                navigationViewController.didMove(toParent: controller)
            }
        }

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
        if (!canceled) {
          return;
        }
        onCancelNavigation?(["message": ""]);
    }
  func navigationViewController(_ navigationViewController: NavigationViewController, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
    onLocationChange?(["longitude": location.coordinate.longitude, "latitude": location.coordinate.latitude])
    onRouteProgressChange?(["distanceTraveled": progress.distanceTraveled,
                            "durationRemaining": progress.durationRemaining,
                            "fractionTraveled": progress.fractionTraveled,
                            "distanceRemaining": progress.distanceRemaining])
    // if let onProgress = self.onProgressChange {
    //     DispatchQueue.main.async {
    //         onProgress(["longitude": location.coordinate.longitude, "latitude": location.coordinate.latitude])
    //     }
    // }
  }
  func navigationViewController(_ navigationViewController: NavigationViewController, didArriveAt waypoint: Waypoint) -> Bool {
    onArrive?(["message": "Arrived"]);
    return true;
  }
}
