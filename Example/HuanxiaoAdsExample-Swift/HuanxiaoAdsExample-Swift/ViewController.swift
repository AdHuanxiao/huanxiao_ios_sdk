//
//  ViewController.swift
//  HuanxiaoAdsExample-Swift
//
//  HuanxiaoAds SDK Swift 官方示例
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

import UIKit
import HuanxiaoAds

// MARK: - 菜单项模型

class HXMenuItem {
    var title: String
    var subtitle: String
    var iconName: String?
    var showStatus: Bool
    var isInitialized: Bool
    var targetClass: UIViewController.Type?
    
    private init(title: String, subtitle: String, iconName: String? = nil, showStatus: Bool = false, targetClass: UIViewController.Type? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.showStatus = showStatus
        self.isInitialized = false
        self.targetClass = targetClass
    }
    
    static func item(title: String, subtitle: String, iconName: String, targetClass: UIViewController.Type) -> HXMenuItem {
        return HXMenuItem(title: title, subtitle: subtitle, iconName: iconName, targetClass: targetClass)
    }
    
    static func statusItem(title: String, subtitle: String) -> HXMenuItem {
        return HXMenuItem(title: title, subtitle: subtitle, showStatus: true)
    }
}

// MARK: - 菜单单元格

class HXMenuCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let statusDot = UIView()
    private let statusLabel = UILabel()
    private let arrowView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        selectionStyle = .none
        
        // 标题
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(white: 0.1, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 副标题
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // 状态圆点
        statusDot.layer.cornerRadius = 4
        statusDot.translatesAutoresizingMaskIntoConstraints = false
        statusDot.isHidden = true
        contentView.addSubview(statusDot)
        
        // 状态文字
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.isHidden = true
        contentView.addSubview(statusLabel)
        
        // 箭头
        arrowView.image = UIImage(systemName: "chevron.right")
        arrowView.tintColor = UIColor(white: 0.7, alpha: 1.0)
        arrowView.contentMode = .scaleAspectFit
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(arrowView)
        
        // 约束
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 12),
            arrowView.heightAnchor.constraint(equalToConstant: 16),
            
            statusLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -8),
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            statusDot.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -6),
            statusDot.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),
            statusDot.widthAnchor.constraint(equalToConstant: 8),
            statusDot.heightAnchor.constraint(equalToConstant: 8),
        ])
    }
    
    func configure(with item: HXMenuItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        
        if item.showStatus {
            statusDot.isHidden = false
            statusLabel.isHidden = false
            arrowView.isHidden = true
            
            if item.isInitialized {
                statusDot.backgroundColor = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0)
                statusLabel.text = "已初始化"
                statusLabel.textColor = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0)
            } else {
                statusDot.backgroundColor = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
                statusLabel.text = "未初始化"
                statusLabel.textColor = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
            }
        } else {
            statusDot.isHidden = true
            statusLabel.isHidden = true
            arrowView.isHidden = false
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = highlighted ? UIColor(white: 0.95, alpha: 1.0) : .white
    }
}

// MARK: - ViewController

class ViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var menuItems: [HXMenuItem] = []
    private var sdkStatusItem: HXMenuItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupData()
        setupTableView()
        
        // 监听 SDK 初始化完成通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateSDKStatus),
            name: NSNotification.Name("HXAdsSDKDidInitializeNotification"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSDKStatus()
    }
    
    private func setupNavigation() {
        title = "Huanxiao SDK"
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = UIColor(white: 0.9, alpha: 1.0)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupData() {
        sdkStatusItem = HXMenuItem.statusItem(title: "SDK 初始化状态", subtitle: "检查 SDK 是否正确初始化")
        
        menuItems = [
            sdkStatusItem,
            HXMenuItem.item(title: "开屏广告", subtitle: "Splash Ad - 应用启动时展示", iconName: "rectangle.portrait", targetClass: SplashAdViewController.self),
            HXMenuItem.item(title: "插屏广告", subtitle: "Interstitial Ad - 页面切换时展示", iconName: "rectangle.center.inset.filled", targetClass: InterstitialAdViewController.self),
            HXMenuItem.item(title: "信息流广告", subtitle: "Native Ad - 原生内容展示", iconName: "list.bullet.rectangle", targetClass: NativeAdViewController.self),
            HXMenuItem.item(title: "信息流广告 (列表)", subtitle: "Native Ad in TableView - 嵌入内容流展示", iconName: "list.bullet", targetClass: NativeAdTableViewController.self),
            HXMenuItem.item(title: "信息流广告 (瀑布流)", subtitle: "Native Ad Waterfall - 双列瀑布流展示", iconName: "square.grid.2x2", targetClass: NativeAdWaterfallViewController.self),
            HXMenuItem.item(title: "自渲染信息流", subtitle: "Custom Render Native Ad - 媒体自定义 UI", iconName: "paintbrush", targetClass: CustomRenderNativeAdViewController.self),
            HXMenuItem.item(title: "激励视频广告", subtitle: "Reward Video Ad - 观看获得奖励", iconName: "play.rectangle", targetClass: RewardVideoAdViewController.self),
        ]
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HXMenuCell.self, forCellReuseIdentifier: "HXMenuCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        // 添加 Footer
        let footerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        footerLabel.text = "SDK Version: \(HXAdsSDK.sdkVersion())"
        footerLabel.textAlignment = .center
        footerLabel.font = .systemFont(ofSize: 12)
        footerLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        tableView.tableFooterView = footerLabel
    }
    
    @objc private func updateSDKStatus() {
        sdkStatusItem.isInitialized = HXAdsSDK.sharedInstance().isInitialized
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // SDK 状态
        }
        return menuItems.count - 1 // 广告类型
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HXMenuCell", for: indexPath) as! HXMenuCell
        
        let itemIndex = (indexPath.section == 0) ? 0 : indexPath.row + 1
        let item = menuItems[itemIndex]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "状态"
        }
        return "广告类型"
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            // 点击 SDK 状态，刷新状态
            updateSDKStatus()
            return
        }
        
        let itemIndex = indexPath.row + 1
        let item = menuItems[itemIndex]
        
        if let targetClass = item.targetClass {
            let vc = targetClass.init()
            vc.title = item.title
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
