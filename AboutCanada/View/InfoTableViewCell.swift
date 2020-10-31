//
//  InfoTableViewCell.swift
//  AboutCanada
//
//  Created by Veera Venkata Sateesh Pasala on 31/10/20.
//  Copyright © 2020 Veera Venkata Sateesh Pasala. All rights reserved.
//

import UIKit

public protocol CandaListCellData {
    var title: String { get }
    var body: String { get }
    var icon: String { get }
}

class InfoTableViewCell: UITableViewCell {
    
    var cellImage = UIImageView()
    private let title = UILabel()
    private let descreption = UILabel()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.1)
        selectedBackgroundView = backgroundView
        
        contentView.addSubview(cellImage)
        contentView.addSubview(title)
        contentView.addSubview(descreption)
        
        
        configLabels()
        installConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func installConstraints() {
        
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant:80).isActive = true
        
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        cellImage.widthAnchor.constraint(equalToConstant: 62).isActive = true
        cellImage.heightAnchor.constraint(equalToConstant: 62).isActive = true
        cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        title.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 8).isActive = true
        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        descreption.translatesAutoresizingMaskIntoConstraints = false
        descreption.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        descreption.leadingAnchor.constraint(equalTo: title.leadingAnchor, constant: 0).isActive = true
        descreption.trailingAnchor.constraint(equalTo: title.trailingAnchor, constant: 0).isActive = true
        descreption.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
    }
    
    override func prepareForReuse() {
        title.textColor = nil
        descreption.textColor = nil
        self.cellImage.image = nil
    }
    
    public func show(data: CandaListCellData) {
        if(data.title == ""){
            title.textColor = UIColor.red
            title.text = ConstantStrings.titleError.rawValue
            
        }else{
            title.text = data.title
        }
        
        if(data.body == ""){
            descreption.textColor = UIColor.red
            descreption.text = ConstantStrings.descreptionError.rawValue
        }else{
            descreption.text = data.body
        }
        
        if(data.icon == ""){
            cellImage.image = UIImage(named: "noImage")
        }else{
            cellImage.loadThumbnail(urlSting: data.icon )
        }
    }
    
    
    private func configLabels() {
        title.isUserInteractionEnabled = false
        title.numberOfLines = 0
        title.font = .boldSystemFont(ofSize: 18)
        descreption.numberOfLines = 0
        descreption.font = .italicSystemFont(ofSize: 18)
        cellImage.contentMode =  .scaleAspectFit;
        
    }
}
