//
//  MovieWidgetBundle.swift
//  MovieWidget
//
//  Created by Tringapps on 17/07/23.
//

import WidgetKit
import SwiftUI

@main
struct MovieWidgetBundle: WidgetBundle {
    var body: some Widget {
        MovieWidget()
        MovieWidgetLiveActivity()
    }
}
