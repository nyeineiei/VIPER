//
//  Interactor.swift
//  VIPER
//
//  Created by Nyein on 6/7/23.
//

import Foundation

//protocol
//presenter

protocol AnyInteractor {
    //var presenter: AnyPresenter? { get set }
    var output: AnyInteractorOutput? { get set }
    
    func getUsers(session: URLSession, from url: URL?)
}

class UserInteractor: AnyInteractor {
    var output: AnyInteractorOutput?
    
//    var presenter: AnyPresenter?

    func getUsers(session: URLSession, from url: URL?) {
        //guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        guard let url = url else {
            self.output?.failed(error: FetchError.emptyURL)
            return
        }
        let task = session.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.output?.failed(error: FetchError.failed)
                //self?.presenter?.interactorDidFecthUsers(with: .failure(FetchError.failed))
                return
            }

            do {
                let entities = try JSONDecoder().decode([User].self, from: data)
                self?.output?.success(users: entities)
                //self?.presenter?.interactorDidFecthUsers(with: .success(entities))
            }
            catch {
                self?.output?.failed(error: FetchError.serverError)
                //self?.presenter?.interactorDidFecthUsers(with: .failure(error))
            }
        }

        task.resume()
    }
}
