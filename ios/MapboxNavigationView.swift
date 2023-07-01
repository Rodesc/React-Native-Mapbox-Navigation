import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

// // adapted from https://pspdfkit.com/blog/2017/native-view-controllers-and-react-native/ and https://github.com/mslabenyak/react-native-mapbox-navigation/blob/master/ios/Mapbox/MapboxNavigationView.swift
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class MapboxNavigationView: UIView, NavigationViewControllerDelegate {
    weak var navViewController: NavigationViewController?
    var embedded: Bool
    var embedding: Bool
    
    @objc var waypoints: NSArray = [] {
        didSet { setNeedsLayout() }
    }
        
    @objc var origin: NSArray = [] {
        didSet { setNeedsLayout() }
    }
    
    @objc var destination: NSArray = [] {
        didSet { setNeedsLayout() }
    }

    @objc var shouldSimulateRoute: Bool = false
    @objc var showsEndOfRouteFeedback: Bool = false
    @objc var routeLineTracksTraversal: Bool = true
    @objc var hideStatusView: Bool = false
    @objc var mute: Bool = false
    @objc var inactiveWaypointColor: UIColor = .gray {
        didSet {
            if let routeStyle = navViewController?.mapView?.style {
                routeStyle.waypointCircleColor = inactiveWaypointColor
            }
        }
    }
    
    @objc var onLocationChange: RCTDirectEventBlock?
    @objc var onRouteProgressChange: RCTDirectEventBlock?
    @objc var onError: RCTDirectEventBlock?
    @objc var onCancelNavigation: RCTDirectEventBlock?
    @objc var onArrive: RCTDirectEventBlock?
    @objc var onSkip: RCTDirectEventBlock?
    var button: UIButton!
    
    override init(frame: CGRect) {
        self.embedded = false
        self.embedding = false
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (navViewController == nil && !embedding && !embedded) {
            embed()
        } else {
            navViewController?.view.frame = bounds
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        // cleanup and teardown any existing resources
        self.navViewController?.removeFromParent()
    }
    
    private func embed() {
        guard origin.count == 2 && destination.count == 2 else { return }
        if ((waypoints.count >= 2) == false) {
                     return
        }

        embedding = true

        let originWaypoint      = Waypoint(coordinate: CLLocationCoordinate2D(latitude: origin[1] as! CLLocationDegrees, longitude: origin[0] as! CLLocationDegrees))
        let destinationWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: destination[1] as! CLLocationDegrees, longitude: destination[0] as! CLLocationDegrees))
    
        var i = 1
        var waypointsWaypoint = [originWaypoint]
        for _ in waypoints {
            if i%2 == 0 {
                var wp = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoints[i-2] as! CLLocationDegrees, longitude: waypoints[i-1] as! CLLocationDegrees))
                waypointsWaypoint.append(wp)
            }
            i=i+1
        }
        waypointsWaypoint.append(destinationWaypoint)
        let options = NavigationRouteOptions(waypoints: waypointsWaypoint)

        Directions.shared.calculate(options) { [weak self] (_, result) in
            guard let strongSelf = self, let parentVC = strongSelf.parentViewController else {
                return
            }
            
            switch result {
                case .failure(let error):
                    strongSelf.onError?(["message": error.localizedDescription])
                case .success(let response):
                    guard let weakSelf = self else {
                        return
                    }
                    
                    let navigationService = MapboxNavigationService(routeResponse: response, routeIndex: 0, routeOptions: options, simulating: .onPoorGPS)//strongSelf.shouldSimulateRoute ? .always : .never)
                    
                    let navigationOptions = NavigationOptions(navigationService: navigationService)
                    let vc = NavigationViewController(for: response, routeIndex: 0, routeOptions: options, navigationOptions: navigationOptions)

                    vc.showsEndOfRouteFeedback = strongSelf.showsEndOfRouteFeedback
                    vc.routeLineTracksTraversal = strongSelf.routeLineTracksTraversal
                    
                    StatusView.appearance().isHidden = strongSelf.hideStatusView

                    NavigationSettings.shared.voiceMuted = strongSelf.mute;
                    
                    vc.delegate = strongSelf
                
                    parentVC.addChild(vc)
                    strongSelf.addSubview(vc.view)
                    vc.view.frame = strongSelf.bounds
                    vc.didMove(toParent: parentVC)
                    strongSelf.navViewController = vc
                    
                    // Add a button
                    strongSelf.button = UIButton(type: .system)
                    strongSelf.button.setTitle("Skip", for: .normal)
                    strongSelf.button.addTarget(strongSelf, action: #selector(strongSelf.skipTapped), for: .touchUpInside)
                let buttonWidth: CGFloat = 100
                let buttonHeight: CGFloat = 40
                let buttonX: CGFloat = strongSelf.bounds.width - buttonWidth - 20 // Adjust the padding as needed
                let buttonY: CGFloat = 40 // Adjust the top padding as needed

                strongSelf.button.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
                vc.view.addSubview(strongSelf.button)
                    
                    // Set the line color for inactive waypoints
                    if let routeStyle = vc.mapView?.style {
                        routeStyle.waypointCircleColor = strongSelf.inactiveWaypointColor
                    }
            }
            strongSelf.embedded = true
        }
    }
    
    @objc func skipTapped() {
        // Handle button tap event here
        onSkip?(["message": ""]);
    }
    
    func navigationViewController(_ navigationViewController: NavigationViewController, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        onLocationChange?(["longitude": location.coordinate.longitude, "latitude": location.coordinate.latitude])
        onRouteProgressChange?(["distanceTraveled": progress.distanceTraveled,
                                "durationRemaining": progress.durationRemaining,
                                "fractionTraveled": progress.fractionTraveled,
                                "distanceRemaining": progress.distanceRemaining])
    }
    
    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        if (!canceled) {
            return;
        }
        onCancelNavigation?(["message": ""]);
    }
    
    func navigationViewController(_ navigationViewController: NavigationViewController, didArriveAt waypoint: Waypoint) -> Bool {
        onArrive?(["message": ""]);
        return true;
    }
}
