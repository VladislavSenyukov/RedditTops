//
//  RTItemTableViewCell.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 15.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTItemTableViewCell: UITableViewCell {

    static let identifier = "ItemTableViewCellIdentifier"
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var authorLabel: UILabel?
    @IBOutlet private weak var dateLabel: UILabel?
    @IBOutlet private weak var commentsCountLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        for label in [titleLabel, authorLabel, dateLabel, commentsCountLabel] {
            label?.backgroundColor = .clear
        }
    }
    
    func updateWithItem(item: RTItem) {
        titleLabel?.text = item.title
        authorLabel?.text = item.author
        commentsCountLabel?.text = "\(item.comments) comment\(item.comments > 1 ? "s" : "")"
        let hoursPassed = Int(abs(item.date.timeIntervalSinceNow) / 3600)
        var timeWord = "lately"
        if hoursPassed > 0 {
            timeWord = "hour\(hoursPassed > 1 ? "s" : "")"
        }
        dateLabel?.text = "sent \(hoursPassed) \(timeWord) ago by"
    }

}
