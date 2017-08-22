//
//  LeftSlideVC.swift
//  TempApp
//
//  Created by ios2 on 2017/8/21.
//  Copyright © 2017年 ios2. All rights reserved.
//  开局已写好,代码全靠改.能帮助一个是一个.这我也是从别人OC代码哪里 翻译过来的。自己解决了一些坑。

import UIKit



class LeftSlideMenu: UIViewController,UIGestureRecognizerDelegate {

    static let menuWidthScale: CGFloat = 0.75
    static let menuCoverAlpha: CGFloat = 0.2
    
    /// 左视图
    var leftViewController: UIViewController!
    /// 右视图
    var mainViewController: UIViewController!
    
    fileprivate var  originalPoint: CGPoint = .zero
    
    /// 遮罩视图
    fileprivate lazy var coverView: UIView = { [unowned self ] in
    let coverView:UIView = UIView(frame: self.view.bounds)
        coverView.backgroundColor = UIColor.black
        coverView.isHidden = true
        coverView.alpha = 0
        return coverView
    }()
   /// 菜单宽度
   fileprivate var  menuWidth: CGFloat = UIScreen.main.bounds.size.width * menuWidthScale
   /// 剩余宽度
   fileprivate var  emptyWith: CGFloat = UIScreen.main.bounds.size.width * (1 - menuWidthScale)
    

    
    convenience init(leftViewController: UIViewController,mainViewController: UIViewController) {
        
        self.init()
        
        self.addChildViewController(leftViewController)
        self.addChildViewController(mainViewController)
        
        self.leftViewController = leftViewController
        self.mainViewController = mainViewController
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.leftViewController.view)
        self.view.addSubview(self.mainViewController.view)

        
    }
    
    /// 复写获取navigationController方法
    override var navigationController: UINavigationController?{
    
        get{
        
            if self.mainViewController is UINavigationController {
                
                return self.mainViewController as? UINavigationController
                
                
            }else if self.mainViewController is UITabBarController{
                
                let tabVC = self.mainViewController as! UITabBarController
                
                if tabVC.selectedViewController is UINavigationController {
                    
                    return tabVC.selectedViewController as? UINavigationController
                }
                
            }

        
            return nil

        }
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do{//根据个人情况。添加手势
            
            
            for viewController in self.mainViewController.childViewControllers {
                
                let pan = UIPanGestureRecognizer.init(target: self, action:#selector(self.handlePan(_:)) )
                pan.delegate = self
                
                if viewController is UINavigationController {
                    
                    let initVC = viewController as! UINavigationController
                    
                        initVC.topViewController!.view.addGestureRecognizer(pan)
                }else{
                    
                        viewController.view.addGestureRecognizer(pan)
                }
            }
            let pan = UIPanGestureRecognizer.init(target: self, action:#selector(self.handlePan(_:)) )
            pan.delegate = self
            coverView.addGestureRecognizer(pan)
        }
        
        
        do{//添加布局代码
        
            
            let pan = UITapGestureRecognizer.init(target: self, action:#selector(self.handleTap(_:)) )
            
            coverView.addGestureRecognizer(pan)
            
            self.mainViewController.view.addSubview(coverView)
            
            self.mainViewController.view.bringSubview(toFront: coverView)
            
            coverView.translatesAutoresizingMaskIntoConstraints = false
            
            let coverViewH = "H:|[a]|"
            let views1 = ["a": coverView]
            
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: coverViewH, options:.directionLeftToRight, metrics: nil, views: views1)
            self.mainViewController.view.addConstraints(constraints)
            
            
            
            let coverViewV = "V:|[a]|"
       
            let constraints2 = NSLayoutConstraint.constraints(withVisualFormat: coverViewV, options: .directionLeftToRight, metrics: nil, views: views1)
            
            
            self.mainViewController.view.addConstraints(constraints2)
            
//            coverView.snp.makeConstraints({ (make) in
//                make.edges.equalToSuperview()
//            })
        }
        
    }
    
   /// 拖拽手势
   ///
   /// - Parameter pan: 处理拖拽手势
   @objc fileprivate func handlePan(_ pan: UIPanGestureRecognizer){
    
        switch pan.state {
            case .began:
                
                originalPoint = CGPoint(x: self.mainViewController.view.frame.minX, y: self.mainViewController.view.frame.midY)
                
            case .changed:
                let point = pan.translation(in: self.view)
                
                var x = originalPoint.x + point.x
                
                //最左侧边界x=0
                x = x > 0 ? x : 0
                //最右侧边界 x  = self.menuW
                x = x < menuWidth ? x : menuWidth
                
                self.mainViewController.view.center = CGPoint(x: x + self.mainViewController.view.frame.width / 2.0, y: self.mainViewController.view.frame.midY)
                
                
                self.updateLeftViewFrame()
                self.coverView.isHidden = false
                self.coverView.alpha = self.mainViewController.view.frame.minX / self.menuWidth * LeftSlideMenu.menuCoverAlpha
            

            case .ended:
                
                if self.mainViewController.view.frame.minX <= self.menuWidth / 2 {
                    
                    self.closeLeftView()
                }else
                {
                    self.openLeftView()
                }
           default: print("日狗")
        }
    
    }
    
   /// 遮罩点击手势
   ///
   /// - Parameter pan: 点击手势
   @objc fileprivate func handleTap(_ pan: UIPanGestureRecognizer){
        
        
        self.closeLeftView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
   /// 是否允许触发某些范围
   ///
   /// - Parameters:
   ///   - gestureRecognizer: 手势
   ///   - touch: 触摸点
   /// - Returns: 返回bool
   internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return true
    }
    
    
    
   /// 更新左视图的Frame
   fileprivate func updateLeftViewFrame(){
        
        
        self.leftViewController.view.center = CGPoint(x: (self.mainViewController.view.frame.minX + self.emptyWith)/2.0, y: self.mainViewController.view.frame.midY)

        
    }
    
    
    /// 打开左视图
    func openLeftView(){
    
        self.coverView.isHidden = false;
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.mainViewController.view.center = CGPoint(x: self.view.frame.width / 2.0 + self.menuWidth, y: self.mainViewController.view.frame.midY)
            
            self.updateLeftViewFrame()
            
            self.coverView.alpha = LeftSlideMenu.menuCoverAlpha
            
            
        }) { (finished) in

            
        }
        
    }
    
    /// 关闭左视图
    func closeLeftView() {
        
        UIView.animate(withDuration: 0.25, animations: {
            

            self.mainViewController.view.center = CGPoint(x: self.mainViewController.view.frame.width / 2.0 , y: self.mainViewController.view.frame.midY)
            self.updateLeftViewFrame()
            self.coverView.alpha = 0
            
        }) { (finished) in
            self.coverView.isHidden = true
            
        }
        
        
    }
    
    
    //方法已经被废弃了。 专门处理屏幕旋转的时候  Frame的变化
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
    }

}


