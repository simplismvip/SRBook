//
//  SRHomeRefresh.swift
//  SReader
//
//  Created by JunMing on 2020/3/25.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit

class SRPullingIndicator: UIView {

    public let spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    var radius: CGFloat{
        get {
            return totalHeight / 4 - margin
        }
    }
    open var progress:CGFloat = 0.0{
        didSet {
            setNeedsDisplay()
        }
    }
    open var margin:CGFloat = 4.0{
        didSet {
            setNeedsDisplay()
        }
    }
    var arrowRadius:CGFloat{
        get {
            return radius * 0.5 - 0.2 * radius * adjustedProgress
        }
    }
    var adjustedProgress:CGFloat{
        get {
            return min(max(progress,0.0),1.0)
        }
    }
    let totalHeight:CGFloat = 80
    open var arrowColor = UIColor.white{
        didSet {
            setNeedsDisplay()
        }
    }
    open var elasticTintColor = UIColor.init(white: 0.5, alpha: 0.6){
        didSet {
            setNeedsDisplay()
        }
    }
    var animating = false{
        didSet {
            if animating{
                spinner.startAnimating()
                setNeedsDisplay()
            } else {
                spinner.stopAnimating()
                setNeedsDisplay()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        self.isOpaque = false
        addSubview(spinner)
        sizeToFit()
        spinner.hidesWhenStopped = true
        spinner.style = .gray
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        spinner.center = CGPoint(x: self.bounds.width / 2.0, y: 0.75 * totalHeight)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func sinCGFloat(_ angle:CGFloat)->CGFloat{
        let result = sinf(Float(angle))
        return CGFloat(result)
    }
    
    func cosCGFloat(_ angle:CGFloat)->CGFloat{
        let result = cosf(Float(angle))
        return CGFloat(result)
    }
    
    open override func draw(_ rect: CGRect) {
        // 如果在Animating，则什么都不做
        if animating {
            super.draw(rect)
            return
        }
        let context = UIGraphicsGetCurrentContext()
        let centerX = rect.width/2.0
        let lineWidth = 2.5 - 1.0 * adjustedProgress
        //上面圆的信息
        let upCenter = CGPoint(x: centerX, y: (0.75 - 0.5 * adjustedProgress) * totalHeight)
        let upRadius = radius - radius * 0.3 * adjustedProgress
        
        //下面圆的信息
        let downRadius:CGFloat = radius  - radius * 0.75 * adjustedProgress
        let downCenter = CGPoint(x: centerX, y: totalHeight - downRadius - margin)
        
        //偏移的角度
        let offSetAngle:CGFloat = CGFloat(Double.pi / 12.0)
        //计算上面圆的左/右的交点坐标
        let upP1 = CGPoint(x: upCenter.x - upRadius * cosCGFloat(offSetAngle), y: upCenter.y + upRadius * sinCGFloat(offSetAngle))
        let upP2 = CGPoint(x: upCenter.x + upRadius * cosCGFloat(offSetAngle), y: upCenter.y + upRadius * sinCGFloat(offSetAngle))
        
        //计算下面的圆左/右叫点坐标
        let downP1 = CGPoint(x: downCenter.x - downRadius * cosCGFloat(offSetAngle), y: downCenter.y -  downRadius * sinCGFloat(offSetAngle))
        
        //计算Control Point
        let controPonintLeft = CGPoint(x: downCenter.x - downRadius, y: (downCenter.y + upCenter.y)/2)
        let controPonintRight = CGPoint(x: downCenter.x + downRadius, y: (downCenter.y + upCenter.y)/2)
        
        //实际绘制
        context?.setFillColor(elasticTintColor.cgColor)
        context?.addArc(center: upCenter, radius: upRadius, startAngle: CGFloat(-Double.pi)-offSetAngle, endAngle: offSetAngle, clockwise: false)
        context?.move(to: CGPoint(x: upP1.x, y: upP1.y))
        context?.addQuadCurve(to: downP1, control: controPonintLeft)
        context?.addArc(center: downCenter, radius: downRadius, startAngle: CGFloat(-Double.pi)-offSetAngle, endAngle: offSetAngle, clockwise: true)
        context?.addQuadCurve(to: upP2, control: controPonintRight)
        context?.fillPath()
        
        //绘制箭头
        context?.setStrokeColor(arrowColor.cgColor)
        context?.setLineWidth(lineWidth)
        context?.addArc(center: upCenter, radius: arrowRadius, startAngle: 0, endAngle: CGFloat(Double.pi * 1.5), clockwise: false)
        context?.strokePath()
        
        context?.setFillColor(arrowColor.cgColor)
        context?.setLineWidth(0.0)
        
        context?.move(to: CGPoint(x: upCenter.x, y: upCenter.y - arrowRadius - lineWidth * 1.5))
        context?.addLine(to: CGPoint(x: upCenter.x, y: upCenter.y - arrowRadius + lineWidth * 1.5))
        context?.addLine(to: CGPoint(x: upCenter.x + lineWidth * 0.865 * 3, y: upCenter.y - arrowRadius))
        context?.addLine(to: CGPoint(x: upCenter.x, y: upCenter.y - arrowRadius - lineWidth * 1.5))
        context?.fillPath()
        
    }
    override open func sizeToFit() {
        var width = frame.size.width
        if width < 30.0{
            width = 30.0
        }
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y,width: width, height: totalHeight)
    }
}

import MJRefresh
//// MARK: - 自动刷新的公共方法
//public class BaseAutoRefresh: MJRefreshNormalHeader {
//    
//    /// 创建下拉刷新
//    ///
//    /// - Parameters:
//    ///   - target:     刷新执行对象 ViewController
//    ///   - selector:   刷新执行方法
//    ///   - tableView:  添加刷新的TableView
//    public class func createHeaderRefresh(target: AnyObject, selector: Selector, tableView: UITableView) {
//        let refreshHeader = tableView.mj_header
//        refreshHeader.refreshingAction = selector
//        refreshHeader.refreshingTarget = target
//        tableView!.mj_header = refreshHeader
//    }
//    
//    /// 停止下拉刷新
//    ///
//    /// - Parameter tableView: 停止刷新的TableView
//    public class func endHeaderRefresh(_ tableView: UITableView){
//       
//        if  tableView.mj_header == nil {
//            return
//        }
//        tableView.mj_header?.endRefreshing()
//    }
//    
//    /// 创建上拉加载更多
//    ///
//    /// - Parameters:
//    ///   - target:     加载更多执行对象 ViewController
//    ///   - selector:   加载更多执行方法
//    ///   - tableView:  添加加载更多的TableView
//    public class func createFooterRefresh(target: AnyObject, selector: Selector, tableView: UITableView, isLineFooter: Bool = false, automaticRefresh: Bool = true) {
//        if isLineFooter == true {
//            let lineFooter = BaseAutoRefreshLineNormalFooter.init(refreshingTarget: target, refreshingAction: selector)
//            lineFooter?.isAutomaticallyRefresh = automaticRefresh
//            lineFooter?.isAutomaticallyHidden = true
//            lineFooter?.setTitle("我是有底线的",
//                                           for: .noMoreData)
//            tableView!.mj_footer = lineFooter
//        } else {
//            let refreshFooter = MJRefreshAutoNormalFooter.init(refreshingTarget: target,
//            refreshingAction: selector)
//            refreshFooter?.isAutomaticallyRefresh = automaticRefresh
//            refreshFooter?.isAutomaticallyHidden = true
//            refreshFooter?.setTitle("已经到底啦",
//                                           for: .noMoreData)
//            tableView.mj_footer = refreshFooter;
//        }
//    }
//    
//    /// 停止上拉加载更多
//    ///
//    /// - Parameters:
//    ///   - tableView:  停止加载更多的TableView
//    ///   - hasMore:    是否还有更多 true：还有更多 false：全部加载完毕
//    public class func endFooterRefresh(_ tableView: UITableView, hasMore: Bool){
//        if tableView.mj_footer == nil {
//            return
//        }
//        if hasMore {
//            tableView.mj_footer?.endRefreshing()
//        }else{
//            tableView.mj_footer?.endRefreshingWithNoMoreData()
//        }
//    }
//}
