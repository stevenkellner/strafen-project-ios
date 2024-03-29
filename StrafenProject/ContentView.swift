//
//  ContentView.swift
//  StrafenProject
//
//  Created by Steven on 06.04.23.
//

import SwiftUI
import UserNotifications
import FirebaseMessaging

struct ContentView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var settingsManager = SettingsManager()
    
    @StateObject private var imageStorage = FirebaseImageStorage.shared
    
    @StateObject private var dismissHandler = DismissHandler()
        
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
                            .onChange(of: self.scenePhase) { scenePhase in
                                if scenePhase == .active {
                                    Task {
                                        await appProperties.refresh()
                                    }
                                }
                            }
                            .environmentObject(appProperties)
                    case .failed(reason: _):
                        if self.activeBottomBarItem == .settings {
                            SettingsEditor()
                                .environmentObject(AppProperties.randomPlaceholder(signedInPerson: signedInPerson))
                        } else {
                            self.fetchAppPropertiesFailed(signedInPerson: signedInPerson)
                        }
                    }
                }.bottomBar(active: self.$activeBottomBarItem)
                    .environmentObject(self.dismissHandler)
                    .task {
                        await self.onAppearOfMainPages(signedInPerson: signedInPerson)
                    }
            } else {
                StartPageView()
                    .onAppear {
                        self.appPropertiesConnectionState = .notStarted
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
            FineAddAndEdit(referrer: .addNewTab)
        case .settings:
            SettingsEditor()
                .unredacted()
        }
    }
    
    private func onAppearOfMainPages(signedInPerson: Settings.SignedInPerson) async {
        self.activeBottomBarItem = .profile
        await withTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask {
                await self.fetchAppProperties(signedInPerson: signedInPerson)
            }
            taskGroup.addTask {
                await self.requestNotification(signedInPerson: signedInPerson)
            }
        }
    }
    
    private func fetchAppProperties(signedInPerson: Settings.SignedInPerson) async {
        guard self.appPropertiesConnectionState.restart() == .passed else {
            return
        }
        do {
            let appProperties = try await AppProperties.fetch(with: signedInPerson)
            appProperties.observe()
            self.appPropertiesConnectionState.passed(value: appProperties)
        } catch {
            self.appPropertiesConnectionState.failed()
        }
    }
    
    private func requestNotification(signedInPerson: Settings.SignedInPerson) async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            guard granted else {
                return
            }
            let token = try await Messaging.messaging().token()
            let notificationRegisterFunction = NotificationRegisterFunction(clubId: signedInPerson.club.id, personId: signedInPerson.id, token: token)
            try await FirebaseFunctionCaller.shared.call(notificationRegisterFunction)
        } catch {}
    }
}
