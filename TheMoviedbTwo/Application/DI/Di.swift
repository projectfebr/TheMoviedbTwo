//
//  Di.swift
//  TheMoviedbTwo
//
//  Created by Aleksandr Bolotov on 01.03.2023.
//

import UIKit
import class Alamofire.Session

final class Di {
    
    fileprivate let configuration: Configuration
    fileprivate let session: Session
    fileprivate let requestBuilder: RequestBuilderImpl
    fileprivate let sessionRepository: SessionRepositoryImpl
    fileprivate let apiClient: ApiClient
    fileprivate let screenFactory: ScreenFactoryImpl
    fileprivate let coordinatorFactory: CoordinatorFactoryImpl
    fileprivate var authenticatorService: AuthenticatorServiceImpl
    
    fileprivate var loginProvider: LoginProviderImpl {
        return LoginProviderImpl(authenticator: authenticatorService)
    }

    init() {
        configuration = ProductionConfiguration()
        session = Session.default
        requestBuilder = RequestBuilderImpl(configuration: configuration)
        sessionRepository = SessionRepositoryImpl()
        apiClient = ApiClient(requestBuilder: requestBuilder, session: session)
        screenFactory = ScreenFactoryImpl()
        coordinatorFactory = CoordinatorFactoryImpl(screenFactory: screenFactory)
        authenticatorService = AuthenticatorServiceImpl(sessionRepository: sessionRepository, accountApiClient: apiClient)
        
        screenFactory.di = self
    }
}

protocol AppFactory {
    func makeKeyWindowWithCoordinator() -> (UIWindow, Coordinator)
}

extension Di: AppFactory {
    
    func makeKeyWindowWithCoordinator() -> (UIWindow, Coordinator) {
        let window = UIWindow()
        let rootVC = UINavigationController()
        rootVC.navigationBar.prefersLargeTitles = true
        let router = RouterImp(rootController: rootVC)
        let cooridnator = coordinatorFactory.makeApplicationCoordinator(router: router)
        window.rootViewController = rootVC
        return (window, cooridnator)
    }
    
}

// в принципе можно здесь на закрывать протоколом ()
protocol ScreenFactory {
    func makeSplashScreen() -> UIViewController
    func makeLoginScreen() -> LoginScreenVC<LoginScreenViewImpl>
}


final class ScreenFactoryImpl: ScreenFactory {
    
    fileprivate weak var di: Di!
    fileprivate init(){}
    
    func makeSplashScreen() -> UIViewController {
        let view = SplashScreenView.loadFromNib()
        return ContainerViewController(rootView: view)
    }
    
    func makeLoginScreen() -> LoginScreenVC<LoginScreenViewImpl> {
        return LoginScreenVC<LoginScreenViewImpl>(loginProvider: di.loginProvider)
    }
}

protocol CoordinatorFactory {
    
    func makeApplicationCoordinator(router: Router) -> ApplicationCoordinator
    func makeLoginCoordinator(router: Router) -> LoginCoordinator
    
}

final class CoordinatorFactoryImpl: CoordinatorFactory {
    
    private let screenFactory: ScreenFactory
    
    fileprivate init(screenFactory: ScreenFactory){
        self.screenFactory = screenFactory
    }
    
    func makeApplicationCoordinator(router: Router) -> ApplicationCoordinator {
        return ApplicationCoordinator(router: router, coordinatorFactory: self)
    }
    
    func makeLoginCoordinator(router: Router) -> LoginCoordinator {
        return LoginCoordinator(router: router, screenFactory: screenFactory)
    }
    
}
