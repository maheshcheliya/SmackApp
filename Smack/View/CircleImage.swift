//
//  CircleImage.swift
//  Smack
//
//  Created by Mahesh on 16/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit
@IBDesignable
class CircleImage: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
