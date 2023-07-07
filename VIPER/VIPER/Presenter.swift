//
//  Presenter.swift
//  VIPER
//
//  Created by Nyein on 6/7/23.
//

import Foundation

//protocol
//VIR

enum FetchError: Error {
    case failed 
}

protocol AnyPresenter {
    var router: AnyRouter? { get set }
    var view: AnyView? { get set }
    var interactor: AnyInteractor? { get set }
    
    func interactorDidFecthUsers(with result: Result<[User], Error>)
}

class UserPresenter: AnyPresenter {
    var router: AnyRouter?
    
    var view: AnyView?
    
    var interactor: AnyInteractor? {
        didSet {
            interactor?.getUsers()
        }
    }
    
    func interactorDidFecthUsers(with result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            view?.update(with: users)
        case .failure:
            view?.update(with: "Something went wrong")
        }
    }
}
