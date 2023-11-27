//
//  ButtonView.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 14/06/23.
//

import UIKit

class ButtonView: UIView {

    let nibName = "ButtonView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(nibName)
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

}
