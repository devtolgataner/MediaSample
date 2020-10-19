//
//  VideoCollectionViewCell.swift
//  MediaSample
//
//  Created by Tolga Taner on 18.10.2020.
//

import UIKit.UICollectionViewCell
import Player


final class VideoCollectionViewCell: UICollectionViewCell {
    
    var player = Player()
    
    private var video:VideoSection.Video! {
        didSet{
            if let video = video {
                guard let resource = URL(string: video.url) else { return }
                player.url = resource
            }
        }
    }
    
    
    
  
    @IBOutlet private weak var playerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        setupPlayer()
        
        
    }
    private func setupPlayer(){
        player.playerDelegate = self
        player.playbackDelegate = self
        player.playbackLoops = true
        player.autoplay = true
        player.playerView.playerBackgroundColor = .white
        player.playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.addSubview(player.view)
        player.view.leadingAnchor.constraint(equalTo: playerView.leadingAnchor).isActive = true
        player.view.trailingAnchor.constraint(equalTo: playerView.trailingAnchor).isActive = true
        player.view.bottomAnchor.constraint(equalTo: playerView.bottomAnchor).isActive = true
        player.view.topAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
        player.fillMode = .resizeAspectFill
    }
    override func prepareForReuse() {
        super.prepareForReuse()
       
    }
    
    
    func populate(_ video:VideoSection.Video){
        self.video = video
    }
    
}

extension VideoCollectionViewCell:PlayerDelegate, PlayerPlaybackDelegate{
    func playerCurrentTimeDidChange(_ player: Player) {
        
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
    
}
