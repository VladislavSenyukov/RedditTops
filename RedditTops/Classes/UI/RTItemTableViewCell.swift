//
//  RTItemTableViewCell.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 15.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

let thumbImage = #imageLiteral(resourceName: "nothumb")

class RTItemTableViewCell: UITableViewCell {

    static let identifier = "ItemTableViewCellIdentifier"
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var authorLabel: UILabel?
    @IBOutlet private weak var dateLabel: UILabel?
    @IBOutlet private weak var commentsCountLabel: UILabel?
    @IBOutlet private weak var previewImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        for label in [titleLabel, authorLabel, dateLabel, commentsCountLabel] {
            label?.backgroundColor = .clear
        }
        previewImageView?.layer.cornerRadius = 10
        previewImageView?.layer.masksToBounds = true
        previewImageView?.layer.shouldRasterize = true
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
        updateThumb(url: item.thumbUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func updateThumb(url: String?) {
        if let aUrl = url {
            if let thumbUrl = URL(string: aUrl) {
                if let data = try? Data(contentsOf: thumbUrl) {
                    previewImageView?.image = UIImage(data: data)
                } else {
                    previewImageView?.image = thumbImage
                }
            } else {
                previewImageView?.image = thumbImage
            }
        } else {
            previewImageView?.image = thumbImage
        }
    }

}
