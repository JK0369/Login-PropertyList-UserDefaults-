//
//  ViewController.swift
//  PropertyListTest
//
//  Created by 김종권 on 2020/05/05.
//  Copyright © 2020 mustang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var id: UITextField!
    var pw: UITextField!
    var name: UITextField!
    var age: UITextField!
    
    var btn: UIButton!
    var addBtn: UIButton!
    var accountList: [String]!
    
    var defaultPlist: NSDictionary!
    
    // ViewController.swift
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        
        // viewDidLoad()
        //////// read - 마지막에 로그인 했던 사용자의 정보 불러오기 /////
        //////////////  UserDefaults ///////////
        let obj = UserDefaults.standard
        if let name = obj.string(forKey: "selectedAccount") {
            self.name.text = name
            let customPlist = "\(name).plist" /// file name for the read data
            
            //////////////  Property List ///////////
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let plist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: plist)
            
            /// 앱을 다시 실행시키면 name부분과 age부분이 이전에 실행했던 정보 그대로 등록
            self.name.text = data?["name"] as? String
            self.age.text = data?["age"] as? String
        }
        
        // 템플릿 사용 - 참고용
        /// Property List Template Method
        self.defaultPlist = NSDictionary() /// var defaultPlist: NSDictionary!
        if let defaultPlistsPath = Bundle.main.path(forResource: "User", ofType: "plist") {
            
            self.defaultPlist = NSDictionary(contentsOfFile: defaultPlistsPath)
            
            /// 최초로 받을 땐 NSDictionary, 새로운 객체는 수정이 가능하게끔하기 위해 Mutable사용
            let data = NSMutableDictionary(contentsOfFile: defaultPlistsPath) ?? NSMutableDictionary(dictionary: self.defaultPlist)
            
            // data.setValue(...)
            // data.write(toFile: defaultPlistsPath, atomically: true)
        }
        
    }

    /// "add acount" 버튼의 터치 이벤트
    @objc func addAccount(_ sender: Any) {
        guard let name = name.text else {return}
        
        //////////////  UserDefaults ///////////
        let obj = UserDefaults.standard
        /// nil의 가능성이 있기 때문에 '??'연산자 이용
        var savedAccountList = obj.array(forKey: "accountList") ?? [String]()
        savedAccountList.append(name)
        
        obj.set(name, forKey: "selectedAccount")
        obj.synchronize()


        //////////////  Property List ///////////
        /// 저장될 이름 : "계정.plist"
        let customPlist = "\(self.name.text!).plist"
        
        /// .plist는 sandbox내에 존재, sandbox에는 디렉토리 전용 및 파일 전용이 따로 존재
        /// 첫 번째 인수 : 디렉토리 전용, 두 번째 인수 : 애플리케이션 범위, 세 번째 인수 : 전체 경로(true)인지 디렉토리명만(false)인지
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary()
            
        data.setValue(self.id.text!, forKey: "id")
        data.setValue(self.pw.text!, forKey: "password")
        data.setValue(self.name.text!, forKey: "name")
        data.setValue(self.age.text!, forKey: "age")
        
        data.write(toFile: plist as String, atomically: true)
        
        
        /// .plist 파일 확인
        print("plist = \n\(plist)")
    }
    
    @objc func myPrint(_ sender: Any) {
        print("tap!")
    }
    
    private func setLayout() {
        
        id = UITextField()
        pw = UITextField()
        btn = UIButton()
        
        name = UITextField()
        age = UITextField()
        
        addBtn = UIButton()
        
        
        id.placeholder = "id"
        pw.placeholder = "password"
        btn.setTitle("login", for: .normal)
        
        id.layer.borderColor = UIColor.darkGray.cgColor
        id.layer.borderWidth = 1
        id.textAlignment = .center
        
        pw.layer.borderColor = UIColor.darkGray.cgColor
        pw.layer.borderWidth = 1
        pw.textAlignment = .center
        
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.layer.borderWidth = 1
        btn.backgroundColor = .blue
        
        name.placeholder = "name"
        name.textAlignment = .center
        name.layer.borderColor = UIColor.darkGray.cgColor
        name.layer.borderWidth = 1
        
        age.placeholder = "age"
        age.textAlignment = .center
        age.layer.borderWidth = 1
        age.layer.borderColor = UIColor.darkGray.cgColor
        
        addBtn.setTitle("add account", for: .normal)
        addBtn.backgroundColor = .darkGray
        addBtn.addTarget(self, action: #selector(addAccount(_:)), for: .touchUpInside)
        
        for item in [id, pw, btn, name, age, addBtn] {
            view.addSubview(item!)
            item!.translatesAutoresizingMaskIntoConstraints = false
        }
        
        id.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        id.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        id.widthAnchor.constraint(equalToConstant: 200).isActive = true
        id.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        pw.topAnchor.constraint(equalTo: id.bottomAnchor, constant: 5).isActive = true
        pw.leftAnchor.constraint(equalTo: id.leftAnchor).isActive = true
        pw.rightAnchor.constraint(equalTo: id.rightAnchor).isActive = true
        
        btn.topAnchor.constraint(equalTo: id.topAnchor).isActive = true
        btn.leftAnchor.constraint(equalTo: id.rightAnchor, constant: 10).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        name.topAnchor.constraint(equalTo: pw.bottomAnchor, constant: 10).isActive = true
        name.leftAnchor.constraint(equalTo: pw.leftAnchor).isActive = true
        name.rightAnchor.constraint(equalTo: pw.rightAnchor).isActive = true
        
        age.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        age.leftAnchor.constraint(equalTo: name.leftAnchor).isActive = true
        age.rightAnchor.constraint(equalTo: name.rightAnchor).isActive = true
        
        addBtn.topAnchor.constraint(equalTo: age.bottomAnchor, constant: 10).isActive = true
        addBtn.leftAnchor.constraint(equalTo: pw.leftAnchor).isActive = true
        addBtn.widthAnchor.constraint(equalToConstant: 130).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
}
