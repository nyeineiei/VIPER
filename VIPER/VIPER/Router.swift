//
//  Router.swift
//  VIPER
//
//  Created by Nyein on 6/7/23.
//

import Foundation
import UIKit

//protocol
//entry point
typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entry: EntryPoint? { get set }
    static func start() -> AnyRouter
}

class UserRouter: AnyRouter {
    var entry: EntryPoint?
    static func start() -> AnyRouter {
        let router = UserRouter()
        
        //Assign VIP
        var view: AnyView = UserViewController()
        var interactor: AnyInteractor = UserInteractor()
        var presenter: AnyPresenter = UserPresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        return router
    }
}
