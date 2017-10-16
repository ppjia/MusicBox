//
//  MusicCellView.swift
//  Music
//
//  Created by ruixue on 13/10/17.
//  Copyright © 2017 rui. All rights reserved.
//

import UIKit
import SnapKit

class MusicTableCell: UITableViewCell {
    private let cellView = MusicCellView()
    
    var viewModel: MusicCellViewModel? {
        didSet {
            viewModel?.loadThumbnail { [weak self] result in
                guard let sself = self else { return }
                switch result {
                case let .success((url, image)):
                    if url.absoluteString == sself.viewModel?.thumbnailImageURL?.absoluteString {
                        DispatchQueue.main.async {
                            sself.cellView.thumbnailView.image = image
                        }
                    }
                case .failure(_):
                    break
                }
            }
            cellView.songNameLabel.text = viewModel?.songName
            cellView.artistNameLabel.text = viewModel?.artistName
            cellView.albumNameLabel.text = viewModel?.albumName
            cellView.playingIndicator.isHidden = !(viewModel?.isPlaying ?? false)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MusicCellView: UIView {
    private let verticalPadding = 4
    private let horizontalPadding = 20
    
    fileprivate let thumbnailView = UIImageView()
    fileprivate let songNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    fileprivate let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    fileprivate let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    fileprivate let playingIndicator = UIImageView(image: UIImage(named: "sound"))
    
    init() {
        super.init(frame: .zero)
        
        addSubview(thumbnailView)
        addSubview(songNameLabel)
        addSubview(artistNameLabel)
        addSubview(albumNameLabel)
        addSubview(playingIndicator)
        
        thumbnailView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(48)
        }
        songNameLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalTo(thumbnailView.snp.right).offset(horizontalPadding)
        }
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(songNameLabel.snp.bottom).offset(verticalPadding)
            make.left.equalTo(thumbnailView.snp.right).offset(horizontalPadding)
            make.right.equalToSuperview()
        }
        albumNameLabel.snp.makeConstraints { make in
            make.top.equalTo(artistNameLabel.snp.bottom).offset(verticalPadding)
            make.left.equalTo(thumbnailView.snp.right).offset(horizontalPadding)
            make.right.bottom.equalToSuperview()
        }
        playingIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(verticalPadding)
            make.width.height.equalTo(40)
        }
        
        playingIndicator.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
