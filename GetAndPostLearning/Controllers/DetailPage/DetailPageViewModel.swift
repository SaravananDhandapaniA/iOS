//
//  DetailPageViewModel.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 21/06/23.
//

import UIKit

class DetailPageViewModel {
    var title: String?
    var desc: String?
    var url: URL?
    
    func setData(data: DetailModel) {
        title = data.title
        desc = data.description
        guard let urlData = URL(string: "https://www.youtube.com/embed/\(data.videoView.id.videoId)") else {return}
        url = urlData
    }
}
