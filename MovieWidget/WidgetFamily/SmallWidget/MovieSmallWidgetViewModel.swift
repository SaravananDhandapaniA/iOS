//
//  MovieSmallWidgetViewModel.swift
//  MovieWidgetExtension
//
//  Created by Tringapps on 17/07/23.
//

import UIKit
import SwiftUI

class MovieSmallWidgetViewModel {
    
    var contextItem:Title?
    
    init(contextItem: Title? = nil) {
        self.contextItem = contextItem
        self.eyebrowTitle = contextItem?.original_title  ?? eyebrowTitle
        self.overView = contextItem?.overview ?? overView
        
    }
    
    var eyebrowTitle:String = ""
    var overView:String = ""
    let imageOverlayColor = Color(red: 0.09, green: 0.10, blue: 0.11, opacity: 0.6)
}
