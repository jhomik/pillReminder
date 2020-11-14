//
//  CustomCollectionViewHeader.swift
//  PR-App
//
//  Created by Jakub Homik on 14/05/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

final class CustomCollectionViewHeader: UICollectionReusableView {
    
    static let reuseID = "headerView"
    private var imageLogo = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHorizontalLogoImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHorizontalLogoImage() {
        let multiplierWidthConstant: CGFloat = DeviceTypes.isiPhoneSE ? 1.2 : 1.5
        let multiplierHeightConstant: CGFloat = 1.5
        
        imageLogo.image = Images.horizontalLogoImage
        self.addSubview(imageLogo)
        
        imageLogo.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(frame.width / multiplierWidthConstant)
            make.height.equalTo(frame.height / multiplierHeightConstant)
        }
    }
}
