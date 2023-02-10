//
//  Constants.swift
//  MapLibreNavigationPoC
//
//  Created by Ian Wagner on 2023-02-07.
//

import Foundation
// TODO: Use your key
let apiKey = "YOUR-API-KEY"

// WIP; didn't end up using the light one at all.
let lightStyleId = "alidade_smooth"
let lightStyleURL = URL(string: "https://tiles.stadiamaps.com/styles/\(lightStyleId).json?api_key=\(apiKey)")!

let darkStyleId = "alidade_smooth_dark"
let darkStyleURL = URL(string: "https://tiles.stadiamaps.com/styles/\(darkStyleId).json?api_key=\(apiKey)")!
