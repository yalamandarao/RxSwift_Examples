//
//  ViewController.swift
//  Demo1
//
//  Created by Yalamandarao on 30/06/17.
//  Copyright © 2017 Apar Technologies. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  enum State: Int {
    case useButtons
    case useTextFiled
  }
  
  @IBOutlet weak var stateSegmentedControl: UISegmentedControl!
  @IBOutlet weak var greetingsLabel: UILabel!
  @IBOutlet weak var greetingsTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  
  let lastSelectedGreeting: Variable<String> = Variable("Hello")
  @IBOutlet var greetingButtons: [UIButton]!
  
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nameObservable: Observable<String?> = nameTextField.rx.text.asObservable()
    let customObservable: Observable<String?> = greetingsTextField.rx.text.asObservable()
    
    let greetingMessageObservable: Observable<String> = Observable.combineLatest(nameObservable, customObservable) { (string1: String?, string2: String?) in
      return string1! + ", " + string2!
    }
    
    greetingMessageObservable.bind(to: self.greetingsLabel.rx.text).addDisposableTo(disposeBag)
    
    // Text field enable
    
    let segmentControlObservable: Observable<Int> = stateSegmentedControl.rx.value.asObservable()
    
    let segmentStateObservable: Observable<State> = segmentControlObservable.map { (selectedIndex: Int)->  State in
      return State(rawValue: selectedIndex)!
    }
    
    let greetingTextFiledEnableObservable: Observable<Bool> = segmentStateObservable.map { (state: State) -> Bool in
      return state == .useTextFiled
    }
    
    greetingTextFiledEnableObservable.bind(to: greetingsTextField.rx.isEnabled).addDisposableTo(disposeBag)
    
    // Button enable
    
    let greetingButtonEnableObservable: Observable<Bool> = greetingTextFiledEnableObservable.map { (greetingEnable: Bool) -> Bool in
      return !greetingEnable
    }
    
    greetingButtons.forEach { button in
      greetingButtonEnableObservable.bind(to: button.rx.isEnabled).addDisposableTo(disposeBag)
      button.rx.tap.subscribe(onNext: { (nothing: Void) in
        self.lastSelectedGreeting.value = button.currentTitle!
      }).addDisposableTo(disposeBag)
    }
    
    let predefindGreetingObservable: Observable<String> = self.lastSelectedGreeting.asObservable()
    
 
    
    let finalGreetingObservable: Observable<String> = Observable.combineLatest(segmentStateObservable, customObservable, predefindGreetingObservable, nameObservable) {(state: State, string1: String?, buttonString: String, stringName: String?) -> String in
      
      switch state{
      case .useTextFiled: return string1! + ", " + stringName!
      case .useButtons: return buttonString + ", " + stringName!
      }
    }
    
    finalGreetingObservable.bind(to: self.greetingsLabel.rx.text).addDisposableTo(disposeBag)
    
 
    
    
    // One approach
  /*  nameObservable.subscribe({ (event: Event<String?>) in
      switch event {
      case .completed: print("complted")
      case .error(_): print("error")
      case .next(let finalString): print(finalString)
      }
    })*/
    
   // Secon Approach 
    
  /*  nameObservable.subscribe(onNext: { (string: String?) in
      self.greetingsLabel.text = string
    }).addDisposableTo(disposeBag)*/
    
    // final Approach

    //nameObservable.bind(to: self.greetingsLabel.rx.text).addDisposableTo(disposeBag)

  }
  
  
  
}


//Link : https://www.youtube.com/watch?v=pBGbA-bvZF0

