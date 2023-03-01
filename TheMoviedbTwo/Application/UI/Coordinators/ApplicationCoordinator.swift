import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: CoordinatorFactoryImpl
    private let router: Router
    private let screenFactory: ScreenFactory
    private var isAutorized = false
    
    
    init(router: Router, coordinatorFactory: CoordinatorFactoryImpl, screenFactory: ScreenFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.screenFactory = screenFactory

    }
    
    override func start() {
        showSplash()
    }
    
    private func showSplash() {
        let splashScreen = screenFactory.makeSplashScreen()
        router.setRootModule(splashScreen)
    }
    
}
