//
//  DoseScheduleCell.swift
//  PR-App
//
//  Created by Tayler Moosa on 5/14/20.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
protocol PassBackFromScheduleDelegate : class {
    func updateFromDoseSchedule(updatedValue: Double, tag: Int)
}

class DoseScheduleCell: UITableViewCell {
    static let reuseID  = "DoseScheduleCell"
    weak var passBackFromScheduleDelegate : PassBackFromScheduleDelegate!
    var sunriseImage    = UIImageView(image: UIImage(systemName: "sunrise"))
    var midDayImage     = UIImageView(image: UIImage(systemName: "sun.max"))
    var sunsetImage     = UIImageView(image: UIImage(systemName: "sunset"))
    var sunriseInput    = CustomInputField(placeholderText: "0", isPassword: false)
    var midDayInput    = CustomInputField(placeholderText: "0", isPassword: false)
    var sunsetInput    = CustomInputField(placeholderText: "0", isPassword: false)
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureAllConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(morning: Double, midDay: Double, evening: Double) {
        sunriseInput.text = String(morning)
        midDayInput.text = String(midDay)
        sunsetInput.text = String(evening)
    }
    private func configure() {
        
    }
    
    @objc private func update(sender: CustomInputField) {
        let newValue = Double(sender.text!) ?? 0
        passBackFromScheduleDelegate.updateFromDoseSchedule(updatedValue: newValue, tag: sender.tag)
        
    }
    private func configureAllConstraints() {
        sunriseImage.translatesAutoresizingMaskIntoConstraints  = false
        midDayImage.translatesAutoresizingMaskIntoConstraints   = false
        sunsetImage.translatesAutoresizingMaskIntoConstraints   = false
        addSubview(sunriseImage)
        addSubview(midDayImage)
        addSubview(sunsetImage)
        addSubview(sunriseInput)
        addSubview(midDayInput)
        addSubview(sunsetInput)
        sunriseInput.tag = 1
        sunriseInput.addTarget(self, action: #selector(update(sender:)), for: .editingChanged)
        sunriseInput.keyboardType = .decimalPad
        midDayInput.tag = 2
        midDayInput.addTarget(self, action: #selector(update(sender:)), for: .editingChanged)
        midDayInput.keyboardType = .decimalPad
        sunsetInput.tag = 3
        sunsetInput.addTarget(self, action: #selector(update(sender:)), for: .editingChanged)
        sunsetInput.keyboardType = .decimalPad
        let width   : CGFloat = UIScreen.main.bounds.width / 6
        let height  : CGFloat = UIScreen.main.bounds.width / 7
        let spacing : CGFloat = (UIScreen.main.bounds.width * 0.5) / 4
        let imageDimensions : CGFloat = width * 0.75
        let padding : CGFloat = 5
        
        NSLayoutConstraint.activate([
            
            sunriseInput.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            sunriseInput.widthAnchor.constraint(equalToConstant: width),
            sunriseInput.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            sunriseInput.heightAnchor.constraint(equalToConstant: height),
            
            midDayInput.leadingAnchor.constraint(equalTo: sunriseInput.trailingAnchor, constant: spacing),
            midDayInput.widthAnchor.constraint(equalToConstant: width),
            midDayInput.heightAnchor.constraint(equalToConstant: height),
            midDayInput.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            
            sunsetInput.leadingAnchor.constraint(equalTo: midDayInput.trailingAnchor, constant: spacing),
            sunsetInput.widthAnchor.constraint(equalToConstant: width),
            sunsetInput.heightAnchor.constraint(equalToConstant: height),
            sunsetInput.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            
            sunriseImage.centerXAnchor.constraint(equalTo: sunriseInput.centerXAnchor),
            sunriseImage.widthAnchor.constraint(equalToConstant: imageDimensions),
            sunriseImage.topAnchor.constraint(equalTo: sunriseInput.bottomAnchor, constant: padding),
            sunriseImage.heightAnchor.constraint(equalToConstant: imageDimensions),
            
            midDayImage.centerXAnchor.constraint(equalTo: midDayInput.centerXAnchor),
            midDayImage.widthAnchor.constraint(equalToConstant: imageDimensions),
            midDayImage.heightAnchor.constraint(equalToConstant: imageDimensions),
            midDayImage.topAnchor.constraint(equalTo: midDayInput.bottomAnchor, constant: padding),
            
            sunsetImage.centerXAnchor.constraint(equalTo: sunsetInput.centerXAnchor),
            sunsetImage.widthAnchor.constraint(equalToConstant: imageDimensions),
            sunsetImage.heightAnchor.constraint(equalToConstant: imageDimensions),
            sunsetImage.topAnchor.constraint(equalTo: sunsetInput.bottomAnchor, constant: padding),
            
        ])
        
    }
}
