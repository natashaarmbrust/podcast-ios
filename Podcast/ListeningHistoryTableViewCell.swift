//
//  ListeningHistoryTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/24/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol ListeningHistoryTableViewCellDelegate: class {
    func listeningHistoryTableViewCellDidPressMoreButton(cell: ListeningHistoryTableViewCell)
}

class ListeningHistoryTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 84
    
    let imageViewPaddingX: CGFloat = 18
    let imageViewPaddingY: CGFloat = 18
    let imageViewWidth: CGFloat = 48
    let imageViewHeight: CGFloat = 48
    let imageViewLabelPadding: CGFloat = 12
    let titleLabelHeight: CGFloat = 36
    let moreButtonPaddingX: CGFloat = 18
    let moreButtonHeight: CGFloat = 30
    let moreButtonWidth: CGFloat = 30
    
    var episodeImageView: ImageView!
    var titleLabel: UILabel!
    var detailLabel: UILabel!
    var moreButton: MoreButton!
    var seperator: UIView!
    
    weak var delegate: ListeningHistoryTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        episodeImageView = ImageView()
        contentView.addSubview(episodeImageView)
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        detailLabel = UILabel()
        detailLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        detailLabel.textColor = .podcastGrayDark
        contentView.addSubview(detailLabel)
        
        moreButton = MoreButton(frame: CGRect.zero)
        moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        contentView.addSubview(moreButton)
        
        seperator = UIView(frame: CGRect.zero)
        seperator.backgroundColor = .podcastWhiteDark
        contentView.addSubview(seperator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        episodeImageView.frame = CGRect(x: imageViewPaddingX, y: imageViewPaddingY, width: imageViewWidth, height: imageViewHeight)
        let titleLabelX: CGFloat = episodeImageView.frame.maxX + imageViewLabelPadding
        let moreButtonX: CGFloat = frame.width - moreButtonPaddingX - moreButtonWidth
        titleLabel.frame = CGRect(x: titleLabelX, y: imageViewPaddingY-2, width: moreButtonX - titleLabelX, height: titleLabelHeight)
        detailLabel.frame = CGRect(x: titleLabelX, y: titleLabel.frame.maxY, width: titleLabel.frame.width, height:episodeImageView.frame.height - titleLabel.frame.height + 2)
        moreButton.frame = CGRect(x: moreButtonX, y: 0, width: moreButtonWidth, height: moreButtonHeight)
        moreButton.center.y = frame.height / 2
        separatorInset = UIEdgeInsets(top: 0, left: titleLabelX, bottom: 0, right: 0)
        seperator.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
    }
    
    func configure(for episode: Episode) {
        episodeImageView.image = #imageLiteral(resourceName: "sample_series_artwork")
        episodeImageView.sizeToFit()
        if let url = episode.smallArtworkImageURL {
            episodeImageView.setImageAsynchronously(url: url, completion: nil)
        }
        titleLabel.text = episode.title
        detailLabel.text = episode.dateTimeSeriesString()
    }
    
    func didPressMoreButton() {
        delegate?.listeningHistoryTableViewCellDidPressMoreButton(cell: self)
    }
}
