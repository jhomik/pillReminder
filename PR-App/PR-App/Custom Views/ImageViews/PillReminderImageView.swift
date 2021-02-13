//
//  PillReminderImageView.swift
//  PillReminder
//
//  Created by Jakub Homik on 22/11/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import SnapKit

class PillReminderImageView: UIImageView {
    
    private let firebaseManager = FirebaseManager()
    private let placeholderImage = Images.placeholderImage
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePillImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePillImageView() {
        let pillImageCornerRadius: CGFloat = 16
        self.image = placeholderImage
        self.backgroundColor = .tertiarySystemFill
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.cornerRadius = pillImageCornerRadius
        self.sizeToFit()
    }
    
    // TODO: Change location of calling method downloadImage()
    public func downloadImage(with url: String) {
        firebaseManager.downloadImage(with: url) { [weak self] (image) in
            guard let self = self else { return }
            if Thread.isMainThread {
                self.image = image
            } else {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
