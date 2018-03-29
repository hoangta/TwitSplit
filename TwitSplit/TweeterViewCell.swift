//
//  TweeterViewCell.swift
//  TwitSplit
//
//  Created by Hoang Ta on 3/29/18.
//  Copyright © 2018 2359Media. All rights reserved.
//

import UIKit
import SnapKit

//Im using snapkit for managing autolayout here...

class TweeterViewCell: UITableViewCell {

    var contentLabel: UILabel! //Assign with the tweeter's text
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    private func setUpViews() {
        backgroundColor = .clear
        
        let holderView = UIView()
        holderView.addShadow()
        holderView.layer.cornerRadius = 5
        holderView.backgroundColor = .white
        contentView.addSubview(holderView)
        holderView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
            
            //We do not want the cell to be too narrowed
            make.height.greaterThanOrEqualTo(80)
        }
        
        contentLabel = UILabel()
        contentLabel.font = UIFont(name: "Avenir-Roman", size: 14)
        contentLabel.textColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        holderView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
}
