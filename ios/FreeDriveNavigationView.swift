//
//  FreerideNavigationView.swift
//  mapbox_test
//
//  Created by APPLE on 10/03/22.
//
import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import MapboxMaps

extension UIView {
  var aparentViewController: UIViewController? {
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

class FreeDriveNavigationView: UIViewController, NavigationViewControllerDelegate {
  
  private lazy var navigationMapView = NavigationMapView(frame: view.bounds)
  private let toggleButton = UIButton()
  private let passiveLocationManager = PassiveLocationManager()
  private lazy var passiveLocationProvider = PassiveLocationProvider(locationManager: passiveLocationManager)
  // @objc var onLocationChange: RCTDirectEventBlock?

  private var isSnappingEnabled: Bool = false {
      didSet {
          toggleButton.backgroundColor = isSnappingEnabled ? .blue : .darkGray
          let locationProvider: LocationProvider = isSnappingEnabled ? passiveLocationProvider : AppleLocationProvider()
          navigationMapView.mapView.location.overrideLocationProvider(with: locationProvider)
          passiveLocationProvider.startUpdatingLocation()
          let location = navigationMapView.mapView.location.latestLocation?.coordinate
          // onLocationChange?(["longitude": location?.longitude, "latitude": location?.latitude])
      }
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
      setupNavigationMapView()
      setupSnappingToggle()
  }
  
  private func setupNavigationMapView() {
    navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    navigationMapView.userLocationStyle = .puck2D()
  
    let navigationViewportDataSource = NavigationViewportDataSource(navigationMapView.mapView)
    navigationViewportDataSource.options.followingCameraOptions.zoomUpdatesAllowed = false
    navigationViewportDataSource.followingMobileCamera.zoom = 17.0
    navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
    
    
    
    view.addSubview(navigationMapView)
    let speedLimitView = SpeedLimitView()
    view.addSubview(speedLimitView)
  }
  
  private func setupSnappingToggle() {
      toggleButton.setTitle("Snap to Roads", for: .normal)
      toggleButton.layer.cornerRadius = 5
      toggleButton.translatesAutoresizingMaskIntoConstraints = false
      isSnappingEnabled = true
      toggleButton.addTarget(self, action: #selector(toggleSnapping), for: .touchUpInside)
      view.addSubview(toggleButton)
      toggleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
      toggleButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
      toggleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
      toggleButton.sizeToFit()
      toggleButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
  }
  
  @objc private func toggleSnapping() {
      isSnappingEnabled.toggle()
  }
}
