//
//  PlayView.swift
//  Music
//
//  Created by ruixue on 13/10/17.
//  Copyright © 2017 rui. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

protocol PlayerControl {
    func play()
    func pause()
}

class PlayerView: UIView {
    var playerControl: PlayerControl?
    
    fileprivate var isCurrentlyPlaying = false
    fileprivate let actionButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .lightGray
        addSubview(actionButton)
        
        actionButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        actionButton.setImage(UIImage(named: "playButton"), for: .normal)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        playerControl?.pause()
        actionButton.setImage(UIImage(named: "playButton"), for: .normal)
        isCurrentlyPlaying = false
    }
}

private extension PlayerView {
    @objc func actionButtonTapped() {
        guard let playerControl = self.playerControl else { return }
        if isCurrentlyPlaying {
            playerControl.pause()
            actionButton.setImage(UIImage(named: "playButton"), for: .normal)
        } else {
            playerControl.play()
            actionButton.setImage(UIImage(named: "pauseButton"), for: .normal)
        }
        isCurrentlyPlaying = !isCurrentlyPlaying
    }
}
