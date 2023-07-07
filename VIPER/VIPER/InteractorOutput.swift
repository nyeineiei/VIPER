//
//  InteractorOutput.swift
//  VIPER
//
//  Created by Nyein on 7/7/23.
//

import Foundation

protocol AnyInteractorOutput {
  func success(users: [User])
  func failed(error: Error)
}
