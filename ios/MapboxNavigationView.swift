import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import MapboxMaps
import Turf
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
    @objc var onLocationChange: RCTDirectEventBlock?
    @objc var onRouteProgressChange: RCTDirectEventBlock?
    @objc var onError: RCTDirectEventBlock?
    @objc var onCancelNavigation: RCTDirectEventBlock?
    @objc var onArrive: RCTDirectEventBlock?
    @objc var onSkip: RCTDirectEventBlock?
    
    
    private lazy var customButton: UIButton = {
          let button = UIButton()
          button.backgroundColor = .white // Customize the button appearance
          button.layer.cornerRadius = 20 // Customize the corner radius to make it a circle
          button.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
          return button
      }()
    
    
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
        if navViewController == nil && !embedding && !embedded {
            embed()
        } else {
            navViewController?.view.frame = bounds
        }
        setupCustomButton()
       // setupMapViewDelegate()
    }
    
    private func setupCustomButton() {
        guard let parentViewController = parentViewController else {
            fatalError("MapboxNavigationView must be added to a parent view controller.")
        }

        parentViewController.view.addSubview(customButton)
        customButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customButton.centerYAnchor.constraint(equalTo: parentViewController.view.centerYAnchor),
            customButton.trailingAnchor.constraint(equalTo: parentViewController.view.trailingAnchor, constant: -16),
            customButton.widthAnchor.constraint(equalToConstant: 40),
            customButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        // Create and customize the "skip" label
            let skipLabel = UILabel()
            skipLabel.text = "Skip"
            skipLabel.textColor = .black
            skipLabel.textAlignment = .center
            skipLabel.translatesAutoresizingMaskIntoConstraints = false

            // Add the "skip" label as a subview to the custom button
            customButton.addSubview(skipLabel)

            // Position the "skip" label in the center of the circular button
            NSLayoutConstraint.activate([
                skipLabel.centerXAnchor.constraint(equalTo: customButton.centerXAnchor),
                skipLabel.centerYAnchor.constraint(equalTo: customButton.centerYAnchor)
            ])
    }
    
    @objc private func customButtonTapped() {
        onSkip?(["message": ""])
       }

    
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        // Cleanup and teardown any existing resources
        self.navViewController?.removeFromParent()
    }
    private func embed() {
        guard origin.count == 2 && destination.count == 2 else { return }
        if waypoints.count < 2 {
            return
        }
        embedding = true
        let originWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: origin[1] as! CLLocationDegrees, longitude: origin[0] as! CLLocationDegrees))
        let destinationWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: destination[1] as! CLLocationDegrees, longitude: destination[0] as! CLLocationDegrees))
        var i = 1
        var waypointsWaypoint = [originWaypoint]
        while i < waypoints.count {
            let wp = Waypoint(coordinate: CLLocationCoordinate2D(latitude: waypoints[i - 1] as! CLLocationDegrees, longitude: waypoints[i] as! CLLocationDegrees))
            waypointsWaypoint.append(wp)
            i += 2
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
                let navigationService = MapboxNavigationService(routeResponse: response, routeIndex: 0, routeOptions: options, simulating: strongSelf.shouldSimulateRoute ? .always : .onPoorGPS)
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
                
            }
            strongSelf.embedded = true
        }
    }
    func navigationViewController(_ navigationViewController: NavigationViewController, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        onLocationChange?(["longitude": location.coordinate.longitude, "latitude": location.coordinate.latitude])
        onRouteProgressChange?(["distanceTraveled": progress.distanceTraveled,
                                "durationRemaining": progress.durationRemaining,
                                "fractionTraveled": progress.fractionTraveled,
                                "distanceRemaining": progress.distanceRemaining])
    }
    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        if canceled {
            onCancelNavigation?(["message": ""])
        }
    }
    private func setupMapViewDelegate() {
        if let navViewController = navViewController, let mapView = navViewController.navigationMapView {
           // mapView.delegate = self
        }
    }
    func navigationViewController(_ navigationViewController: NavigationViewController, didArriveAt waypoint: Waypoint) -> Bool {
        onArrive?(["message": ""])
        return true
    }
}

extension MapboxNavigationView: NavigationMapViewDelegate {
 
func lineWidthExpression(_ multiplier: Double = 1.0) -> Expression {
let lineWidthExpression = Exp(.interpolate) {
Exp(.linear)
Exp(.zoom)
// It's possible to change route line width depending on zoom level, by using expression
// instead of constant. Navigation SDK for iOS also exposes `RouteLineWidthByZoomLevel`
// public property, which contains default values for route lines on specific zoom levels.
RouteLineWidthByZoomLevel.multiplied(by: multiplier)
}
 
return lineWidthExpression
}

 
// It's possible to change route line shape in preview mode by adding own implementation to either
// `NavigationMapView.navigationMapView(_:shapeFor:)` or `NavigationMapView.navigationMapView(_:casingShapeFor:)`.
func navigationMapView(_ navigationMapView: NavigationMapView, shapeFor route: Route) -> LineString? {
return route.shape
}
 
func navigationMapView(_ navigationMapView: NavigationMapView, casingShapeFor route: Route) -> LineString? {
return route.shape
}
 
func navigationMapView(_ navigationMapView: NavigationMapView, routeLineLayerWithIdentifier identifier: String, sourceIdentifier: String) -> LineLayer? {
var lineLayer = LineLayer(id: identifier)
lineLayer.source = sourceIdentifier
 
// `identifier` parameter contains unique identifier of the route layer or its casing.
// Such identifier consists of several parts: unique address of route object, whether route is
// main or alternative, and whether route is casing or not. For example: identifier for
// main route line will look like this: `0x0000600001168000.main.route_line`, and for
// alternative route line casing will look like this: `0x0000600001ddee80.alternative.route_line_casing`.
lineLayer.lineColor = .constant(.init(identifier.contains("main") ? #colorLiteral(red: 0.337254902, green: 0.6588235294, blue: 0.9843137255, alpha: 1) : #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)))
lineLayer.lineWidth = .expression(lineWidthExpression())
lineLayer.lineJoin = .constant(.round)
lineLayer.lineCap = .constant(.round)
 
return lineLayer
}
 
func navigationMapView(_ navigationMapView: NavigationMapView, routeCasingLineLayerWithIdentifier identifier: String, sourceIdentifier: String) -> LineLayer? {
var lineLayer = LineLayer(id: identifier)
lineLayer.source = sourceIdentifier
 
// Based on information stored in `identifier` property (whether route line is main or not)
// route line will be colored differently.
lineLayer.lineColor = .constant(.init(identifier.contains("main") ? #colorLiteral(red: 0.1843137255, green: 0.4784313725, blue: 0.7764705882, alpha: 1) : #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)))
lineLayer.lineWidth = .expression(lineWidthExpression(1.2))
lineLayer.lineJoin = .constant(.round)
lineLayer.lineCap = .constant(.round)
    
 
return lineLayer
}
}
