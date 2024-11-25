
import SwiftUI

struct ContentView: View {
    @State private var isBlocked = false
    @State private var distanceWalked: Double = 0.0
    let healthManager = HealthManager()
    
    var body: some View {
        VStack {
            if isBlocked {
                Text("🚶 Go for a 1km walk to continue!")
                    .font(.title)
                    .padding()
                Text("Distance walked: \(String(format: "%.2f", distanceWalked)) km")
                    .padding()
                Button("Check Progress") {
                    healthManager.getWalkingDistance { distance in
                        distanceWalked = distance
                        if distance >= 1.0 {
                            isBlocked = false
                        }
                    }
                }
                .padding()
            } else {
                Text("You're free to use Instagram for now!")
            }
        }
        .onAppear {
            healthManager.requestAuthorization { success in
                if !success {
                    print("HealthKit authorization failed.")
                }
            }
        }
    }
}
