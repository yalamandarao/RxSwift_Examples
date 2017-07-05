//
//  ViewController.swift
//  Login
//
//  Created by Yalamandarao on 02/07/17.
//  Copyright © 2017 Apar Technologies. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class ViewController: UIViewController {

  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var errorLabel: UILabel!
  
  var disposeBag = DisposeBag()
  var loginViewModel = LoginViewModel()
  override func viewDidLoad() {
    super.viewDidLoad()
   
    loginTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.emailText).addDisposableTo(disposeBag)
    
    passwordTextField.rx.text.map { $0 ?? ""}.bind(to: loginViewModel.psswordText).addDisposableTo(disposeBag)
    
    loginViewModel.isValid.bind(to: loginButton.rx.isEnabled).addDisposableTo(disposeBag)
    
    loginViewModel.isValid.subscribe(onNext: { isValid in
      
      self.errorLabel.text = isValid ? "Enabled" : "Not Enabled"
      self.errorLabel.textColor = isValid ? .green : .red
      
    }).addDisposableTo(disposeBag)
    
  
    
    loginButton.rx.tap.asObservable().subscribe(onNext: { _ in
      self.loginViewModel.checkValidataion()
      
      self.loginViewModel.isSame?.map{ same in
        if same
        {
          return "login is okay"
        }
        else
        {
          return "login not okay"
        }
      }.bind(to: self.errorLabel.rx.text).addDisposableTo(self.disposeBag)
    
     print("clicketed \(String(describing: self.loginViewModel.isSame))")

    }).addDisposableTo(disposeBag)
    
    
    // Example for Observable
    
    let nameObservable = Observable.just("Singapore")
    
    nameObservable.subscribe{name in
      print(name)
      }.addDisposableTo(disposeBag)
    
    nameObservable.subscribe(onNext: { (name: String?) in
      print(name!)
    }).addDisposableTo(disposeBag)
    
    Observable<Int>.of(1,2,3,4,5).map { (value: Int) -> Int in
      return 10 * value
      }.subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)
  
    // Filter 
    
    Observable<Int>.of(2,30,23,45,4,26).filter{ $0 > 10}.subscribe(onNext: {
    print("hello \($0)")
    }).addDisposableTo(disposeBag)
    
    // merge
    
    let arrayOneObserver = Observable.of(1,2,3,4)
    let arrayTwoObserver = Observable.of(5,6,7,8)
    
    Observable.of(arrayOneObserver, arrayTwoObserver).merge().subscribe(onNext: {
      print("final data")
      print($0)
    }).addDisposableTo(disposeBag)
    
  }


}

