//
//  AddressBookManager.swift
//  LisheSaas
//
//  Created by lishe on 2019/9/23.
//  Copyright © 2019 com.lishe.www. All rights reserved.
//

import UIKit
import Contacts

typealias addressBookListBlock = (_ list: Array<Any>) -> ()

class AddressBookManager: NSObject {
    static let shared = AddressBookManager()
    
    var addressBookListBlock: addressBookListBlock?
    
    /// 获取通讯录数据
    func getAddressBookList(completedBlock: @escaping addressBookListBlock) -> () {
        self.addressBookListBlock = completedBlock
        AuthorizeUtils.zl_authorizeContact { (granted) in
            if granted {
                self.getAddressBookList()
            }
        }
    }
    
    func getAddressBookList(){

        //创建通讯录对象
        let store = CNContactStore()
         
        //获取Fetch,并且指定要获取联系人中的什么属性
        let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]
         
        //创建请求对象
        //需要传入一个(keysToFetch: [CNKeyDescriptor]) 包含CNKeyDescriptor类型的数组
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
         
        //遍历所有联系人
        var addressList: Array = Array<Any>.init();
    
        do {
            try store.enumerateContacts(with: request, usingBlock: {
                (contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                
                var addressItem: [String : Any] = [String : Any]()
                
                //获取姓名
                let lastName = contact.familyName
                let firstName = contact.givenName
                let tempname: String = lastName+firstName
                if tempname.isEmpty {
                    addressItem["name"] = "##"
                } else{
                    addressItem["name"] = tempname
                }
                
                print("姓名：\(lastName)\(firstName)")
                 
                //获取电话号码
                print("电话：")
                var phoneNumbers: Array = Array<String>.init();
                for phone in contact.phoneNumbers {
                    //获得标签名（转为能看得懂的本地标签名，比如work、home）
                    var label = "未知标签"
                    if phone.label != nil {
                        label = CNLabeledValue<NSString>.localizedString(forLabel:
                            phone.label!)
                    }
                    
                    //获取号码
                    let value = phone.value.stringValue
                    print("\t\(label)：\(value)")
                    // 添加电话号码
                    phoneNumbers.append(value)
                }
                
                let phoneNumbersStr = phoneNumbers.joined(separator: ",")
                addressItem["phoneNumbers"] = phoneNumbersStr
                
                if !phoneNumbersStr.isEmpty {
                  addressList.append(addressItem)
                }
            })
        } catch {
            print(error)
        }
    
        if self.addressBookListBlock != nil {
            self.addressBookListBlock!(addressList)
        }
    }

}
