//
//  Helpers.swift
//  MapLibreNavigationPoC
//
//  Created by Ian Wagner on 2023-02-07.
//

import Foundation
import MapboxDirections
import MapboxCoreNavigation

func getDirections(routeOptions: RouteOptions, onCompletion: @escaping (Route?) -> ()) {
    // Build up a set of waypoints; this is a bit hackish
    // but should work for now
    let locations = routeOptions.waypoints.map({ waypoint in [
        "lat": waypoint.coordinate.latitude,
        "lon": waypoint.coordinate.longitude,
        "type": "break"
    ] })
    let options: [String: Any] = [
        "locations": locations,
        // TODO: Determine the best profile and options.
        // See https://docs.stadiamaps.com/api-reference/
        // The profile is called "costing"; search the page for costingModel
        "costing": "auto",
        "directions_options": [
            "units": "miles"
        ],
        "filters": [
            "action": "include",
            "attributes": [
              "shape_attributes.speed",
              "shape_attributes.speed_limit",
              "shape_attributes.time",
              "shape_attributes.length"
            ]
        ]
    ]

    let json = try! JSONSerialization.data(withJSONObject: options)

    let url = URL(string: "https://api.stadiamaps.com/route/v1?api_key=\(apiKey)&format=osrm")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = json

    let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        guard let data = data else { return }
        let route = makeRoute(rawResponse: data, options: routeOptions)

        DispatchQueue.main.async {
            onCompletion(route)
        }
    }

    task.resume()
}

func makeRoute(rawResponse: Data, options: RouteOptions) -> Route? {
    guard let responseJSON = try! JSONSerialization.jsonObject(with: rawResponse) as? [String: Any] else { return nil }

    let routes = responseJSON["routes"] as! [[String: Any]]
    let waypoints = (responseJSON["waypoints"] as! [[String: Any]]).map({ waypoint in
        let location = waypoint["location"] as! [CLLocationDegrees]
        return Waypoint(location: CLLocation(latitude: location[1], longitude: location[0]))
    })

    // The constructor doesn't set this as the default, for some reason.
    options.shapeFormat = .polyline6

    return Route(json: routes[0], waypoints: waypoints, options: options)
}
