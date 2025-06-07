//
//  ContentView.swift
//  Buggy
//
//  Created by  Guillermo Ignacio Enriquez Gutierrez on 2025/06/07.
//

import SwiftUI

// MARK: - Content View

struct RootNavigationView: View {
    enum Destination: Hashable {
        case login
    }
    @State private var path = [Destination]()
    var body: some View {
        NavigationStack(path: $path) {
            WelcomeScreen(onGoToLogin: {
                path.append(.login)
            })
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .login:
                    LoginScreen()
                }
            }
        }

    }
}

// MARK: - Main Navigation Stack Views

struct WelcomeScreen: View {
    let onGoToLogin: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Go to 'Login'") {
                onGoToLogin()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Welcome")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LoginScreen: View {
    enum ModalType: String, Identifiable {
        case view3
        var id: String {
            return self.rawValue
        }
    }
    @State var modalType: ModalType?
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Show 'Home'") {
                modalType = .view3
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(
            item: $modalType,
            content: { modal in
                switch modal {
                case .view3:
                    MainNavigationView()
                }
            }
        )
    }
}

// MARK: - First Level Modal

struct MainNavigationView: View {
    @State var path: [Destination] = []
    enum Destination: Hashable {
        case detail
    }
    var body: some View {
        NavigationStack(path: $path) {
            HomeScreen()
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .detail:
                        Text("detail") // I never enter here. This is just to mimic my real app structure
                    }
                }
        }
    }
}

struct HomeScreen: View {
    @State var modalType: ModalType?
    enum ModalType: String, Identifiable {
        case loan
        var id: String {
            return self.rawValue
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Show 'Loan'") {
                modalType = .loan
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(
            item: $modalType,
            content: { modal in
                switch modal {
                case .loan:
                    LoanNavigationScreen()
                }
            }
        )
    }
}

// MARK: - Second Level Modal

struct LoanNavigationScreen: View {
    enum Destination: Hashable {
        case confirm
        case done
    }
    @State private var path: [Destination] = []
    var body: some View {
        NavigationStack(path: $path) {
            LoanSettingScreen(onGoToConfirm: {
                path.append(.confirm)
            })
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .confirm:
                    LoanConfirmScreen {
                        path.append(.done)
                    }
                case .done:
                    LoanCompleteScreen()
                }
            }
        }
    }
}

struct LoanSettingScreen: View {
    let onGoToConfirm: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Loan Setting")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Go to 'Confirm'") {
                onGoToConfirm()
            }
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Loan Setting")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LoanConfirmScreen: View {
    let onGoToDone: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Loan Confirm")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Go to 'Complete'") {
                onGoToDone()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Loan Confirm")
    }
}

struct LoanCompleteScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Loan Completed")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .navigationTitle("Loan Completed")
    }
}
