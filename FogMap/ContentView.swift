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
                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text("Explored")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)

                    Text(String(format: "%.5f%%", MapViewRepresentable.exploredPercentage()))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 20)
                
                Spacer()
            }

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
