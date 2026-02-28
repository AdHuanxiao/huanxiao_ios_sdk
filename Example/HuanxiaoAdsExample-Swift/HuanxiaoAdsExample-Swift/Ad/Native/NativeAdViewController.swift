//
//  NativeAdViewController.swift
//  HuanxiaoAdsExample-Swift
//
//  信息流广告配置页
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

import UIKit
import HuanxiaoAds

class NativeAdViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private weak var adSpotIDField: UITextField?
    private var nativeAd: HXNativeAd?
    private let statusLabel = UILabel()
    private let adContainerView = UIView()
    private var adContainerHeightConstraint: NSLayoutConstraint!
    private var isVideoMuted: Bool = true  // 信息流默认静音
    
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
        
        // 广告容器
        adContainerView.backgroundColor = .white
        adContainerView.layer.cornerRadius = 12
        adContainerView.layer.shadowColor = UIColor.black.cgColor
        adContainerView.layer.shadowOpacity = 0.1
        adContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        adContainerView.layer.shadowRadius = 8
        adContainerView.clipsToBounds = false
        adContainerView.translatesAutoresizingMaskIntoConstraints = false
        adContainerView.isHidden = true
        view.addSubview(adContainerView)
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HXAdConfigInputCell.self, forCellReuseIdentifier: "HXAdConfigInputCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActionCell")
        view.addSubview(tableView)
        
        adContainerHeightConstraint = adContainerView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            adContainerView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12),
            adContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            adContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            adContainerHeightConstraint,
            
            tableView.topAnchor.constraint(equalTo: adContainerView.bottomAnchor, constant: 8),
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
        
        // 清除之前的广告
        clearAd()
        
        updateStatus("正在加载...", color: colorLoading)
        
        // 计算广告宽度
        let adWidth = view.bounds.width - 32
        
        nativeAd = HXNativeAd(adSpotID: adSpotID, size: CGSize(width: adWidth, height: 0))
        nativeAd?.videoMuted = isVideoMuted
        nativeAd?.delegate = self
        nativeAd?.load()
    }
    
    private func clearAd() {
        // 移除现有广告视图
        adContainerView.subviews.forEach { $0.removeFromSuperview() }
        adContainerView.isHidden = true
        adContainerHeightConstraint.constant = 0
        
        nativeAd?.close()
        nativeAd = nil
    }
}

// MARK: - UITableViewDataSource

extension NativeAdViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 2
    }
    
    @objc private func videoMuteSwitchChanged(_ sender: UISwitch) {
        isVideoMuted = sender.isOn
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HXAdConfigInputCell", for: indexPath) as! HXAdConfigInputCell
                cell.configure(title: "广告位 ID", placeholder: "请输入信息流广告位 ID", text: "")
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
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "加载广告"
            cell.textLabel?.textColor = UIColor(red: 0.2, green: 0.47, blue: 0.96, alpha: 1.0)
        case 1:
            cell.textLabel?.text = "清除广告"
            cell.textLabel?.textColor = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
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
            return "信息流广告可融入内容流中展示，支持多种模板样式"
        }
        return nil
    }
}

// MARK: - UITableViewDelegate

extension NativeAdViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                loadAd()
            case 1:
                clearAd()
                updateStatus("广告已清除", color: colorGray)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - HXNativeAdDelegate

extension NativeAdViewController: HXNativeAdDelegate {
    
    // 广告加载成功
    func nativeAdDidLoad(_ nativeAd: HXNativeAd) {
        updateStatus("广告加载成功", color: colorSuccess)
        
        // 获取广告视图并添加到容器
        if let adView = nativeAd.adView {
            adContainerView.isHidden = false
            adView.translatesAutoresizingMaskIntoConstraints = false
            adView.layer.cornerRadius = 12
            adView.clipsToBounds = true
            adContainerView.addSubview(adView)
            
            // 使用广告视图自身的尺寸（不强制拉伸）
            let adWidth = adView.frame.width
            let adHeight = adView.frame.height
            
            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: adContainerView.topAnchor),
                adView.centerXAnchor.constraint(equalTo: adContainerView.centerXAnchor),
                adView.widthAnchor.constraint(equalToConstant: adWidth),
                adView.heightAnchor.constraint(equalToConstant: adHeight),
            ])
            
            // 直接使用广告视图的高度更新容器高度
            adContainerHeightConstraint.constant = adHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // 广告加载失败
    func nativeAd(_ nativeAd: HXNativeAd, didFailWithError error: Error) {
        updateStatus("加载失败: \(error.localizedDescription)", color: colorError)
    }
    
    // 广告曝光成功
    func nativeAdDidExpose(_ nativeAd: HXNativeAd) {
        updateStatus("广告已曝光", color: colorSuccess)
    }
    
    // 广告被点击
    func nativeAdDidClick(_ nativeAd: HXNativeAd) {
        updateStatus("广告被点击", color: colorSuccess)
    }
    
    // 广告关闭
    func nativeAdDidClose(_ nativeAd: HXNativeAd) {
        updateStatus("广告已关闭", color: colorGray)
        clearAd()
    }
    
    // 推荐高度计算完成
    func nativeAd(_ nativeAd: HXNativeAd, didCalculateRecommendedHeight recommendedHeight: CGFloat) {
        print("[NativeAd] 推荐高度: \(recommendedHeight)")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 更新容器高度
            self.adContainerHeightConstraint.constant = recommendedHeight
            
            // 更新广告视图的高度约束
            if let adView = nativeAd.adView, adView.superview == self.adContainerView {
                for constraint in adView.constraints {
                    if constraint.firstAttribute == .height && constraint.firstItem as? UIView == adView {
                        constraint.constant = recommendedHeight
                        break
                    }
                }
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
