//
//  RewardVideoAdViewController.swift
//  HuanxiaoAdsExample-Swift
//
//  激励视频广告配置页
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

import UIKit
import HuanxiaoAds

class RewardVideoAdViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private weak var adSpotIDField: UITextField?
    private var rewardVideoAd: HXRewardVideoAd?
    private let statusLabel = UILabel()
    private let progressLabel = UILabel()
    private var shouldShowAfterLoad: Bool = false
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
        
        // 播放进度标签
        progressLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        progressLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        progressLabel.textAlignment = .center
        progressLabel.text = ""
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressLabel)
        
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
            
            progressLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
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
    
    private func updateProgress(_ progress: String) {
        DispatchQueue.main.async { [weak self] in
            self?.progressLabel.text = progress
        }
    }
    
    private var colorLoading: UIColor { UIColor(red: 0.95, green: 0.6, blue: 0.1, alpha: 1.0) }
    private var colorSuccess: UIColor { UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0) }
    private var colorError: UIColor { UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0) }
    private var colorGray: UIColor { UIColor(white: 0.5, alpha: 1.0) }
    private var colorReward: UIColor { UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0) }
    
    // MARK: - Actions
    
    private func loadAd() {
        dismissKeyboard()
        guard let adSpotID = adSpotIDField?.text, !adSpotID.isEmpty else {
            updateStatus("请输入广告位 ID", color: colorError)
            return
        }
        
        updateStatus("正在加载...", color: colorLoading)
        updateProgress("")
        
        shouldShowAfterLoad = false
        rewardVideoAd = HXRewardVideoAd(adSpotID: adSpotID)
        rewardVideoAd?.delegate = self
        rewardVideoAd?.videoMuted = isVideoMuted
        rewardVideoAd?.load()
    }
    
    private func showAd() {
        dismissKeyboard()
        guard let rewardVideoAd = rewardVideoAd, rewardVideoAd.isAdValid else {
            updateStatus("请先加载广告", color: colorError)
            return
        }
        
        updateStatus("正在展示...", color: colorLoading)
        rewardVideoAd.show(from: self)
    }
    
    private func loadAndShowAd() {
        dismissKeyboard()
        guard let adSpotID = adSpotIDField?.text, !adSpotID.isEmpty else {
            updateStatus("请输入广告位 ID", color: colorError)
            return
        }
        
        updateStatus("正在加载...", color: colorLoading)
        updateProgress("")
        
        shouldShowAfterLoad = true
        rewardVideoAd = HXRewardVideoAd(adSpotID: adSpotID)
        rewardVideoAd?.delegate = self
        rewardVideoAd?.videoMuted = isVideoMuted
        rewardVideoAd?.load()
    }
}

// MARK: - UITableViewDataSource

extension RewardVideoAdViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 3
    }
    
    @objc private func videoMuteSwitchChanged(_ sender: UISwitch) {
        isVideoMuted = sender.isOn
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HXAdConfigInputCell", for: indexPath) as! HXAdConfigInputCell
                cell.configure(title: "广告位 ID", placeholder: "请输入激励视频广告位 ID", text: "")
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
            return "用户观看完整视频后可获得奖励，适合游戏、积分场景"
        }
        return nil
    }
}

// MARK: - UITableViewDelegate

extension RewardVideoAdViewController: UITableViewDelegate {
    
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
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - HXRewardVideoAdDelegate - 加载

extension RewardVideoAdViewController: HXRewardVideoAdDelegate {
    
    // 广告加载成功
    func rewardVideoAdDidLoad(_ rewardVideoAd: HXRewardVideoAd) {
        if shouldShowAfterLoad {
            shouldShowAfterLoad = false
            updateStatus("加载成功，正在展示...", color: colorSuccess)
            rewardVideoAd.show(from: self)
        } else {
            updateStatus("广告加载成功，可点击展示", color: colorSuccess)
        }
    }
    
    // 广告加载失败
    func rewardVideoAd(_ rewardVideoAd: HXRewardVideoAd, didFailWithError error: Error) {
        shouldShowAfterLoad = false
        updateStatus("加载失败: \(error.localizedDescription)", color: colorError)
    }
    
    // MARK: - HXRewardVideoAdDelegate - 展示
    
    // 广告即将曝光
    func rewardVideoAdWillExpose(_ rewardVideoAd: HXRewardVideoAd) {
        updateStatus("广告即将展示", color: colorLoading)
    }
    
    // 广告曝光成功
    func rewardVideoAdDidExpose(_ rewardVideoAd: HXRewardVideoAd) {
        updateStatus("广告已曝光", color: colorSuccess)
    }
    
    // 广告展示失败
    func rewardVideoAd(_ rewardVideoAd: HXRewardVideoAd, didFailToShowWithError error: Error) {
        updateStatus("展示失败: \(error.localizedDescription)", color: colorError)
    }
    
    // MARK: - HXRewardVideoAdDelegate - 视频播放
    
    // 视频开始播放
    func rewardVideoAdDidStartPlay(_ rewardVideoAd: HXRewardVideoAd) {
        updateStatus("视频开始播放", color: colorSuccess)
    }
    
    // 视频播放进度
    func rewardVideoAd(_ rewardVideoAd: HXRewardVideoAd, playProgress progress: CGFloat, currentTime: TimeInterval, totalTime: TimeInterval) {
        let progressText = String(format: "%.0f%% | %.1fs / %.1fs", progress * 100, currentTime, totalTime)
        updateProgress(progressText)
    }
    
    // 视频播放完成
    func rewardVideoAdDidPlayFinish(_ rewardVideoAd: HXRewardVideoAd) {
        updateStatus("视频播放完成", color: colorSuccess)
    }
    
    // 视频播放失败
    func rewardVideoAd(_ rewardVideoAd: HXRewardVideoAd, didPlayFailWithError error: Error) {
        updateStatus("播放失败: \(error.localizedDescription)", color: colorError)
    }
    
    // MARK: - HXRewardVideoAdDelegate - 奖励
    
    // 用户获得奖励
    func rewardVideoAd(_ rewardVideoAd: HXRewardVideoAd, didRewardWith rewardInfo: HXRewardInfo) {
        if rewardInfo.isValid {
            let rewardText = "🎉 获得奖励: \(rewardInfo.rewardName) x\(rewardInfo.rewardAmount)"
            updateStatus(rewardText, color: colorReward)
        } else {
            updateStatus("奖励无效", color: colorGray)
        }
    }
    
    // MARK: - HXRewardVideoAdDelegate - 交互
    
    // 广告被点击
    func rewardVideoAdDidClick(_ rewardVideoAd: HXRewardVideoAd) {
        updateStatus("广告被点击", color: colorSuccess)
    }
    
    // 跳过按钮被点击
    func rewardVideoAdDidClickSkip(_ rewardVideoAd: HXRewardVideoAd) {
        updateStatus("用户点击跳过", color: colorGray)
    }
    
    // MARK: - HXRewardVideoAdDelegate - 关闭
    
    // 广告即将关闭
    func rewardVideoAdWillClose(_ rewardVideoAd: HXRewardVideoAd) {
        // 即将关闭
    }
    
    // 广告已关闭
    func rewardVideoAdDidClose(_ rewardVideoAd: HXRewardVideoAd) {
        updateStatus("广告已关闭", color: colorGray)
        updateProgress("")
    }
}
