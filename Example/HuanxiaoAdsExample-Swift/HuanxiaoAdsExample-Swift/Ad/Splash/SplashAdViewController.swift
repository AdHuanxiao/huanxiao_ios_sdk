//
//  SplashAdViewController.swift
//  HuanxiaoAdsExample-Swift
//
//  开屏广告配置页
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

import UIKit
import HuanxiaoAds

class SplashAdViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private weak var adSpotIDField: UITextField?
    private var splashAd: HXSplashAd?
    private let statusLabel = UILabel()
    
    // 连续展示相关
    private var splashAdQueue: [HXSplashAd] = []
    private var currentAdIndex: Int = 0
    private var isContinuousMode: Bool = false
    private var loadedAdCount: Int = 0
    private var totalAdCount: Int = 0
    private var isVideoMuted: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        
        // 状态标签
        statusLabel.font = .systemFont(ofSize: 15, weight: .medium)
        statusLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        statusLabel.textAlignment = .center
        statusLabel.text = "等待操作"
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HXAdConfigInputCell.self, forCellReuseIdentifier: "HXAdConfigInputCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActionCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func updateStatus(_ status: String, color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            self?.statusLabel.text = status
            self?.statusLabel.textColor = color
        }
    }
    
    private var colorLoading: UIColor { UIColor(red: 0.95, green: 0.6, blue: 0.1, alpha: 1.0) }
    private var colorSuccess: UIColor { UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0) }
    private var colorError: UIColor { UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0) }
    private var colorGray: UIColor { UIColor(white: 0.5, alpha: 1.0) }
    
    // MARK: - Actions
    
    private func loadAd() {
        dismissKeyboard()
        guard let adSpotID = adSpotIDField?.text, !adSpotID.isEmpty else {
            updateStatus("请输入广告位 ID", color: colorError)
            return
        }
        
        updateStatus("正在加载...", color: colorLoading)
        
        splashAd = HXSplashAd(adSpotID: adSpotID)
        splashAd?.delegate = self
        splashAd?.videoMuted = isVideoMuted
        splashAd?.load()
    }
    
    private func showAd() {
        guard let splashAd = splashAd, splashAd.isAdValid else {
            updateStatus("请先加载广告", color: colorError)
            return
        }
        
        guard let window = UIApplication.shared.windows.first else { return }
        splashAd.show(in: window)
    }
    
    private func loadAndShowAd() {
        dismissKeyboard()
        guard let adSpotID = adSpotIDField?.text, !adSpotID.isEmpty else {
            updateStatus("请输入广告位 ID", color: colorError)
            return
        }
        
        updateStatus("正在加载...", color: colorLoading)
        
        splashAd = HXSplashAd(adSpotID: adSpotID)
        splashAd?.delegate = self
        splashAd?.videoMuted = isVideoMuted
        
        guard let window = UIApplication.shared.windows.first else { return }
        splashAd?.loadAndShow(in: window)
    }
    
    private func loadAndShowAdWithBottomLogo() {
        dismissKeyboard()
        guard let adSpotID = adSpotIDField?.text, !adSpotID.isEmpty else {
            updateStatus("请输入广告位 ID", color: colorError)
            return
        }
        
        updateStatus("正在加载...", color: colorLoading)
        
        splashAd = HXSplashAd(adSpotID: adSpotID)
        splashAd?.delegate = self
        splashAd?.videoMuted = isVideoMuted
        
        // 创建底部 Logo 视图
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        
        // 获取 App Icon
        var appIcon: UIImage?
        if let infoPlist = Bundle.main.infoDictionary,
           let icons = infoPlist["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            appIcon = UIImage(named: lastIcon)
        }
        
        let logoImageView = UIImageView(image: appIcon)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = 12
        logoImageView.clipsToBounds = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 获取 App 名称
        let infoPlist = Bundle.main.infoDictionary
        let appName = (infoPlist?["CFBundleDisplayName"] as? String) ?? (infoPlist?["CFBundleName"] as? String) ?? ""
        
        let logoLabel = UILabel()
        logoLabel.text = appName
        logoLabel.font = .systemFont(ofSize: 14, weight: .medium)
        logoLabel.textColor = UIColor(white: 0.3, alpha: 1.0)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 容器视图用于整体居中
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(containerView)
        
        containerView.addSubview(logoImageView)
        containerView.addSubview(logoLabel)
        
        NSLayoutConstraint.activate([
            // 容器整体居中
            containerView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            
            // Logo 在容器顶部居中
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Label 在 Logo 下方居中
            logoLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            logoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        splashAd?.bottomView = bottomView
        splashAd?.bottomViewHeight = 180
        
        guard let window = UIApplication.shared.windows.first else { return }
        splashAd?.loadAndShow(in: window)
    }
    
    private func loadAndShowContinuousAds() {
        dismissKeyboard()
        guard let adSpotID = adSpotIDField?.text, !adSpotID.isEmpty else {
            updateStatus("请输入广告位 ID", color: colorError)
            return
        }
        
        // 初始化连续展示状态
        isContinuousMode = true
        currentAdIndex = 0
        loadedAdCount = 0
        totalAdCount = 3
        splashAdQueue = []
        
        updateStatus("正在加载 3 个广告...", color: colorLoading)
        
        // 创建并加载 3 个广告
        for _ in 0..<totalAdCount {
            guard let ad = HXSplashAd(adSpotID: adSpotID) else { continue }
            ad.delegate = self
            ad.videoMuted = isVideoMuted
            splashAdQueue.append(ad)
            ad.load()
        }
    }
    
    private func showNextAdInQueue() {
        if currentAdIndex >= splashAdQueue.count {
            // 所有广告已展示完毕
            isContinuousMode = false
            updateStatus("连续展示完成", color: colorSuccess)
            splashAdQueue.removeAll()
            return
        }
        
        let nextAd = splashAdQueue[currentAdIndex]
        if nextAd.isAdValid {
            updateStatus("正在展示第 \(currentAdIndex + 1)/\(totalAdCount) 个广告", color: colorLoading)
            guard let window = UIApplication.shared.windows.first else { return }
            nextAd.show(in: window)
        } else {
            // 当前广告无效，跳到下一个
            currentAdIndex += 1
            showNextAdInQueue()
        }
    }
}

// MARK: - UITableViewDataSource

extension SplashAdViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 5
    }
    
    @objc private func videoMuteSwitchChanged(_ sender: UISwitch) {
        isVideoMuted = sender.isOn
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HXAdConfigInputCell", for: indexPath) as! HXAdConfigInputCell
                cell.configure(title: "广告位 ID", placeholder: "请输入开屏广告位 ID", text: "")
                adSpotIDField = cell.textField
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "视频静音播放"
                cell.textLabel?.font = .systemFont(ofSize: 16)
                cell.selectionStyle = .none
                let muteSwitch = UISwitch()
                muteSwitch.isOn = isVideoMuted
                muteSwitch.addTarget(self, action: #selector(videoMuteSwitchChanged(_:)), for: .valueChanged)
                cell.accessoryView = muteSwitch
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell", for: indexPath)
        cell.textLabel?.textColor = UIColor(red: 0.2, green: 0.47, blue: 0.96, alpha: 1.0)
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "加载广告"
        case 1:
            cell.textLabel?.text = "展示广告"
        case 2:
            cell.textLabel?.text = "加载并展示广告"
        case 3:
            cell.textLabel?.text = "加载并展示（带底部 Logo）"
        case 4:
            cell.textLabel?.text = "开屏广告连续触发（3个）"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "基础配置" : "操作"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "请在 Huanxiao开发者后台创建广告位获取 ID"
        }
        return nil
    }
}

// MARK: - UITableViewDelegate

extension SplashAdViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                loadAd()
            case 1:
                showAd()
            case 2:
                loadAndShowAd()
            case 3:
                loadAndShowAdWithBottomLogo()
            case 4:
                loadAndShowContinuousAds()
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - HXSplashAdDelegate

extension SplashAdViewController: HXSplashAdDelegate {
    
    // 广告加载成功
    func splashAdDidLoad(_ splashAd: HXSplashAd) {
        if isContinuousMode {
            loadedAdCount += 1
            updateStatus("已加载 \(loadedAdCount)/\(totalAdCount) 个广告", color: colorLoading)
            
            // 所有广告加载完成后开始展示
            if loadedAdCount >= totalAdCount {
                updateStatus("全部加载完成，开始连续展示", color: colorSuccess)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.showNextAdInQueue()
                }
            }
        } else {
            updateStatus("广告加载成功，可点击展示", color: colorSuccess)
        }
    }
    
    // 广告加载失败
    func splashAd(_ splashAd: HXSplashAd, didFailWithError error: Error) {
        if isContinuousMode {
            loadedAdCount += 1
            updateStatus("第 \(loadedAdCount) 个广告加载失败: \(error.localizedDescription)", color: colorError)
            
            // 即使有广告加载失败，也尝试展示已加载成功的广告
            if loadedAdCount >= totalAdCount {
                let hasValidAd = splashAdQueue.contains { $0.isAdValid }
                if hasValidAd {
                    updateStatus("部分广告加载完成，开始连续展示", color: colorLoading)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        self?.showNextAdInQueue()
                    }
                } else {
                    isContinuousMode = false
                    updateStatus("所有广告加载失败", color: colorError)
                    splashAdQueue.removeAll()
                }
            }
        } else {
            updateStatus("加载失败: \(error.localizedDescription)", color: colorError)
        }
    }
    
    // 广告即将曝光
    func splashAdWillExpose(_ splashAd: HXSplashAd) {
        updateStatus("广告即将曝光", color: colorLoading)
    }
    
    // 广告曝光成功
    func splashAdDidExpose(_ splashAd: HXSplashAd) {
        updateStatus("广告已曝光", color: colorSuccess)
    }
    
    // 广告展示失败
    func splashAd(_ splashAd: HXSplashAd, didFailToShowWithError error: Error) {
        updateStatus("展示失败: \(error.localizedDescription)", color: colorError)
    }
    
    // 广告被点击
    func splashAdDidClick(_ splashAd: HXSplashAd) {
        updateStatus("广告被点击", color: colorSuccess)
    }
    
    // 跳过按钮被点击
    func splashAdDidClickSkip(_ splashAd: HXSplashAd) {
        updateStatus("用户点击跳过", color: colorGray)
    }
    
    // 广告即将关闭
    func splashAdWillClose(_ splashAd: HXSplashAd) {
        updateStatus("广告即将关闭", color: colorLoading)
    }
    
    // 广告已关闭
    func splashAdDidClose(_ splashAd: HXSplashAd) {
        if isContinuousMode {
            updateStatus("第 \(currentAdIndex + 1)/\(totalAdCount) 个广告已关闭", color: colorGray)
            currentAdIndex += 1
            // 延迟一小段时间后展示下一个广告
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.showNextAdInQueue()
            }
        } else {
            updateStatus("广告已关闭", color: colorGray)
            self.splashAd = nil
        }
    }
}
