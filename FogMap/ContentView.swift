import SwiftUI
import MapKit

struct ContentView: View {

    @StateObject var locationManager = LocationManager()
    @State private var recenterMap = false

    var body: some View {
        ZStack {

            MapViewRepresentable(locationManager: locationManager, recenter: $recenterMap)
                .ignoresSafeArea()

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button {
                        recenterMap = true
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(14)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
