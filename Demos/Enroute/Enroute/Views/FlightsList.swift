//
//  FlightsList.swift
//  Enroute
//
//  Created by Víctor Manuel Puga Ruiz on 03/05/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct FlightList: View {
  @ObservedObject var flightFetcher: FlightFetcher
  
  init(_ flightSearch: FlightSearch) {
    self.flightFetcher = FlightFetcher(flightSearch: flightSearch)
  }
  
  var flights: [FAFlight] { flightFetcher.latest }
  
  var body: some View {
    List {
      ForEach(flights, id: \.ident) { flight in
        FlightListEntry(flight: flight)
      }
    }
    .navigationBarTitle(title)
  }
  
  private var title: String {
    let title = "Flights"
    if let destination = flights.first?.destination {
      return title + " to \(destination)"
    } else {
      return title
    }
  }
}

// 
// struct FlightsList_Previews: PreviewProvider {
//   static var previews: some View {
//     FlightList(.init(destination: "KSFO"))
//   }
// }
