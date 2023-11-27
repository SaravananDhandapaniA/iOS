//
//  UpcomingTableViewCell.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 19/06/23.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    
    static let upComingIdentifier = "UpcomingTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        setupPlayButton()
    }

    func configure(with model: TitleModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {return}
        posterImageView.sd_setImage(with: url)
        titleLabel.text = model.titleName
    }
    
    func setupPlayButton() {
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        playButton.setImage(image, for: .normal)
        playButton.tintColor = .white
    }
}
