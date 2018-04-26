//
//  ViewController.swift
//  DownTime
//
//  Created by 江其 on 2018/4/25.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit

class DownTimeCell: UITableViewCell {
    
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var label4 = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label1.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        self.contentView.addSubview(label1)
        
        label2.frame = CGRect(x: 100, y: 0, width: 100, height: 25)
        self.contentView.addSubview(label2)
        
        label3.frame = CGRect(x: 100, y: 25, width: 100, height: 25)
        self.contentView.addSubview(label3)
        label3.textColor = .white
        
        label4.frame = CGRect(x: 275, y: 0, width: 100, height: 50)
        self.contentView.addSubview(label4)
        
        label1.backgroundColor = .red
        label2.backgroundColor = .orange
        label3.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//兼容后台模式，最低的 CPU 消耗，
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var dataSource: [Int] = []
    
    var downTime = 0
    
    var isSlide: Bool = false
    
    //MARK: 切记一定要取消这个timer,否则会内存泄露
    var timer: DispatchSourceTimer? = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
    
    deinit {
        print("ViewController -> deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
        //程序已经返回前提啊并且已激活
        NotificationCenter.default.addObserver(self, selector: #selector(changIsSlideState), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        //已经进入后台
        NotificationCenter.default.addObserver(self, selector: #selector(changIsSlideState), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)

        
        for _ in 0..<35 {
            let a = arc4random()%210+90
            
            self.dataSource.append(Int(a))
        }
        
        print("\(self.dataSource)")
        
        timer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(10))

        timer?.setEventHandler {
            DispatchQueue.main.async {
                print("-----\(self.downTime)")
                self.downTime += 1
                self.updateTableview()
            }
        }
       
        self.table.rowHeight = 50.0
        self.table.register(DownTimeCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        timer?.resume()
        
    }
    
    @objc func changIsSlideState(notifi: NSNotification) {
        
        if notifi.name == NSNotification.Name.UIApplicationDidBecomeActive  {
            //已经激活，允许刷新
            self.isSlide = false
            
        }else if notifi.name == NSNotification.Name.UIApplicationDidEnterBackground  {
            //已经进入后台，禁止刷新
            self.isSlide = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: DownTimeCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DownTimeCell
        
//        print("\(self.dataSource[indexPath.row])---\(self.downTime)")
        
        cell.label1.text = "时间"+ViewController.stringFromDownTime(timeS: self.dataSource[indexPath.row] - self.downTime)
        cell.label2.text = "原始时间\(self.dataSource[indexPath.row])"
        cell.label3.text = "第\(self.downTime)秒"

        cell.label4.text = "第\(indexPath.row)行"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.timer?.cancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.isSlide = true
        //在手动的刷新 table scrollViewDidEndDragging执行之后这个方法还是为执行一次，故不在这个方法里面判断
//        print("滚动")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isSlide = true
        NSLog("将要开始拖动")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      
        //MARK: -  当结束拖动时速度已经为0，那么WillBeginDecelerating和DidEndDecelerating将不会执行
        
        var level = "减速"
        
        if !decelerate {
            //速度已经为0
            level = "不减速"
            self.isSlide = false
        }
        
        NSLog("已经结束拖动=="+level)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        NSLog("将要开始减速")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isSlide = false
        NSLog("已经结束减速--是否拖动\(scrollView.isDragging)--师傅减速\(scrollView.isDecelerating)")
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        //MARK:当点击状态栏时滚动到最上面会执行
        self.isSlide = false
        NSLog("已经滚动到最上面")
    }
    
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        
        print("状态栏点击")
        self.isSlide = true
        return true
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //MARK:代码滚动会执行
        self.isSlide = false
        NSLog("已经结束滚动动画--是否拖动\(scrollView.isDragging)--师傅减速\(scrollView.isDecelerating)")
    }
    
    class func stringFromDownTime(timeS: Int) -> String {
        
        
        let minute = timeS/60
        let second = timeS%60
        
        
        let string = String(format: "%02d:%02d", arguments:[minute,second])

        return string
    }
    
    func updateTableview() {
        if !self.isSlide {
            if self.table.indexPathsForVisibleRows != nil {
                self.table.reloadRows(at: self.table.indexPathsForVisibleRows!, with: .none)
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

