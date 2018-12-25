//
//  playerModel.swift
//  iTunesSearchExample
//
//  Created by LinChe-Ching on 2018/12/23.
//  Copyright © 2018 Che-ching Lin. All rights reserved.
//

import Foundation
import AVFoundation

final class playerModel : NSObject {
    static let model = playerModel()
    
    private override init () {
    }
    
    var playerItem : AVPlayerItem?
    var url : URL? {
        didSet {
            self.playerItem = AVPlayerItem.init(url: url!)
        }
    }
    var player:AVPlayer?

    func play() -> Void {
        self.player = AVPlayer.init(playerItem: self.playerItem)
        guard let player = self.player else {
            return
        }
        player.play()
    }
    
}
