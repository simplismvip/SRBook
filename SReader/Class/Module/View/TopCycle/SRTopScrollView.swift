//
//  SRTopScrollView.swift
//  SReader
//
//  Created by JunMing on 2021/7/15.
//

import UIKit

/// Position
public enum PageControlPosition {
    case center
    case left
    case right
}

class SRTopScrollView: UIView {
    public var dataSource: [SRTopTab] = [] {
        didSet {
            totalItemsCount = dataSource.count * 100
            if dataSource.count > 1 {
                collectionView.isScrollEnabled = true
                if autoScroll {
                    setupTimer()
                }
            } else {
                collectionView.isScrollEnabled = false
                invalidateTimer()
            }
            collectionView.reloadData()
            setupPageControl()
        }
    }
    
    // MARK:- Config
    /// 自动轮播- 默认true
    open var autoScroll: Bool = true {
        didSet {
            invalidateTimer()
            // 如果关闭的无限循环，则不进行计时器的操作，否则每次滚动到最后一张就不在进行了。
            if autoScroll {
                setupTimer()
            }
        }
    }
    
    /// 滚动方向，默认horizontal
    open var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            flowLayout.scrollDirection = scrollDirection
            if scrollDirection == .horizontal {
                position = .centeredHorizontally
            }else{
                position = .centeredVertically
            }
        }
    }
    
    /// 滚动间隔时间,默认2秒
    open var autoScrollTimeInterval: Double = 2.0 {
        didSet {
            autoScroll = true
        }
    }
    
    // MARK: CustomPageControl
    /// Custom PageControl
    public let customPageControl = SRSnakePageControl(frame: CGRect.zero)
    
    /// Position
    open var pageControlPosition: PageControlPosition = .center {
        didSet {
            setupPageControl()
        }
    }
    
    /// Leading
    open var pageControlLeadingOrTrialingContact: CGFloat = 28 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Bottom
    open var pageControlBottom: CGFloat = 11 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK:- Private
    /// 总数量
    fileprivate var totalItemsCount: NSInteger = 1
    
    /// 最大伸展空间(防止出现问题，可外部设置)
    /// 用于反方向滑动的时候，需要知道最大的contentSize
    fileprivate var maxSwipeSize: CGFloat = 0
    
    /// 高度
    fileprivate var cellHeight: CGFloat = 56
    
    /// Collection滚动方向
    fileprivate var position: UICollectionView.ScrollPosition! = .centeredHorizontally
    
    /// 计时器
    fileprivate var dtimer: DispatchSourceTimer?
    
    /// 容器组件 UICollectionView
    fileprivate var collectionView: UICollectionView!
    
    // Identifier
    fileprivate let identifier = "LLCycleScrollViewCell"
    
    /// UICollectionViewFlowLayout
    lazy fileprivate var flowLayout: UICollectionViewFlowLayout = {
        let tempFlowLayout = UICollectionViewFlowLayout()
        tempFlowLayout.minimumLineSpacing = 0
        tempFlowLayout.scrollDirection = .horizontal
        return tempFlowLayout
    }()
    
    
    /// Init
    ///
    /// - Parameter frame: CGRect
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        setupMainView()
    }
    
    /// Init
    ///
    /// - Parameter aDecoder: NSCoder
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMainView()
    }
}

// MARK: UI
extension SRTopScrollView {
    // MARK: 添加UICollectionView
    private func setupMainView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.register(SRScrollViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        self.addSubview(collectionView)
    }
    
    // MARK: 添加PageControl
    func setupPageControl() {
        if dataSource.count <= 1 {
            return
        }
        customPageControl.removeFromSuperview()
        customPageControl.activeTint = UIColor.white
        customPageControl.indicatorPadding = 8
        customPageControl.indicatorRadius = 4
        customPageControl.inactiveTint = UIColor(white: 1, alpha: 0.3)
        customPageControl.pageCount = dataSource.count
        addSubview(customPageControl)
        calcScrollViewToScroll(collectionView)
    }
}

// MARK: UIViewHierarchy | LayoutSubviews
extension SRTopScrollView {
    /// 将要添加到 window 上时
    ///
    /// - Parameter newWindow: 新的 window
    /// 添加到window 上时 开启 timer, 从 window 上移除时, 移除 timer
    override open func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            if autoScroll {
                setupTimer()
            }
        } else {
            invalidateTimer()
        }
    }
    
    // MARK: layoutSubviews
    override open func layoutSubviews() {
        super.layoutSubviews()
        // CollectionView
        collectionView.frame = self.bounds
        
        // Cell Height
        cellHeight = collectionView.frame.height
        
        // 计算最大扩展区大小
        if scrollDirection == .horizontal {
            maxSwipeSize = CGFloat(dataSource.count) * collectionView.frame.width
        }else{
            maxSwipeSize = CGFloat(dataSource.count) * collectionView.frame.height
        }
        
        // Cell Size
        flowLayout.itemSize = self.frame.size
        // Page Frame
        let y = self.jmHeight-pageControlBottom
        let oldFrame = customPageControl.frame
        switch pageControlPosition {
        case .left:
            customPageControl.frame = CGRect(x: pageControlLeadingOrTrialingContact * 0.5, y: y, width: oldFrame.size.width, height: 10)
        case.right:
            customPageControl.frame = CGRect(x: UIScreen.main.bounds.width - oldFrame.size.width - pageControlLeadingOrTrialingContact * 0.5, y: y, width: oldFrame.size.width, height: 10)
        default:
            customPageControl.frame = CGRect(x: oldFrame.origin.x, y: y, width: oldFrame.size.width, height: 10)
        }
        
        if collectionView.contentOffset.x == 0 && totalItemsCount > 0 {
            var targetIndex = 0
            targetIndex = totalItemsCount/2
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: position, animated: false)
        }
    }
}

// MARK: 定时器模块
extension SRTopScrollView {
    /// 添加DTimer
    func setupTimer() {
        // 仅一张图不进行滚动操纵
        if dataSource.count <= 1 { return }
        
        invalidateTimer()
        
        let l_dtimer = DispatchSource.makeTimerSource()
        l_dtimer.schedule(deadline: .now()+autoScrollTimeInterval, repeating: autoScrollTimeInterval)
        l_dtimer.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.automaticScroll()
            }
        }
        // 继续
        l_dtimer.resume()
        
        dtimer = l_dtimer
    }
    
    /// 关闭倒计时
    func invalidateTimer() {
        dtimer?.cancel()
        dtimer = nil
    }
}

// MARK: Events
extension SRTopScrollView {
    /// 自动轮播
    @objc func automaticScroll() {
        if totalItemsCount == 0 {return}
        let targetIndex = currentIndex() + 1
        scollToIndex(targetIndex: targetIndex)
    }
    
    /// 滚动到指定位置
    ///
    /// - Parameter targetIndex: 下标-Index
    func scollToIndex(targetIndex: Int) {
        if targetIndex >= totalItemsCount {
            collectionView.scrollToItem(at: IndexPath(item: Int(totalItemsCount/2), section: 0), at: position, animated: false)
            return
        }
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: position, animated: true)
    }
    
    /// 当前位置
    ///
    /// - Returns: 下标-Index
    func currentIndex() -> NSInteger {
        if collectionView.jmWidth == 0 || collectionView.jmHeight == 0 {
            return 0
        }
        var index = 0
        if flowLayout.scrollDirection == UICollectionView.ScrollDirection.horizontal {
            index = NSInteger(collectionView.contentOffset.x + flowLayout.itemSize.width * 0.5)/NSInteger(flowLayout.itemSize.width)
        }else {
            index = NSInteger(collectionView.contentOffset.y + flowLayout.itemSize.height * 0.5)/NSInteger(flowLayout.itemSize.height)
        }
        return index
    }
    
    /// PageControl当前下标对应的Cell位置
    ///
    /// - Parameter index: PageControl Index
    /// - Returns: Cell Index
    func pageControlIndexWithCurrentCellIndex(index: NSInteger) -> (Int) {
        return dataSource.count == 0 ? 0 : Int(index % dataSource.count)
    }
    
    /// 滚动上一个/下一个
    ///
    /// - Parameter gesture: 手势
    @objc open func scrollByDirection(_ gestureRecognizer: UITapGestureRecognizer) {
        if let index = gestureRecognizer.view?.tag {
            if autoScroll {
                invalidateTimer()
            }
            
            scollToIndex(targetIndex: currentIndex() + (index == 0 ? -1 : 1))
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension SRTopScrollView: UICollectionViewDelegate, UICollectionViewDataSource {
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount == 0 ? 1:totalItemsCount
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SRScrollViewCell) ?? SRScrollViewCell()
        if dataSource.count == 0 {
            cell.config(model: SRTopTab(icon: "srHomePlaceholder"))
        } else {
            let itemIndex = pageControlIndexWithCurrentCellIndex(index: indexPath.item)
            cell.config(model: dataSource[itemIndex])
        }
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemIndex = pageControlIndexWithCurrentCellIndex(index: indexPath.item)
        let model = dataSource[itemIndex]
        if let eventName = model.event {
            jmRouterEvent(eventName: eventName, info: model as AnyObject)
        }
    }
}

// MARK: UIScrollViewDelegate
extension SRTopScrollView: UIScrollViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dataSource.count == 0 { return }
        calcScrollViewToScroll(scrollView)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoScroll {
            invalidateTimer()
        }
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if dataSource.count == 0 { return }
        if autoScroll {
            setupTimer()
        }
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if dataSource.count == 0 { return }
        if dtimer == nil && autoScroll {
            setupTimer()
        }
    }
    
    fileprivate func calcScrollViewToScroll(_ scrollView: UIScrollView) {
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: currentIndex())
        var progress: CGFloat = 999
        // Direction
        if scrollDirection == .horizontal {
            var currentOffsetX = scrollView.contentOffset.x - (CGFloat(totalItemsCount) * scrollView.frame.size.width) / 2
            if currentOffsetX < 0 {
                if currentOffsetX >= -scrollView.frame.size.width{
                    currentOffsetX = CGFloat(indexOnPageControl) * scrollView.frame.size.width
                } else if currentOffsetX <= -maxSwipeSize{
                    collectionView.scrollToItem(at: IndexPath(item: Int(totalItemsCount/2), section: 0), at: position, animated: false)
                } else {
                    currentOffsetX = maxSwipeSize + currentOffsetX
                }
            }
            if currentOffsetX >= CGFloat(dataSource.count) * scrollView.frame.size.width {
                collectionView.scrollToItem(at: IndexPath(item: Int(totalItemsCount/2), section: 0), at: position, animated: false)
            }
            progress = currentOffsetX / scrollView.frame.size.width
        } else if scrollDirection == .vertical{
            var currentOffsetY = scrollView.contentOffset.y - (CGFloat(totalItemsCount) * scrollView.frame.size.height) / 2
            if currentOffsetY < 0 {
                if currentOffsetY >= -scrollView.frame.size.height{
                    currentOffsetY = CGFloat(indexOnPageControl) * scrollView.frame.size.height
                } else if currentOffsetY <= -maxSwipeSize{
                    collectionView.scrollToItem(at: IndexPath(item: Int(totalItemsCount/2), section: 0), at: position, animated: false)
                } else {
                    currentOffsetY = maxSwipeSize + currentOffsetY
                }
            }
            if currentOffsetY >= CGFloat(dataSource.count) * scrollView.frame.size.height {
                collectionView.scrollToItem(at: IndexPath(item: Int(totalItemsCount/2), section: 0), at: position, animated: false)
            }
            progress = currentOffsetY / scrollView.frame.size.height
        }
        
        if progress == 999 {
            progress = CGFloat(indexOnPageControl)
        }
        // progress
        customPageControl.progress = progress
    }
}
