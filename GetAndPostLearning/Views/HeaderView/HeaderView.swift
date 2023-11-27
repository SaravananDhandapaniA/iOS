//
//  HeaderView.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 14/06/23.
//

import UIKit

class HeaderView: UIView {
    
    
    @IBOutlet weak var headerImage: UIImageView!
    
    let nibName = "HeaderView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(nibName)
        addGradient()
    }
      
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(nibName)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
    func configureHeader(with model: TitleModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {return}
        headerImage.sd_setImage(with: url, completed: nil)
    }

}
