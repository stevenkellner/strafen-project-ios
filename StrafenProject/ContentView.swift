//
//  ContentView.swift
//  StrafenProject
//
//  Created by Steven on 06.04.23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var settingsManager = SettingsManager()
    
    @StateObject private var imageStorage = FirebaseImageStorage()
        
    @State private var activeBottomBarItem: BottomBar.Item = .profile
    
    @State private var appPropertiesConnectionState: ConnectionState<AppProperties, Void> = .notStarted
    
    var body: some View {
        VStack {
            if let signedInPerson = self.settingsManager.signedInPerson {
                HStack {
                    switch self.appPropertiesConnectionState {
                    case .notStarted, .loading:
                        self.mainPages
                            .environmentObject(AppProperties.randomPlaceholder(signedInPerson: signedInPerson))
                            .redacted(reason: .placeholder)
                    case .passed(value: let appProperties):
                        self.mainPages
                            .environmentObject(appProperties)
                    case .failed(reason: _):
                        if self.activeBottomBarItem == .settings {
                            SettingsEditor()
                        } else {
                            self.fetchAppPropertiesFailed(signedInPerson: signedInPerson)
                        }
                    }
                }.bottomBar(active: self.$activeBottomBarItem)
                    .task {
                        self.activeBottomBarItem = .profile
                        await self.fetchAppProperties(signedInPerson: signedInPerson)
                    }
            } else {
                StartPageView()
                    .onAppear {
                        self.imageStorage.clear()
                    }
            }
        }.environmentObject(self.imageStorage)
            .environmentObject(self.settingsManager)
    }
    
    @ViewBuilder private func fetchAppPropertiesFailed(signedInPerson: Settings.SignedInPerson) -> some View {
        NavigationView {
            VStack {
                Text("content-view|loading-failed|message", comment: "App loading failed message.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                Button {
                    Task {
                        await self.fetchAppProperties(signedInPerson: signedInPerson)
                    }
                } label: {
                    Text("content-view|loading-failed|button", comment: "App loading failed try again button.")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                }.buttonStyle(.borderedProminent)
                    .padding(.horizontal)
            }.navigationTitle(String(localized: "content-view|loading-failed|title", comment: "App loading failed title."))
                .navigationBarTitleDisplayMode(.large)
        }
    }
    
    @ViewBuilder private var mainPages: some View {
        switch self.activeBottomBarItem {
        case .profile:
            Profile()
        case .personList:
            PersonList()
        case .reasonTemplateList:
            ReasonTemplateList()
        case .addNewFine:
            FineAddAndEdit(shownOnSheet: false)
        case .settings:
            SettingsEditor()
                .unredacted()
        }
    }
    
    private func fetchAppProperties(signedInPerson: Settings.SignedInPerson) async {
        guard self.appPropertiesConnectionState.restart() == .passed else {
            return
        }
        do {
            let appProperties = try await AppProperties.fetch(with: signedInPerson)
            self.appPropertiesConnectionState.passed(value: appProperties)
        } catch {
            self.appPropertiesConnectionState.failed()
        }
    }
}
