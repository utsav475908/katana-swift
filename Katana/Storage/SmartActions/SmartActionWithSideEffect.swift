//
//  SmartActionWithSideEffect.swift
//  Katana
//
//  Created by Luca Querella on 30/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnySmartActionWithSideEffect : Action {
  
  static func anySideEffect<S: State>(action: Action,
                            state: S,
                            dispatch: StoreDispatch, 
                            dependencies: SideEffectsDependenciesContainer<S>?)
}

public protocol SmartActionWithSideEffect: Action, AnySmartActionWithSideEffect {
  associatedtype StateType : State

  static func sideEffect(action: Self,
                         state: StateType,
                         dispatch: StoreDispatch,
                         dependencies: SideEffectsDependenciesContainer<StateType>?)
}

