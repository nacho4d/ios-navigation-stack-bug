//
//  ContentView2.swift
//  ExampleTransition
//
//  Created by  Guillermo Ignacio Enriquez Gutierrez on 2025/06/07.
//

import SwiftUI

// MARK: - Navigation Enums

enum MainDestination: Hashable {
    case view2
}

enum FirstModal: String, Identifiable {
    case view3
    var id: String { self.rawValue }
}

enum SecondDestination: Hashable {
    case viewB
    case viewC
}

enum SecondModal: String, Identifiable {
    case viewABC
    var id: String { self.rawValue }
}

// MARK: - Content View

struct ContentView: View {
    @State private var mainPath = NavigationPath()
    @State private var firstModal: FirstModal?

    var body: some View {
        NavigationStack(path: $mainPath) {
            View1(mainPath: $mainPath, firstModal: $firstModal)
                .navigationDestination(for: MainDestination.self) { destination in
                    switch destination {
                    case .view2:
                        View2(firstModal: $firstModal)
                    }
                }
        }
        .fullScreenCover(item: $firstModal) { modal in
            switch modal {
            case .view3:
                ModalView()
            }
        }
    }
}

// MARK: - Main Navigation Stack Views

struct View1: View {
    @Binding var mainPath: NavigationPath
    @Binding var firstModal: FirstModal?

    var body: some View {
        VStack(spacing: 20) {
            Text("View 1")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Go to View 2") {
                mainPath.append(MainDestination.view2)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("View 1")
    }
}

struct View2: View {
    @Binding var firstModal: FirstModal?

    var body: some View {
        VStack(spacing: 20) {
            Text("View 2")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Show Modal") {
                firstModal = .view3
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("View 2")
    }
}

// MARK: - First Modal (NavigationStack with View3)

struct ModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var secondModal: SecondModal?

    var body: some View {
        NavigationStack {
            View3(secondModal: $secondModal)
                .navigationTitle("Modal")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
        }
        .fullScreenCover(item: $secondModal) { modal in
            switch modal {
            case .viewABC:
                SecondModalView()
            }
        }
    }
}

struct View3: View {
    @Binding var secondModal: SecondModal?

    var body: some View {
        VStack(spacing: 20) {
            Text("View 3")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Show Second Modal") {
                secondModal = .viewABC
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("View 3")
    }
}

// MARK: - Second Modal (NavigationStack with ViewA, ViewB, ViewC)

struct SecondModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var secondPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $secondPath) {
            ViewA(secondPath: $secondPath)
                .navigationTitle("Second Modal")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
                .navigationDestination(for: SecondDestination.self) { destination in
                    switch destination {
                    case .viewB:
                        ViewB(secondPath: $secondPath)
                    case .viewC:
                        ViewC(dismiss: dismiss)
                    }
                }
        }
    }
}

struct ViewA: View {
    @Binding var secondPath: NavigationPath

    var body: some View {
        VStack(spacing: 20) {
            Text("View A")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Go to View B") {
                secondPath.append(SecondDestination.viewB)
            }
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("View A")
    }
}

struct ViewB: View {
    @Binding var secondPath: NavigationPath

    var body: some View {
        VStack(spacing: 20) {
            Text("View B")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Go to View C") {
                secondPath.append(SecondDestination.viewC)
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("View B")
    }
}

struct ViewC: View {
    let dismiss: DismissAction

    var body: some View {
        VStack(spacing: 20) {
            Text("View C")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Dismiss Modal & Back to View 3") {
                dismiss()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("View C")
    }
}
