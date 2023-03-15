//
//  PatchWork_SportsApp.swift
//  PatchWork Sports
//
//  Created by Brennan Adams on 3/14/23.
//

import SwiftUI

@main
struct PatchworkSportsApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct Workout: Identifiable {
    let id = UUID()
    let name: String
    let completionRate: Double
}

struct MainView: View {
    var body: some View {
        TabView {
            WorkoutsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Workouts")
                }
            
            ProgressView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Progress")
            }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

struct WorkoutsView: View {
    var body: some View {
        NavigationView {
            Text("Workouts")
                .navigationTitle("Workouts")
        }
    }
}

struct ProgressView: View {
    // Sample data
    private let workouts = [
        Workout(name: "Workout 1", completionRate: 0.6),
        Workout(name: "Workout 2", completionRate: 0.8),
        Workout(name: "Workout 3", completionRate: 0.4),
        Workout(name: "Workout 4", completionRate: 1.0)
    ]

    @State private var animateChart = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Completed Workouts")
                        .font(.title)
                        .padding(.top)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(workouts) { workout in
                            HStack {
                                Text(workout.name)
                                Spacer()
                                Text("\(Int(workout.completionRate * 100))%")
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(10)

                    Text("Progress Overview")
                        .font(.title)
                        .padding(.top)

                    HStack(alignment: .bottom, spacing: 15) {
                        ForEach(workouts) { workout in
                            VStack {
                                Text("\(Int(workout.completionRate * 100))%")
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.blue)
                                    .frame(width: 30, height: CGFloat(animateChart ? workout.completionRate * 200 : 0))
                                    .animation(.easeInOut(duration: 1.0), value: animateChart)
                                Text(workout.name)
                            }
                        }
                    }
                    .padding()
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.bottom))
            .navigationTitle("Progress")
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animateChart = true
                }
            }
        }
    }
}




struct SettingsView: View {
    @State private var enableNotifications = true
    @State private var darkMode = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text("John Doe")
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Email")
                        Spacer()
                        Text("john.doe@example.com")
                            .foregroundColor(.gray)
                    }
                }

                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $enableNotifications)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }

                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $darkMode.animation())
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .onChange(of: darkMode) { value in
                            let scene = UIApplication.shared.connectedScenes.first
                            if let sceneDelegate = (scene?.delegate as? UIWindowSceneDelegate),
                               let window = sceneDelegate.window {
                                window?.overrideUserInterfaceStyle = value ? .dark : .light
                            }
                        }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
