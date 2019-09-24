//
//  ShareContentView.swift
//  LiShePlus
//
//  Created by lishe on 2019/5/8.
//  Copyright © 2019 lishe. All rights reserved.
//

import UIKit
import SnapKit

protocol ShareContentViewDelagate: NSObjectProtocol {
    /// 取消分享
    func shareContentViewCancelShare()
    /// 分享到
    func shareContentView(shareToPlatform: UMSocialPlatformType)
}

class ZL_ShareContentView: ZLBasePopContentView {

    var menuItemArr = [Any]()
    
    weak var delegate : ShareContentViewDelagate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.configSharePlatForms()
        
        self.setupBaseLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSharePlatForms() {
        if UMSocialManager.default()?.isInstall(.wechatSession) == true {
            var wechatItem = ZLSharePlatformItemModel()
            wechatItem.title = "微信"
            wechatItem.icon = "share_ic_wechat"
            wechatItem.platform = .wechatSession
            self.menuItemArr.append(wechatItem)
        }
        
        if UMSocialManager.default()?.isInstall(.wechatTimeLine) == true {
            var wechatLineItem = ZLSharePlatformItemModel()
            wechatLineItem.title = "微信朋友圈"
            wechatLineItem.icon = "share_ic_moment"
            wechatLineItem.platform = .wechatTimeLine
            self.menuItemArr.append(wechatLineItem)
        }
        
        if UMSocialManager.default()?.isInstall(.QQ) == true {
            var qqItem = ZLSharePlatformItemModel()
            qqItem.title = "QQ"
            qqItem.icon = "share_ic_qq"
            qqItem.platform = .QQ
            self.menuItemArr.append(qqItem)
        }
        
        if UMSocialManager.default()?.isInstall(.qzone) == true {
            var qZoneItem = ZLSharePlatformItemModel()
            qZoneItem.title = "QQ空间"
            qZoneItem.icon = "share_ic_qzone"
            qZoneItem.platform = .qzone
            self.menuItemArr.append(qZoneItem)
        }
        
        
        var copyItem = ZLSharePlatformItemModel()
        copyItem.title = "复制链接"
        copyItem.icon = "share_ic_link"
        copyItem.platform = UMSocialPlatformType(rawValue: UMSocialPlatformType.userDefine_Begin.rawValue + 1)!
        self.menuItemArr.append(copyItem)
        
    }
    
    func setupBaseLayout() {
        
        // 标题
        let lb_title = UILabel.init()
        self.addSubview(lb_title)
        lb_title.frame = CGRect.init(x: 0, y: 10, width: SCREEN_WIDTH, height: 35)
        lb_title.text = "选择要分享到的平台"
        lb_title.textColor = ZLGrayTextColor()
        lb_title.font = UIFont.systemFont(ofSize: 13)
        lb_title.textAlignment = .center
        
        
        // 底部取消啊那妞
        let footerView = UIView()
        self.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(45+kBottomSafeMargin)
        }
        footerView.backgroundColor = RGBAColor(r: 230, g: 230, b: 230, a: 1)
        
        let btn_cancel = UIButton.init(type: .custom)
        footerView.addSubview(btn_cancel)
        btn_cancel.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0);
            make.height.equalTo(45)
        }
        btn_cancel.setTitle("取消", for: .normal)
        btn_cancel.setTitleColor(ZLBlackTextColor(), for: .normal)
        btn_cancel.addTarget(self, action: #selector(cancelShareClick), for: .touchUpInside)
        
        // content 分享按钮 platform
        self.setupShareMenuView()
    }
    
    
    func setupShareMenuView() {
        //UI
        let scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-45-kBottomSafeMargin)
            make.top.equalTo(45)
        }
        scrollView.backgroundColor = UIColor.white
        scrollView.bounces = false
        
        let row: CGFloat = 5
        let margin: CGFloat = 10
        let pading: CGFloat = 5
        let Temp: CGFloat = CGFloat(SCREEN_WIDTH - margin*2) - (row - 1) * pading
        let picW: CGFloat = Temp / row
        let picH: CGFloat = 100
        let Y: CGFloat = 5
        for (i,item) in self.menuItemArr.enumerated() {
            let platform = item as! ZLSharePlatformItemModel
            let _x = margin + (CGFloat(i) * CGFloat(picW + pading))
            let itemView = UIView.init(frame: CGRect.init(x: CGFloat(_x), y: CGFloat(Y), width: CGFloat(picW), height: CGFloat(picH)))
            scrollView.addSubview(itemView)
            
            let imgV = UIImageView.init(image: UIImage.init(named: platform.icon))
            itemView.addSubview(imgV)
            
            imgV.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.size.equalTo(CGSize.init(width: 50, height: 50))
                make.centerX.equalTo(itemView)
            }
            
            let lb_platform = UILabel.init()
            itemView.addSubview(lb_platform)
            lb_platform.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.bottom.equalTo(-10)
                make.height.equalTo(20)
            }
            lb_platform.text = platform.title
            lb_platform.textColor = ZLGrayTextColor()
            lb_platform.font = UIFont.systemFont(ofSize: 12)
            lb_platform.textAlignment = .center
            
            // 按钮
            let btn_cover = UIButton.init(type: .custom)
            itemView.addSubview(btn_cover)
            btn_cover.frame = itemView.bounds
            btn_cover.tag = i
            btn_cover.addTarget(self, action: #selector(platformClick(sender:)), for: .touchUpInside)
        }
        
        let TempW = (picW + pading) * CGFloat(self.menuItemArr.count)
        scrollView.contentSize = CGSize.init(width: Int(TempW + margin*2 - pading) , height: 0)
    }
    
}

extension ZL_ShareContentView{
    @objc func cancelShareClick() {
        delegate?.shareContentViewCancelShare()
    }
    
    @objc func platformClick(sender: UIButton) {
        let item: ZLSharePlatformItemModel = self.menuItemArr[sender.tag] as! ZLSharePlatformItemModel
        
        let platform: UMSocialPlatformType = item.platform
        
        delegate?.shareContentView(shareToPlatform: platform)
    }
}
