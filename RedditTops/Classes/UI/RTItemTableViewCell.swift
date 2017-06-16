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

    var item: RTItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for label in [titleLabel, authorLabel, dateLabel, commentsCountLabel] {
            label?.backgroundColor = .clear
        }
        previewImageView?.layer.cornerRadius = 10
        previewImageView?.layer.masksToBounds = true
        previewImageView?.layer.shouldRasterize = true
    }
    
    override func prepareForReuse() {
        previewImageView?.image = nil
        if item != nil, let url = item!.thumbUrl {
            RTImageLoader.cancelDownloadingImage(url: url)
        }
        super.prepareForReuse()
    }
    
    func updateWithItem(item: RTItem) {
        self.item = item
        
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
    
    func updateThumb(url: String?) {
        if let aUrl = url {
            RTImageLoader.downloadImage(url: aUrl, completion: {[unowned self] (loadedImage) in
                DispatchQueue.main.async {
                    let finalImage = loadedImage != nil ? loadedImage! : thumbImage
                    self.previewImageView?.image = finalImage
                }
            })
        } else {
            previewImageView?.image = thumbImage
        }
    }
}
