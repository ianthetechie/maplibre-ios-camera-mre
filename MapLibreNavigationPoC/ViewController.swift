//
//  ViewController.swift
//  MapLibreNavigationPoC
//
//  Created by Ian Wagner on 2023-02-07.
//

import UIKit
import MapboxNavigation
import MapboxCoreNavigation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startNavigation() {
        // Request the route via an API
        let routeOptions = NavigationRouteOptions(coordinates: [
            CLLocationCoordinate2D(latitude: 34.92159461931601, longitude: -110.13926293762108),
            CLLocationCoordinate2D(latitude: 35.29808448233627, longitude: -109.13514420842715)
        ])
        getDirections(routeOptions: routeOptions) { route in
            // TODO: Don't force unwrap!!
            let route = route!

            let lightStyle = Style()
            lightStyle.mapStyleURL = lightStyleURL
            lightStyle.previewMapStyleURL = lightStyleURL

            let darkStyle = Style()
            darkStyle.mapStyleURL = darkStyleURL
            darkStyle.previewMapStyleURL = darkStyleURL

            let simulatedLocationManager = SimulatedLocationManager(route: route)
            simulatedLocationManager.speedMultiplier = 5

            let vc = NavigationViewController(for: route, styles: [darkStyle], locationManager: simulatedLocationManager)
            vc.showsReportFeedback = false
            vc.automaticallyAdjustsStyleForTimeOfDay = false

            vc.modalPresentationStyle = .fullScreen

            self.present(vc, animated: true, completion: {
                // FIXME: The logo view always returns when hitting the resume button (after panning around)
                vc.mapView!.logoView.isHidden = true

                // FIXME: Can't seem to get the camera to follow the user properly at all; something is broken.
//                vc.mapView!.setUserTrackingMode(.followWithCourse, animated: true, completionHandler: nil)
            })
        }
        }
}
