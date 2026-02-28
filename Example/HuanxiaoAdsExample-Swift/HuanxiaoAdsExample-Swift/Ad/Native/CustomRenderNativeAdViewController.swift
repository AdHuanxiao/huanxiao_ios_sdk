//
//  CustomRenderNativeAdViewController.swift
//  HuanxiaoAdsExample-Swift
//
//  自渲染信息流广告测试页面
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

import UIKit
import HuanxiaoAds

class CustomRenderNativeAdViewController: UIViewController {
    
    // MARK: - 输入区域
    private let adSpotTextField = UITextField()
    private let loadButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    
    // MARK: - 广告容器
    private let scrollView = UIScrollView()
    private let adContainerView = UIView()
    
    // MARK: - 自渲染 UI 组件
    private var customAdView: UIView?
    private var mainImageView: UIImageView?
    private var iconImageView: UIImageView?
    private var titleLabel: UILabel?
    private var descLabel: UILabel?
    private var ctaButton: UIButton?
    private var adBadgeContainer: UIView?
    private var adBadgeIconView: UIImageView?
    private var adBadgeLabel: UILabel?
    private var interactionHintView: UIView?
    private var interactionHintLabel: UILabel?
    private var closeButton: UIButton?
    private var videoContainerView: UIView?
    private var muteButton: UIButton?
    private var isMuted: Bool = false
    
    // MARK: - 广告对象
    private var nativeAd: HXNativeAd?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        title = "自渲染信息流"
        
        setupInputArea()
        setupScrollView()
        setupAdContainer()
    }
    
    deinit {
        nativeAd?.close()
        nativeAd = nil
        print("[CustomRenderNativeAd] ViewController deinit")
    }
    
    // MARK: - UI Setup
    
    private func setupInputArea() {
        // 输入框
        adSpotTextField.placeholder = "请输入广告位 ID"
        adSpotTextField.borderStyle = .roundedRect
        adSpotTextField.font = .systemFont(ofSize: 15)
        adSpotTextField.clearButtonMode = .whileEditing
        adSpotTextField.returnKeyType = .done
        adSpotTextField.delegate = self
        adSpotTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adSpotTextField)
        
        // 加载按钮
        loadButton.setTitle("加载广告", for: .normal)
        loadButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        loadButton.backgroundColor = .systemBlue
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.layer.cornerRadius = 8
        loadButton.addTarget(self, action: #selector(loadAdButtonTapped), for: .touchUpInside)
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadButton)
        
        // 状态标签
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.textColor = .gray
        statusLabel.textAlignment = .center
        statusLabel.text = "请输入广告位 ID 后点击加载"
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            adSpotTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            adSpotTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            adSpotTextField.heightAnchor.constraint(equalToConstant: 44),
            
            loadButton.leadingAnchor.constraint(equalTo: adSpotTextField.trailingAnchor, constant: 12),
            loadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loadButton.centerYAnchor.constraint(equalTo: adSpotTextField.centerYAnchor),
            loadButton.widthAnchor.constraint(equalToConstant: 90),
            loadButton.heightAnchor.constraint(equalToConstant: 44),
            
            statusLabel.topAnchor.constraint(equalTo: adSpotTextField.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupScrollView() {
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupAdContainer() {
        adContainerView.backgroundColor = .clear
        adContainerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(adContainerView)
        
        NSLayoutConstraint.activate([
            adContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            adContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            adContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            adContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func loadAdButtonTapped() {
        view.endEditing(true)
        
        guard let adSpotID = adSpotTextField.text, !adSpotID.isEmpty else {
            statusLabel.text = "请输入广告位 ID"
            statusLabel.textColor = .red
            return
        }
        
        // 清除旧广告
        clearOldAd()
        
        statusLabel.text = "正在加载..."
        statusLabel.textColor = .gray
        loadButton.isEnabled = false
        
        // 创建自渲染广告
        let adWidth = view.bounds.width - 32
        nativeAd = HXNativeAd(adSpotID: adSpotID, size: CGSize(width: adWidth, height: 0))
        nativeAd?.renderMode = .custom  // 关键：设置为自渲染模式
        nativeAd?.delegate = self
        
        nativeAd?.load()
        
        print("[CustomRenderNativeAd] 开始加载广告: \(adSpotID)")
    }
    
    private func clearOldAd() {
        nativeAd?.close()
        nativeAd = nil
        
        customAdView?.removeFromSuperview()
        customAdView = nil
    }
    
    @objc private func closeButtonTapped() {
        print("[CustomRenderNativeAd] 关闭按钮点击")
        nativeAd?.close()
    }
    
    @objc private func muteButtonTapped() {
        isMuted = !isMuted
        nativeAd?.videoMuted = isMuted
        updateMuteButtonIcon()
        print("[CustomRenderNativeAd] 静音状态: \(isMuted ? "静音" : "有声")")
    }
    
    private func updateMuteButtonIcon() {
        let iconName = isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill"
        let icon = UIImage(systemName: iconName)
        muteButton?.setImage(icon, for: .normal)
        muteButton?.tintColor = .white
    }
    
    // MARK: - 自渲染 UI 构建
    
    private func buildCustomAdView(with data: HXNativeAdRenderData) {
        let containerWidth = view.bounds.width - 32
        
        // 创建广告容器
        let adView = UIView()
        adView.backgroundColor = .white
        adView.layer.cornerRadius = 12
        adView.layer.shadowColor = UIColor.black.cgColor
        adView.layer.shadowOffset = CGSize(width: 0, height: 2)
        adView.layer.shadowOpacity = 0.1
        adView.layer.shadowRadius = 8
        adView.clipsToBounds = false
        adView.translatesAutoresizingMaskIntoConstraints = false
        adContainerView.addSubview(adView)
        customAdView = adView
        
        // 内容容器（用于裁剪圆角）
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        adView.addSubview(contentView)
        
        var imageHeight: CGFloat = 0
        var topView: UIView!
        
        if data.isVideoAd {
            // 视频广告：创建视频容器
            let videoContainer = UIView()
            videoContainer.backgroundColor = .black
            videoContainer.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(videoContainer)
            videoContainerView = videoContainer
            topView = videoContainer
            
            imageHeight = containerWidth * 9.0 / 16.0 // 16:9 比例
            
            // 静音按钮
            isMuted = data.videoMuted
            let mute = UIButton(type: .custom)
            mute.backgroundColor = UIColor(white: 0, alpha: 0.5)
            mute.layer.cornerRadius = 16
            mute.clipsToBounds = true
            mute.addTarget(self, action: #selector(muteButtonTapped), for: .touchUpInside)
            mute.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(mute)
            muteButton = mute
            updateMuteButtonIcon()  // 必须在 muteButton 赋值后调用
            
            NSLayoutConstraint.activate([
                videoContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
                videoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                videoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                videoContainer.heightAnchor.constraint(equalToConstant: imageHeight),
                
                // 静音按钮：视频区域右下角
                mute.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -12),
                mute.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -12),
                mute.widthAnchor.constraint(equalToConstant: 32),
                mute.heightAnchor.constraint(equalToConstant: 32),
            ])
        } else {
            // 图片广告：主图
            let mainImage = UIImageView()
            mainImage.contentMode = .scaleAspectFill
            mainImage.clipsToBounds = true
            mainImage.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            mainImage.image = data.mainImage
            mainImage.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(mainImage)
            mainImageView = mainImage
            topView = mainImage
            
            // 计算图片高度
            if data.imageRatio > 0 {
                imageHeight = containerWidth / data.imageRatio
            } else {
                imageHeight = containerWidth * 9.0 / 16.0
            }
            
            NSLayoutConstraint.activate([
                mainImage.topAnchor.constraint(equalTo: contentView.topAnchor),
                mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                mainImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                mainImage.heightAnchor.constraint(equalToConstant: imageHeight),
            ])
        }
        
        // 广告标识（合规必须）- 放在图片/视频上层
        let badgeContainer = UIView()
        badgeContainer.backgroundColor = UIColor(white: 0, alpha: 0.6)
        badgeContainer.layer.cornerRadius = 4
        badgeContainer.clipsToBounds = true
        badgeContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(badgeContainer)
        adBadgeContainer = badgeContainer
        
        // 广告标识图标
        let badgeIcon = UIImageView()
        badgeIcon.contentMode = .scaleAspectFit
        badgeIcon.tintColor = .white
        badgeIcon.translatesAutoresizingMaskIntoConstraints = false
        badgeContainer.addSubview(badgeIcon)
        adBadgeIconView = badgeIcon
        
        // 设置图标：优先使用 SDK 返回的图标，否则使用系统图标
        if let icon = data.adBadgeIcon {
            badgeIcon.image = icon
        } else {
            badgeIcon.image = UIImage(systemName: "info.circle.fill")
        }
        
        // 广告标识文字
        let badgeLabel = UILabel()
        badgeLabel.text = data.adBadgeText.isEmpty ? "广告" : data.adBadgeText
        badgeLabel.font = .systemFont(ofSize: 10, weight: .medium)
        badgeLabel.textColor = .white
        badgeLabel.textAlignment = .center
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeContainer.addSubview(badgeLabel)
        adBadgeLabel = badgeLabel
        
        // 广告标识内边距约束（图标 + 文字）
        NSLayoutConstraint.activate([
            // 图标
            badgeIcon.leadingAnchor.constraint(equalTo: badgeContainer.leadingAnchor, constant: 4),
            badgeIcon.centerYAnchor.constraint(equalTo: badgeContainer.centerYAnchor),
            badgeIcon.widthAnchor.constraint(equalToConstant: 10),
            badgeIcon.heightAnchor.constraint(equalToConstant: 10),
            
            // 文字
            badgeLabel.topAnchor.constraint(equalTo: badgeContainer.topAnchor, constant: 2),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor, constant: -2),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeIcon.trailingAnchor, constant: 3),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeContainer.trailingAnchor, constant: -5),
        ])
        
        // 关闭按钮 - 放在图片/视频上层
        let close = UIButton(type: .custom)
        close.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        close.tintColor = UIColor(white: 1, alpha: 0.8)
        close.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        close.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(close)
        closeButton = close
        
        // 交互提示（如果有）
        if let hintText = data.interactionHintText, !hintText.isEmpty {
            let hintView = UIView()
            hintView.backgroundColor = UIColor(white: 0, alpha: 0.6)
            hintView.layer.cornerRadius = 4
            hintView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(hintView)
            interactionHintView = hintView
            
            let hintLabel = UILabel()
            hintLabel.text = hintText
            hintLabel.font = .systemFont(ofSize: 12)
            hintLabel.textColor = .white
            hintLabel.translatesAutoresizingMaskIntoConstraints = false
            hintView.addSubview(hintLabel)
            interactionHintLabel = hintLabel
            
            NSLayoutConstraint.activate([
                hintView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -12),
                hintView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                
                hintLabel.topAnchor.constraint(equalTo: hintView.topAnchor, constant: 6),
                hintLabel.bottomAnchor.constraint(equalTo: hintView.bottomAnchor, constant: -6),
                hintLabel.leadingAnchor.constraint(equalTo: hintView.leadingAnchor, constant: 12),
                hintLabel.trailingAnchor.constraint(equalTo: hintView.trailingAnchor, constant: -12),
            ])
        }
        
        // 底部信息区
        let infoView = UIView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoView)
        
        // 图标
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 6
        icon.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        icon.image = data.iconImage ?? data.appIcon
        icon.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(icon)
        iconImageView = icon
        
        // 标题
        let title = UILabel()
        title.text = data.title
        title.font = .systemFont(ofSize: 15, weight: .medium)
        title.textColor = UIColor(white: 0.1, alpha: 1.0)
        title.numberOfLines = 1
        title.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(title)
        titleLabel = title
        
        // 描述
        let desc = UILabel()
        desc.text = data.desc
        desc.font = .systemFont(ofSize: 13)
        desc.textColor = UIColor(white: 0.5, alpha: 1.0)
        desc.numberOfLines = 2
        desc.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(desc)
        descLabel = desc
        
        // CTA 按钮
        let cta = UIButton(type: .system)
        cta.setTitle(data.ctaText, for: .normal)
        cta.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        cta.backgroundColor = .systemBlue
        cta.setTitleColor(.white, for: .normal)
        cta.layer.cornerRadius = 6
        cta.isUserInteractionEnabled = false // 点击由 SDK 处理
        cta.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(cta)
        ctaButton = cta
        
        NSLayoutConstraint.activate([
            // 广告容器
            adView.topAnchor.constraint(equalTo: adContainerView.topAnchor),
            adView.leadingAnchor.constraint(equalTo: adContainerView.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: adContainerView.trailingAnchor),
            
            // 内容容器
            contentView.topAnchor.constraint(equalTo: adView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: adView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: adView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: adView.bottomAnchor),
            
            // 广告标识容器
            badgeContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            badgeContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            // 关闭按钮
            close.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            close.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            close.widthAnchor.constraint(equalToConstant: 24),
            close.heightAnchor.constraint(equalToConstant: 24),
            
            // 底部信息区
            infoView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 12),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // 图标
            icon.topAnchor.constraint(equalTo: infoView.topAnchor),
            icon.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            icon.widthAnchor.constraint(equalToConstant: 44),
            icon.heightAnchor.constraint(equalToConstant: 44),
            
            // 标题
            title.topAnchor.constraint(equalTo: infoView.topAnchor),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: cta.leadingAnchor, constant: -10),
            
            // 描述
            desc.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            desc.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            desc.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            desc.bottomAnchor.constraint(lessThanOrEqualTo: infoView.bottomAnchor),
            
            // CTA 按钮
            cta.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            cta.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            cta.widthAnchor.constraint(equalToConstant: 80),
            cta.heightAnchor.constraint(equalToConstant: 32),
            
            // 广告容器底部
            adView.bottomAnchor.constraint(equalTo: adContainerView.bottomAnchor),
        ])
        
        view.layoutIfNeeded()
        
        print("[CustomRenderNativeAd] 自渲染 UI 构建完成，isVideoAd: \(data.isVideoAd)")
    }
}

// MARK: - HXNativeAdDelegate

extension CustomRenderNativeAdViewController: HXNativeAdDelegate {
    
    func nativeAdDidLoad(_ nativeAd: HXNativeAd) {
        print("[CustomRenderNativeAd] 广告加载成功")
        
        loadButton.isEnabled = true
        statusLabel.text = "加载成功，正在渲染..."
        statusLabel.textColor = UIColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0)
        
        // 获取自渲染数据
        guard let renderData = nativeAd.renderData else {
            statusLabel.text = "渲染数据为空"
            statusLabel.textColor = .red
            return
        }
        
        print("[CustomRenderNativeAd] 渲染数据: title=\(renderData.title ?? ""), desc=\(renderData.desc ?? ""), isVideoAd=\(renderData.isVideoAd), interactionType=\(renderData.interactionType)")
        
        // 构建自渲染 UI
        buildCustomAdView(with: renderData)
        
        // 绑定视图给 SDK
        let customViews = HXNativeAdCustomViews()
        customViews.titleLabel = titleLabel
        customViews.descLabel = descLabel
        customViews.mainImageView = mainImageView
        customViews.iconImageView = iconImageView
        customViews.actionButton = ctaButton
        customViews.adBadgeView = adBadgeContainer        // 合规必须
        customViews.interactionHintView = interactionHintView
        customViews.closeButton = closeButton
        customViews.clickableView = customAdView         // 整个广告区域可点击
        
        if renderData.isVideoAd {
            customViews.videoContainerView = videoContainerView
        }
        
        nativeAd.bindCustomViews(customViews, container: customAdView!, rootViewController: self)
        
        statusLabel.text = "渲染完成，等待曝光..."
    }
    
    func nativeAd(_ nativeAd: HXNativeAd, didFailWithError error: Error) {
        print("[CustomRenderNativeAd] 广告加载失败: \(error.localizedDescription)")
        
        loadButton.isEnabled = true
        statusLabel.text = "加载失败: \(error.localizedDescription)"
        statusLabel.textColor = .red
    }
    
    func nativeAdDidExpose(_ nativeAd: HXNativeAd) {
        print("[CustomRenderNativeAd] 广告曝光")
        statusLabel.text = "广告已曝光"
        statusLabel.textColor = UIColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0)
    }
    
    func nativeAdDidClick(_ nativeAd: HXNativeAd) {
        print("[CustomRenderNativeAd] 广告点击")
        statusLabel.text = "广告被点击"
    }
    
    func nativeAdDidClose(_ nativeAd: HXNativeAd) {
        print("[CustomRenderNativeAd] 广告关闭")
        statusLabel.text = "广告已关闭"
        
        customAdView?.removeFromSuperview()
        customAdView = nil
        self.nativeAd = nil
    }
    
    func nativeAd(_ nativeAd: HXNativeAd, didCalculateRecommendedHeight recommendedHeight: CGFloat) {
        print("[CustomRenderNativeAd] 推荐高度: \(recommendedHeight)")
    }
}

// MARK: - UITextFieldDelegate

extension CustomRenderNativeAdViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
