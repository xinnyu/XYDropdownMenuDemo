//
//  XYDropdownMenu.swift
//  XYDropdownMenuDemo
//
//  Created by 潘新宇 on 15/10/5.
//  Copyright © 2015年 潘新宇. All rights reserved.
//

import UIKit

// MARK: BTNavigationDropdownMenu
public class XYDropDownMenu: UIView {
    
    
    public var menuTitleColor: UIColor! {
        get {
            return self.configuration.menuTitleColor
        }
        set(value) {
            self.configuration.menuTitleColor = value
        }
    }
    
    
    public var is0s: Bool! {
        get {
            return self.configuration.is0s
        }
        set(value) {
            self.configuration.is0s = value
        }
    }
    
    public var is1s: Bool! {
        get {
            return self.configuration.is1s
        }
        set(value) {
            self.configuration.is1s = value
        }
    }
    
    public var is2s: Bool! {
        get {
            return self.configuration.is2s
        }
        set(value) {
            self.configuration.is2s = value
        }
    }
    
    // Cell高度 ， 默认值50
    public var cellHeight: CGFloat! {
        get {
            return self.configuration.cellHeight
        }
        set(value) {
            self.configuration.cellHeight = value
        }
    }
    
    
    
    // Cell 背景颜色 默认白
    public var cellBackgroundColor: UIColor! {
        get {
            return self.configuration.cellBackgroundColor
        }
        set(color) {
            self.configuration.cellBackgroundColor = color
        }
    }
    
    public var cellSeparatorColor: UIColor! {
        get {
            return self.configuration.cellSeparatorColor
        }
        set(value) {
            self.configuration.cellSeparatorColor = value
        }
    }
    
    // Cell 中文字颜色 默认灰色
    public var cellTextLabelColor: UIColor! {
        get {
            return self.configuration.cellTextLabelColor
        }
        set(value) {
            self.configuration.cellTextLabelColor = value
        }
    }
    
    // Cell中文字字体
    public var cellTextLabelFont: UIFont! {
        get {
            return self.configuration.cellTextLabelFont
        }
        set(value) {
            self.configuration.cellTextLabelFont = value
            self.menuTitle.font = self.configuration.cellTextLabelFont
        }
    }
    
    public var cellSelectionColor: UIColor! {
        get {
            return self.configuration.cellSelectionColor
        }
        set(value) {
            self.configuration.cellSelectionColor = value
        }
    }
    
    // 选中图标
    public var checkMarkImage: UIImage! {
        get {
            return self.configuration.checkMarkImage
        }
        set(value) {
            self.configuration.checkMarkImage = value
        }
    }
    

    public var animationDuration: NSTimeInterval! {
        get {
            return self.configuration.animationDuration
        }
        set(value) {
            self.configuration.animationDuration = value
        }
    }
    

    public var arrowImage: UIImage! {
        get {
            return self.configuration.arrowImage
        }
        set(value) {
            self.configuration.arrowImage = value
            self.menuArrow.image = self.configuration.arrowImage
        }
    }
    
    // 图标和文字之间的距离
    public var arrowPadding: CGFloat! {
        get {
            return self.configuration.arrowPadding
        }
        set(value) {
            self.configuration.arrowPadding = value
        }
    }
    

    public var maskBackgroundColor: UIColor! {
        get {
            return self.configuration.maskBackgroundColor
        }
        set(value) {
            self.configuration.maskBackgroundColor = value
        }
    }
    
    // 透明度
    public var maskBackgroundOpacity: CGFloat! {
        get {
            return self.configuration.maskBackgroundOpacity
        }
        set(value) {
            self.configuration.maskBackgroundOpacity = value
        }
    }
    
    
    
    public var didSelectItemAtIndexHandler: ((indexPath: Int) -> ())?
    
    private var navigationController: UINavigationController?
    private var configuration = XYConfiguration()
    private var topSeparator: UIView!
    private var menuButton: UIButton!
    private var menuTitle: UILabel!
    private var menuArrow: UIImageView!
    private var backgroundView: UIView!
    private var tableView: XYTableView!
    private var items: [AnyObject]!
    public var isShown: Bool!
    private var menuWrapper: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(title: String, items: [AnyObject]) {
        
        // Navigation controller
        self.navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController?.XYTopMostViewController().navigationController
        
        // Get titleSize
        let titleSize = (title as NSString).sizeWithAttributes([NSFontAttributeName:self.configuration.cellTextLabelFont])
        
        // Set frame
        let frame = CGRectMake(0, 0, titleSize.width + (self.configuration.arrowPadding + self.configuration.arrowImage.size.width)*2, (self.navigationController?.navigationBar.frame.height)!)
        
        super.init(frame:frame)
        
        self.navigationController?.view.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        
        self.isShown = false
        self.items = items
        
        // Init properties
        self.setupDefaultConfiguration()
        
        // Init button as navigation title
        self.menuButton = UIButton(frame: frame)
        self.menuButton.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.menuButton)
        
        self.menuTitle = UILabel(frame: frame)
        self.menuTitle.text = title
        self.menuTitle.textColor = self.menuTitleColor
        self.menuTitle.textAlignment = NSTextAlignment.Center
        self.menuTitle.font = self.configuration.cellTextLabelFont
        self.menuButton.addSubview(self.menuTitle)
        
        self.menuArrow = UIImageView(image: self.configuration.arrowImage)
        self.menuButton.addSubview(self.menuArrow)
        
        let window = UIApplication.sharedApplication().keyWindow!
        let menuWrapperBounds = window.bounds
        
        // 设置View
        self.menuWrapper = UIView(frame: CGRectMake(menuWrapperBounds.origin.x, 0, menuWrapperBounds.width, menuWrapperBounds.height))
        self.menuWrapper.clipsToBounds = true
        self.menuWrapper.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        

        self.backgroundView = UIView(frame: menuWrapperBounds)
        self.backgroundView.backgroundColor = self.configuration.maskBackgroundColor
        self.backgroundView.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        // 初始化 table view
        self.tableView = XYTableView(frame: CGRectMake(menuWrapperBounds.origin.x, menuWrapperBounds.origin.y + 0.5, menuWrapperBounds.width, menuWrapperBounds.height + 300), items: items, configuration: self.configuration)
        
        self.tableView.selectRowAtIndexPathHandler = { (indexPath: Int,cell:XYTableViewCell) -> () in
            if self.didSelectItemAtIndexHandler != nil {
                self.didSelectItemAtIndexHandler!(indexPath: indexPath)
            }
            
            self.layoutSubviews()
        }
        
        // Add background view & table view to container view
        self.menuWrapper.addSubview(self.backgroundView)
        self.menuWrapper.addSubview(self.tableView)
        
        // Add Line on top
        self.topSeparator = UIView(frame: CGRectMake(0, 0, menuWrapperBounds.size.width, 0.5))
        self.topSeparator.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.menuWrapper.addSubview(self.topSeparator)
        
        // Add Menu View to container view
        window.addSubview(self.menuWrapper)
        
        // By default, hide menu view
        self.menuWrapper.hidden = true
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            // Set up DropdownMenu
            self.menuWrapper.frame.origin.y = (self.navigationController?.navigationBar.frame.maxY)!
            self.tableView.reloadData()
        }
    }
    
    override public func layoutSubviews() {
        self.menuTitle.sizeToFit()
        self.menuTitle.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.menuArrow.sizeToFit()
        self.menuArrow.center = CGPointMake(CGRectGetMaxX(self.menuTitle.frame) + self.configuration.arrowPadding, self.frame.size.height/2)
    }
    
    func setupDefaultConfiguration() {
        self.menuTitleColor = self.navigationController?.navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor // Setter
        self.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        self.cellSeparatorColor = self.navigationController?.navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor
        self.cellTextLabelColor = self.navigationController?.navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor
    }
    
    func showMenu() {
        self.menuWrapper.frame.origin.y = (self.navigationController?.navigationBar.frame.maxY)!
        
        // Table view header
        let headerView = UIView(frame: CGRectMake(0, 0, self.frame.width, 300))
        headerView.backgroundColor = self.configuration.cellBackgroundColor
        self.tableView.tableHeaderView = headerView
        
        self.topSeparator.backgroundColor = self.configuration.cellSeparatorColor
        
        // Rotate arrow
        self.rotateArrow()
        
        // Visible menu view
        self.menuWrapper.hidden = false
        
        // Change background alpha
        self.backgroundView.alpha = 0
        
        // Animation
        self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300
        
        // Reload data to dismiss highlight color of selected cell
        self.tableView.reloadData()
        
        UIView.animateWithDuration(
            self.configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-300)
                self.backgroundView.alpha = self.configuration.maskBackgroundOpacity
            }, completion: nil
        )
    }
    
    public func hideMenu() {
        // Rotate arrow
        self.rotateArrow()
        
        // Change background alpha
        self.backgroundView.alpha = self.configuration.maskBackgroundOpacity
        
        isShown = false
        
        UIView.animateWithDuration(
            self.configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-200)
            }, completion: nil
        )
        
        // Animation
        UIView.animateWithDuration(self.configuration.animationDuration, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300
            self.backgroundView.alpha = 0
            }, completion: { _ in
                self.menuWrapper.hidden = true
        })
    }
    
    func rotateArrow() {
        UIView.animateWithDuration(self.configuration.animationDuration, animations: {[weak self] () -> () in
            if let selfie = self {
                selfie.menuArrow.transform = CGAffineTransformRotate(selfie.menuArrow.transform, 180 * CGFloat(M_PI/180))
            }
            })
    }
    
    func setMenuTitle(title: String) {
        self.menuTitle.text = title
    }
    
    func menuButtonTapped(sender: UIButton) {
        self.isShown = !self.isShown
        if self.isShown == true {
            self.showMenu()
        } else {
            self.hideMenu()
        }
    }
}

// MARK: BTConfiguration
class XYConfiguration {
    var menuTitleColor: UIColor?
    var cellHeight: CGFloat!
    var cellBackgroundColor: UIColor?
    var cellSeparatorColor: UIColor?
    var cellTextLabelColor: UIColor?
    var cellTextLabelFont: UIFont!
    var cellSelectionColor: UIColor?
    var checkMarkImage: UIImage!
    var arrowImage: UIImage!
    var arrowPadding: CGFloat!
    var animationDuration: NSTimeInterval!
    var maskBackgroundColor: UIColor!
    var maskBackgroundOpacity: CGFloat!
    var is0s:Bool!
    var is1s:Bool!
    var is2s:Bool!
    
    init() {
        self.defaultValue()
    }
    
    func defaultValue() {
        // Path for image
        let bundle = NSBundle(forClass: XYConfiguration.self)
        let url = bundle.URLForResource("XYDropMenu", withExtension: "bundle")
        let imageBundle = NSBundle(URL: url!)
        let checkMarkImagePath = imageBundle?.pathForResource("checkmark_icon", ofType: "png")
        let arrowImagePath = imageBundle?.pathForResource("arrow_down_icon", ofType: "png")
        
        // Default values
        self.menuTitleColor = UIColor.darkGrayColor()
        self.cellHeight = 50
        self.cellBackgroundColor = UIColor.whiteColor()
        self.cellSeparatorColor = UIColor.darkGrayColor()
        self.cellTextLabelColor = UIColor.darkGrayColor()
        self.cellTextLabelFont = UIFont.systemFontOfSize(14)
        self.cellSelectionColor = UIColor.lightGrayColor()
        self.checkMarkImage = UIImage(contentsOfFile: checkMarkImagePath!)
        self.animationDuration = 0.5
        self.arrowImage = UIImage(contentsOfFile: arrowImagePath!)
        self.arrowPadding = 15
        self.maskBackgroundColor = UIColor.blackColor()
        self.maskBackgroundOpacity = 0.3
        self.is0s = false
        self.is1s = false
        self.is2s = false
        
    }
}

// MARK: Table View 相关
class XYTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // Public properties
    var configuration: XYConfiguration!
    var selectRowAtIndexPathHandler: ((indexPath: Int,cell:XYTableViewCell) -> ())?
    
    var selectAtRow:Int = 5
    // Private properties
    private var items: [AnyObject]!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, items: [AnyObject], configuration: XYConfiguration) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        
        self.items = items
        
        self.configuration = configuration
        
        // Setup table view
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clearColor()
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.tableFooterView = UIView(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.alpha = 0.7
        
        
    }
    
    // Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.configuration.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = XYTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell", configuration: self.configuration)
        cell.textLabel?.text = self.items[indexPath.row] as? String
        
        let is0s = configuration.is0s
        let is1s = configuration.is1s
        let is2s = configuration.is2s
        
        if is0s!{
            if indexPath.row == 0 {
                cell.checkmarkIcon.hidden = false
            }
        }else{
            if indexPath.row == 0 {
                cell.checkmarkIcon.hidden = true
            }
        }
        
        if is1s!{
            if indexPath.row == 1 {
                cell.checkmarkIcon.hidden = false
            }
        }else{
            if indexPath.row == 1 {
                cell.checkmarkIcon.hidden = true
            }
        }
        
        if is2s!{
            if indexPath.row == 2 {
                cell.checkmarkIcon.hidden = false
            }
        }else{
            if indexPath.row == 2 {
                cell.checkmarkIcon.hidden = true
            }
        }
        
        
        if indexPath.row == 3{
            cell.checkmarkIcon.hidden = true
        }
        
        
        
        
        return cell
    }
    
    
    
    
    
    // Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? XYTableViewCell
        self.selectAtRow = indexPath.row
        self.selectRowAtIndexPathHandler!(indexPath: indexPath.row,cell:cell!)
        cell?.contentView.backgroundColor = self.configuration.cellSelectionColor
        
        self.reloadData()
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? XYTableViewCell
        
        cell?.contentView.backgroundColor = self.configuration.cellBackgroundColor
    }
}

// MARK: Table view cell
class XYTableViewCell: UITableViewCell {
    
    var checkmarkIcon: UIImageView!
    var cellContentFrame: CGRect!
    var configuration: XYConfiguration!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, configuration: XYConfiguration) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configuration = configuration
        
        // Setup cell
        cellContentFrame = CGRectMake(0, 0, (UIApplication.sharedApplication().keyWindow?.frame.width)!, self.configuration.cellHeight)
        self.contentView.backgroundColor = self.configuration.cellBackgroundColor
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.textLabel!.textAlignment = NSTextAlignment.Left
        self.textLabel!.textColor = self.configuration.cellTextLabelColor
        self.textLabel!.font = self.configuration.cellTextLabelFont
        self.textLabel!.frame = CGRectMake(20, 0, cellContentFrame.width, cellContentFrame.height)
        
        
        // Checkmark icon
        self.checkmarkIcon = UIImageView(frame: CGRectMake(cellContentFrame.width - 50, (cellContentFrame.height - 18)/2, 18, 18))
        
        self.checkmarkIcon.image = self.configuration.checkMarkImage
        self.checkmarkIcon.contentMode = UIViewContentMode.ScaleAspectFill
        self.contentView.addSubview(self.checkmarkIcon)
        
        // Separator for cell
        let separator = BTTableCellContentView(frame: cellContentFrame)
        if let cellSeparatorColor = self.configuration.cellSeparatorColor {
            separator.separatorColor = cellSeparatorColor
        }
        self.contentView.addSubview(separator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.bounds = cellContentFrame
        self.contentView.frame = self.bounds
    }
}

// Content view of table view cell
class BTTableCellContentView: UIView {
    var separatorColor: UIColor = UIColor.blackColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        
        // Set separator color of dropdown menu based on barStyle
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor)
        CGContextSetLineWidth(context, 1)
        CGContextMoveToPoint(context, 0, self.bounds.size.height)
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height)
        CGContextStrokePath(context)
    }
}

extension UIViewController {
    func XYTopMostViewController() -> UIViewController {
        if let navigation = self as? UINavigationController {
            if let visibleViewController = navigation.visibleViewController {
                return visibleViewController.XYTopMostViewController()
            }
        }
        if let tab = self as? UITabBarController {
            if let selectedViewController = tab.selectedViewController {
                return selectedViewController.XYTopMostViewController()
            }
        }
        return self
    }
}