//
//  ViewController.swift
//  Music
//
//  Created by ruixue on 12/10/17.
//  Copyright © 2017 rui. All rights reserved.
//

import UIKit
import AVFoundation

class MusicViewController: UIViewController {
    
    fileprivate let playerViewHeight: CGFloat = 120
    fileprivate let viewModel = MusicTableViewModel()
    fileprivate let musicCellIdentifier = "musicCellIdentifier"
    fileprivate let searchTextField = UITextField()
    fileprivate let playerView = PlayerView()
    fileprivate let tableView = UITableView()
    fileprivate var selectedSong: MusicData?
    fileprivate var viewModelMap: [IndexPath: MusicCellViewModel] = [:]
    
    fileprivate var musicPlayer: AVPlayer?
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        view.addSubview(playerView)
        playerView.isHidden = true
        
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIApplication.shared.statusBarOrientation.isPortrait {
            layoutPortrait()
        } else {
            layoutLandscape()
        }
        
        searchTextField.placeholder = "Search by artist"
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        searchTextField.borderStyle = .roundedRect
        
        tableView.register(MusicTableCell.classForCoder(), forCellReuseIdentifier: musicCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        playerView.playerControl = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            layoutPortrait()
        } else {
            layoutLandscape()
        }
    }
}

extension MusicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSongs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: musicCellIdentifier, for: indexPath) as! MusicTableCell
        if let songData = viewModel.song(at: indexPath.row) {
            let viewModel = viewModelMap[indexPath] ?? MusicCellViewModel(song: songData)
            viewModelMap[indexPath] = viewModel
            cell.viewModel = viewModel
        }
        return cell
    }
}

extension MusicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let songData = viewModel.song(at: indexPath.row) {
            selectedSong = songData
            
            if playerView.isHidden {
                playerView.isHidden = false
                if UIDevice.current.orientation.isPortrait {
                    layoutPortrait()
                    UIView.animate(withDuration: 0.2,
                                   animations: { self.view.layoutIfNeeded() },
                                   completion: nil)
                }
            }
            playerView.reset()
            musicPlayer = AVPlayer(playerItem: AVPlayerItem(url: songData.previewUrl))
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let viewModel = viewModelMap[indexPath]
        viewModel?.isPlaying = false
        if let cell = tableView.cellForRow(at: indexPath) as? MusicTableCell {
            cell.viewModel = viewModel
        }
    }
}

extension MusicViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let artistName = textField.text, artistName.characters.count > 0 else { return false }
        viewModel.fetchSongListWith(artistName: artistName, limitNumber: 25) { [weak self] errorMessage in
            DispatchQueue.main.async {
                guard let sself = self else { return }
                if errorMessage == nil {
                    sself.viewModelMap.removeAll()
                    sself.tableView.reloadData()
                } else {
                    let alertController = UIAlertController( title: nil, message: errorMessage, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(action)
                    sself.present(alertController, animated: true, completion: nil)
                }
            }
        }
        textField.resignFirstResponder()
        return true
    }
}

extension MusicViewController: PlayerControl {
    func play() {
        musicPlayer?.play()
        notifyMusicCellFor(isPlaying: true)
    }
    
    func pause() {
        musicPlayer?.pause()
        notifyMusicCellFor(isPlaying: false)
    }
    
    private func notifyMusicCellFor(isPlaying: Bool) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let viewModel = viewModelMap[indexPath]
        viewModel?.isPlaying = isPlaying
        
        if let cell = tableView.cellForRow(at: indexPath) as? MusicTableCell {
            cell.viewModel = viewModel
        }
    }
}

private extension MusicViewController {
    func layoutPortrait() {
        searchTextField.snp.remakeConstraints { make in
            make.top.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(44)
        }
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.left.bottom.width.equalToSuperview()
        }
        playerView.snp.remakeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(selectedSong == nil ? 0 : playerViewHeight)
        }
        
        tableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: selectedSong == nil ? 0 : playerViewHeight,
                                              right: 0)
        playerView.alpha = 0.5
    }
    
    func layoutLandscape() {
        searchTextField.snp.remakeConstraints { make in
            make.top.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(44)
        }
        tableView.snp.remakeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        playerView.snp.remakeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(playerViewHeight)
        }
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        playerView.alpha = 1
    }
}

