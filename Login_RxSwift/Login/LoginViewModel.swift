//
//  LoginViewModel.swift
//  Login
//
//  Created by Yalamandarao on 02/07/17.
//  Copyright © 2017 Apar Technologies. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ILoginViewModel {
  
  var isSame: Observable<Bool>? { get }
}

class LoginViewModel: ILoginViewModel {
  
  var isSame: Observable<Bool>?

  
  var emailText   = Variable<String>("")
  var psswordText = Variable<String>("")
  
  var isValid: Observable<Bool> {
    return Observable.combineLatest(emailText.asObservable(), psswordText.asObservable()) {email, password  in email.characters.count >= 3 && password.characters.count >= 3
    }
  }
  
  
  func checkValidataion() {
    isSame = Observable.combineLatest(emailText.asObservable(), psswordText.asObservable()) { email, password in email == "yala" && password == "1234"}
  }
  
//  var isValidLogin: Observable<Bool> {
//    return Observable.combineLatest(emailText.asObservable(), psswordText.asObservable()) { email, password in email == "yala" && password == "1234"
//
//    }
//  }
}
