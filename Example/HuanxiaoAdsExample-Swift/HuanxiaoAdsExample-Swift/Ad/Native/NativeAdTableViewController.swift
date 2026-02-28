//
//  NativeAdTableViewController.swift
//  HuanxiaoAdsExample-Swift
//
//  信息流广告列表展示页
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

import UIKit
import HuanxiaoAds

// MARK: - 内容单元格

private class HXContentCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let coverImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(white: 0.1, alpha: 1.0)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        coverImageView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 6
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coverImageView)
        
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            coverImageView.widthAnchor.constraint(equalToConstant: 100),
            coverImageView.heightAnchor.constraint(equalToConstant: 70),
            coverImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: coverImageView.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    func configure(title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
        coverImageView.backgroundColor = UIColor(
            hue: CGFloat(arc4random() % 100) / 100.0,
            saturation: 0.3,
            brightness: 0.9,
            alpha: 1.0
        )
    }
}

// MARK: - 广告单元格

private class HXNativeAdCell: UITableViewCell {
    
    let adContainerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .white
        
        adContainerView.backgroundColor = .white
        adContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adContainerView)
        
        NSLayoutConstraint.activate([
            adContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            adContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            adContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        adContainerView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func configure(with adView: UIView?) {
        adContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        if let adView = adView {
            adView.translatesAutoresizingMaskIntoConstraints = false
            adContainerView.addSubview(adView)
            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: adContainerView.topAnchor),
                adView.leadingAnchor.constraint(equalTo: adContainerView.leadingAnchor),
                adView.trailingAnchor.constraint(equalTo: adContainerView.trailingAnchor),
                adView.bottomAnchor.constraint(equalTo: adContainerView.bottomAnchor),
            ])
        }
    }
}

// MARK: - 数据模型

private enum HXFeedItemType {
    case content
    case ad
}

private class HXFeedItem {
    var type: HXFeedItemType = .content
    var title: String = ""
    var content: String = ""
    var nativeAd: HXNativeAd?
    var adHeight: CGFloat = 0
}

// MARK: - NativeAdTableViewController

class NativeAdTableViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var feedItems: [HXFeedItem] = []
    private let statusLabel = UILabel()
    private let adSpotID = "1010" // 设置广告位 ID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        loadAds()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        
        // 状态标签
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        statusLabel.textAlignment = .center
        statusLabel.text = "正在加载广告..."
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HXContentCell.self, forCellReuseIdentifier: "ContentCell")
        tableView.register(HXNativeAdCell.self, forCellReuseIdentifier: "AdCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        // 刷新按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadAds))
    }
    
    private func setupData() {
        feedItems = []
        
        // 模拟内容数据
        let titles = [
            "Swift 5.9 新特性解析：宏系统与性能优化",
            "iOS 26 适配指南：隐私权限变更详解",
            "SwiftUI 动画进阶：自定义转场效果",
            "Core Data 与 SwiftData 迁移实践",
            "Metal 3 图形渲染性能调优技巧",
            "Combine 框架深度解析与实战应用",
            "Widget 开发指南：从入门到精通",
            "App Clip 最佳实践与用户体验优化",
            "Xcode Cloud 持续集成完整指南",
            "ARKit 6 新功能与场景理解技术",
            "Vision Pro 开发入门：空间计算基础",
            "性能监控与崩溃分析最佳实践",
        ]
        
        for (i, title) in titles.enumerated() {
            let item = HXFeedItem()
            item.type = .content
            item.title = title
            item.content = "技术资讯 · 5分钟阅读"
            feedItems.append(item)
            
            // 每隔 3 条内容插入一个广告位
            if (i + 1) % 3 == 0 && i < titles.count - 1 {
                let adItem = HXFeedItem()
                adItem.type = .ad
                adItem.adHeight = 0 // 初始高度为 0，加载后更新
                feedItems.append(adItem)
            }
        }
    }
    
    @objc private func loadAds() {
        guard !adSpotID.isEmpty else {
            statusLabel.text = "请在代码中设置广告位 ID"
            statusLabel.textColor = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
            return
        }
        
        statusLabel.text = "正在加载广告..."
        statusLabel.textColor = UIColor(red: 0.95, green: 0.6, blue: 0.1, alpha: 1.0)
        
        let adWidth = view.bounds.width - 12 * 2
        
        for item in feedItems {
            if item.type == .ad {
                // 清理旧广告
                item.nativeAd?.close()
                item.nativeAd = nil
                
                // 创建新广告
                let nativeAd = HXNativeAd(adSpotID: adSpotID, size: CGSize(width: adWidth, height: 0))
                nativeAd?.delegate = self
                item.nativeAd = nativeAd
                nativeAd?.load()
            }
        }
    }
    
    private func updateStatus(_ status: String, color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            self?.statusLabel.text = status
            self?.statusLabel.textColor = color
        }
    }
}

// MARK: - UITableViewDataSource

extension NativeAdTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = feedItems[indexPath.row]
        
        if item.type == .ad {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdCell", for: indexPath) as! HXNativeAdCell
            if let nativeAd = item.nativeAd {
                cell.configure(with: nativeAd.adView)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! HXContentCell
            cell.configure(title: item.title, content: item.content)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension NativeAdTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = feedItems[indexPath.row]
        if item.type == .ad {
            return item.adHeight > 0 ? item.adHeight : 0.01 // 返回极小值避免空白
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = feedItems[indexPath.row]
        if item.type == .ad {
            return item.adHeight > 0 ? item.adHeight : 200
        }
        return 94
    }
}

// MARK: - HXNativeAdDelegate

extension NativeAdTableViewController: HXNativeAdDelegate {
    
    func nativeAdDidLoad(_ nativeAd: HXNativeAd) {
        updateStatus("广告加载成功", color: UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0))
        
        // 找到对应的 item 并刷新
        for (i, item) in feedItems.enumerated() {
            if item.nativeAd === nativeAd {
                tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .fade)
                break
            }
        }
    }
    
    func nativeAd(_ nativeAd: HXNativeAd, didFailWithError error: Error) {
        updateStatus("加载失败: \(error.localizedDescription)", color: UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0))
    }
    
    func nativeAdDidExpose(_ nativeAd: HXNativeAd) {
        print("信息流广告已曝光")
    }
    
    func nativeAdDidClick(_ nativeAd: HXNativeAd) {
        print("信息流广告被点击")
    }
    
    func nativeAdDidClose(_ nativeAd: HXNativeAd) {
        // 找到对应的广告 item，重置状态（保留槽位，刷新时可重新加载）
        for (i, item) in feedItems.enumerated() {
            if item.nativeAd === nativeAd {
                item.nativeAd?.close()
                item.nativeAd = nil
                item.adHeight = 0
                tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .fade)
                break
            }
        }
    }
    
    func nativeAd(_ nativeAd: HXNativeAd, didCalculateRecommendedHeight recommendedHeight: CGFloat) {
        // 更新广告高度并刷新
        for (i, item) in feedItems.enumerated() {
            if item.nativeAd === nativeAd {
                item.adHeight = recommendedHeight
                tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .none)
                break
            }
        }
    }
}
