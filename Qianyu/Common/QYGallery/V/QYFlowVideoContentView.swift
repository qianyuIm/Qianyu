//
//  QYFlowVideoContentView.swift
//  Qianyu
//
//  Created by cyd on 2021/1/5.
//

import UIKit
import ZFPlayer

class QYFlowVideoContentView: UIView, ZFPlayerMediaControl{
    weak var player: ZFPlayerController?
    lazy var playSender: UIButton = {
        let sender = UIButton(type: .custom)
        sender.isUserInteractionEnabled = false
        sender.setImage(R.image.icon_play_pause(), for: .normal)
        return sender
    }()
    lazy var sliderView: ZFSliderView = {
        let sliderView = ZFSliderView()
        sliderView.maximumTrackTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        sliderView.minimumTrackTintColor = .white
        sliderView.bufferTrackTintColor = .clear
        sliderView.sliderHeight = 1
        sliderView.isHideSliderBlock = false
        return sliderView
    }()
    var coverImageUrl: URL? {
        didSet {
            player?.currentPlayerManager.view.coverImageView.ext.setImage(with: coverImageUrl, placeholderImage: nil, isImageTransition: false)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 200))
        myView.backgroundColor = .orange
        addSubview(myView)
//        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//        layer.addSublayer(topGradientLayer)
//        layer.addSublayer(bottomGradientLayer)
//        
        addSubview(playSender)
        addSubview(sliderView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var min_x: CGFloat = 0
        var min_y: CGFloat = 0
        var min_w: CGFloat = 0
        var min_h: CGFloat = 0
        let min_view_w: CGFloat = self.ext.width
        let min_view_h: CGFloat = self.ext.height
        min_w = 100
        min_h = 100
        playSender.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
        playSender.center = self.center
        min_w = min_view_w;
        min_h = 1;
        min_x = 0;
        min_y = min_view_h - QYInch.tabbarDiffHeight - min_h;
        sliderView.frame = CGRect(x: min_x, y: min_y, width: min_w, height: min_h)
    }
    func reset() {
        playSender.isHidden = true
        sliderView.value = 0
        sliderView.bufferValue = 0
    }
    func showCoverView(with url: URL?) {
        self.player?.currentPlayerManager.view.coverImageView.ext.setImage(with: url, placeholderImage: nil, isImageTransition: false)
    }
    ///  加载状态改变
    func videoPlayer(_ videoPlayer: ZFPlayerController, loadStateChanged state: ZFPlayerLoadState) {
        if (state == .stalled || state == .prepare) && videoPlayer.currentPlayerManager.isPlaying {
            sliderView.startAnimating()
        } else {
            sliderView.stopAnimating()
        }
    }
    /// 播放进度改变回调
    func videoPlayer(_ videoPlayer: ZFPlayerController, currentTime: TimeInterval, totalTime: TimeInterval) {
        sliderView.value = videoPlayer.progress
    }
    func videoPlayer(_ videoPlayer: ZFPlayerController, bufferTime: TimeInterval) {
        sliderView.bufferValue = videoPlayer.bufferProgress
    }
    func gestureSingleTapped(_ gestureControl: ZFPlayerGestureControl) {
        guard let player = player else {
            return
        }
        if player.currentPlayerManager.isPlaying {
            player.currentPlayerManager.pause()
            playSender.isHidden = false
            playSender.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            UIView.animate(withDuration: 0.2) {
                self.playSender.transform = CGAffineTransform.identity
            }
        } else {
            player.currentPlayerManager.play()
            playSender.isHidden = true
        }
    }
}
