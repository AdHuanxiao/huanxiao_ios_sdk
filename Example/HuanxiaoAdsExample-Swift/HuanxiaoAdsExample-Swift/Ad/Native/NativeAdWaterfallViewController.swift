//
//  NativeAdWaterfallViewController.swift
//  HuanxiaoAdsExample-Swift
//
//  信息流广告瀑布流展示示例
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

import UIKit
import HuanxiaoAds

// MARK: - 瀑布流布局

class HXWaterfallLayout: UICollectionViewFlowLayout {
    
    var numberOfColumns: Int = 2
    var columnSpacing: CGFloat = 10
    var rowSpacing: CGFloat = 10
    var heightForItemAtIndexPath: ((IndexPath, CGFloat) -> CGFloat)?
    
    private var attributesArray: [UICollectionViewLayoutAttributes] = []
    private var columnHeights: [CGFloat] = []
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        attributesArray.removeAll()
        columnHeights = Array(repeating: sectionInset.top, count: numberOfColumns)
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let totalWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let itemWidth = (totalWidth - CGFloat(numberOfColumns - 1) * columnSpacing) / CGFloat(numberOfColumns)
        
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 找到最短的列
            var shortestColumn = 0
            var minHeight = columnHeights[0]
            for j in 1..<numberOfColumns {
                if columnHeights[j] < minHeight {
                    minHeight = columnHeights[j]
                    shortestColumn = j
                }
            }
            
            let x = sectionInset.left + CGFloat(shortestColumn) * (itemWidth + columnSpacing)
            let y = columnHeights[shortestColumn]
            let height = heightForItemAtIndexPath?(indexPath, itemWidth) ?? 200
            
            attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: height)
            attributesArray.append(attributes)
            
            // 更新列高度
            columnHeights[shortestColumn] = y + height + rowSpacing
        }
    }
    
    override var collectionViewContentSize: CGSize {
        let maxHeight = columnHeights.max() ?? 0
        return CGSize(width: collectionView?.bounds.width ?? 0, height: maxHeight + sectionInset.bottom)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item < attributesArray.count else { return nil }
        return attributesArray[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView?.bounds.size != newBounds.size
    }
}

// MARK: - 瀑布流 Cell

class HXWaterfallCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.clipsToBounds = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        imageView.layer.cornerRadius = 8
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = UIColor(white: 0.2, alpha: 1.0)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
        ])
    }
    
    func configure(title: String, imageColor: UIColor) {
        titleLabel.text = title
        imageView.backgroundColor = imageColor
    }
}

// MARK: - 广告 Cell

class HXWaterfallAdCell: UICollectionViewCell {
    
    let adContainerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        adContainerView.backgroundColor = .white
        adContainerView.layer.cornerRadius = 8
        adContainerView.clipsToBounds = true
        adContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adContainerView)
        
        NSLayoutConstraint.activate([
            adContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            adContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        adContainerView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func configure(with adView: UIView?) {
        // 清除旧视图
        adContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        guard let adView = adView else { return }
        
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.layer.cornerRadius = 8
        adView.clipsToBounds = true
        adContainerView.addSubview(adView)
        
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: adContainerView.topAnchor),
            adView.leadingAnchor.constraint(equalTo: adContainerView.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: adContainerView.trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: adContainerView.bottomAnchor),
        ])
    }
}

// MARK: - 数据模型

class HXWaterfallItem {
    var isAd: Bool = false
    var title: String = ""
    var color: UIColor = .white
    var height: CGFloat = 200
    var nativeAd: HXNativeAd?
}

// MARK: - ViewController

class NativeAdWaterfallViewController: UIViewController {
    
    private static let adSpotID = "1009"
    
    private var collectionView: UICollectionView!
    private var waterfallLayout: HXWaterfallLayout!
    private var items: [HXWaterfallItem] = []
    private let statusLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        title = "信息流瀑布流"
        
        // 状态标签
        statusLabel.font = .systemFont(ofSize: 14, weight: .medium)
        statusLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        statusLabel.textAlignment = .center
        statusLabel.text = ""
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // 瀑布流布局
        waterfallLayout = HXWaterfallLayout()
        waterfallLayout.numberOfColumns = 2
        waterfallLayout.columnSpacing = 10
        waterfallLayout.rowSpacing = 10
        waterfallLayout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        waterfallLayout.heightForItemAtIndexPath = { [weak self] indexPath, _ in
            guard let self = self, indexPath.item < self.items.count else { return 200 }
            return self.items[indexPath.item].height
        }
        
        // CollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: waterfallLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HXWaterfallCell.self, forCellWithReuseIdentifier: "HXWaterfallCell")
        collectionView.register(HXWaterfallAdCell.self, forCellWithReuseIdentifier: "HXWaterfallAdCell")
        view.addSubview(collectionView)
        
        // 下拉刷新
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func loadInitialData() {
        items.removeAll()
        
        // 模拟内容数据
        let titles = [
            "春日踏青好去处",
            "美食推荐：家常菜",
            "旅行必备清单",
            "健身小技巧",
            "读书笔记分享",
            "摄影构图指南",
            "生活小妙招",
            "音乐推荐",
            "电影观后感",
            "手工DIY教程",
            "宠物日常",
            "穿搭灵感",
            "咖啡品鉴入门",
            "周末露营攻略",
            "数码产品评测",
            "居家收纳技巧",
            "护肤心得分享",
            "烘焙新手教程",
            "游戏攻略大全",
            "职场干货分享",
            "投资理财入门",
            "健康饮食指南",
            "家居装修灵感",
            "亲子活动推荐",
            "园艺种植技巧",
            "汽车保养知识",
            "瑜伽冥想入门",
            "书法练习分享",
            "绘画创作日记",
            "户外徒步路线",
            "美妆技巧教程",
            "二手好物推荐",
            "学习方法论",
            "情绪管理技巧",
            "睡眠改善方案",
            "时间管理心得",
            "社交技巧分享",
            "语言学习打卡",
            "科技新闻速递",
            "艺术展览推荐",
        ]
        
        let colors: [UIColor] = [
            UIColor(red: 0.95, green: 0.77, blue: 0.77, alpha: 1.0),
            UIColor(red: 0.77, green: 0.95, blue: 0.77, alpha: 1.0),
            UIColor(red: 0.77, green: 0.77, blue: 0.95, alpha: 1.0),
            UIColor(red: 0.95, green: 0.95, blue: 0.77, alpha: 1.0),
            UIColor(red: 0.95, green: 0.77, blue: 0.95, alpha: 1.0),
            UIColor(red: 0.77, green: 0.95, blue: 0.95, alpha: 1.0),
            UIColor(red: 0.88, green: 0.85, blue: 0.95, alpha: 1.0),
            UIColor(red: 0.95, green: 0.88, blue: 0.77, alpha: 1.0),
            UIColor(red: 0.77, green: 0.88, blue: 0.95, alpha: 1.0),
            UIColor(red: 0.85, green: 0.95, blue: 0.85, alpha: 1.0),
        ]
        
        // 随机间隔插入广告
        var contentCountSinceLastAd = 0
        var nextAdInterval = 4 + Int(arc4random_uniform(4))
        
        for (i, title) in titles.enumerated() {
            let item = HXWaterfallItem()
            item.isAd = false
            item.title = title
            item.color = colors[i % colors.count]
            // 随机高度
            item.height = CGFloat(180 + arc4random_uniform(100))
            items.append(item)
            
            contentCountSinceLastAd += 1
            
            // 达到随机间隔后插入广告位
            if contentCountSinceLastAd >= nextAdInterval && i < titles.count - 1 {
                let adItem = HXWaterfallItem()
                adItem.isAd = true
                adItem.height = 250 // 广告默认高度
                items.append(adItem)
                
                // 重置计数并生成下一个随机间隔
                contentCountSinceLastAd = 0
                nextAdInterval = 4 + Int(arc4random_uniform(4))
            }
        }
        
        collectionView.reloadData()
        
        // 加载广告
        loadAds()
    }
    
    @objc private func refreshData() {
        // 清除旧广告
        for item in items where item.isAd {
            item.nativeAd?.close()
            item.nativeAd = nil
        }
        
        loadInitialData()
        refreshControl.endRefreshing()
    }
    
    private func loadAds() {
        updateStatus("正在加载广告...", color: UIColor(red: 0.95, green: 0.6, blue: 0.1, alpha: 1.0))
        
        let adWidth = (view.bounds.width - 16 * 2 - 10) / 2 // 瀑布流单列宽度
        
        for item in items where item.isAd && item.nativeAd == nil {
            guard let nativeAd = HXNativeAd(adSpotID: Self.adSpotID, size: CGSize(width: adWidth, height: 0)) else { continue }
            nativeAd.delegate = self
            item.nativeAd = nativeAd
            nativeAd.load()
        }
    }
    
    private func updateStatus(_ status: String, color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            self?.statusLabel.text = status
            self?.statusLabel.textColor = color
        }
    }
    
    deinit {
        // 清理广告
        for item in items where item.isAd {
            item.nativeAd?.close()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension NativeAdWaterfallViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.item]
        
        if item.isAd {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HXWaterfallAdCell", for: indexPath) as! HXWaterfallAdCell
            cell.configure(with: item.nativeAd?.adView)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HXWaterfallCell", for: indexPath) as! HXWaterfallCell
            cell.configure(title: item.title, imageColor: item.color)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension NativeAdWaterfallViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        if !item.isAd {
            print("[Waterfall] 点击内容: \(item.title)")
        }
    }
}

// MARK: - HXNativeAdDelegate

extension NativeAdWaterfallViewController: HXNativeAdDelegate {
    
    func nativeAdDidLoad(_ nativeAd: HXNativeAd) {
        updateStatus("广告加载成功", color: UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0))
        
        // 找到对应的 item 并更新
        for (i, item) in items.enumerated() {
            if item.nativeAd === nativeAd {
                // 更新广告高度
                if let adView = nativeAd.adView {
                    item.height = adView.frame.height
                }
                
                // 刷新对应的 cell
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.collectionViewLayout.invalidateLayout()
                    self?.collectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
                }
                break
            }
        }
    }
    
    func nativeAd(_ nativeAd: HXNativeAd, didFailWithError error: Error) {
        updateStatus("广告加载失败: \(error.localizedDescription)", color: UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0))
    }
    
    func nativeAdDidExpose(_ nativeAd: HXNativeAd) {
        print("[Waterfall] 广告已曝光")
    }
    
    func nativeAdDidClick(_ nativeAd: HXNativeAd) {
        print("[Waterfall] 广告被点击")
    }
    
    func nativeAdDidClose(_ nativeAd: HXNativeAd) {
        // 找到并移除关闭的广告
        for (i, item) in items.enumerated() {
            if item.nativeAd === nativeAd {
                items.remove(at: i)
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.deleteItems(at: [IndexPath(item: i, section: 0)])
                }
                break
            }
        }
    }
    
    func nativeAd(_ nativeAd: HXNativeAd, didCalculateRecommendedHeight recommendedHeight: CGFloat) {
        // 找到对应的 item 并更新高度
        for (i, item) in items.enumerated() {
            if item.nativeAd === nativeAd {
                item.height = recommendedHeight
                
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.collectionViewLayout.invalidateLayout()
                    self?.collectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
                }
                break
            }
        }
    }
}
