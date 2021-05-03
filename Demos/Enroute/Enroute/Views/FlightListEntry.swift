//
//  FlightListEntry.swift
//  Enroute
//
//  Created by Víctor Manuel Puga Ruiz on 03/05/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct FlightListEntry: View {
  @ObservedObject var allAirports = Airports.all
  @ObservedObject var allAirlines = Airlines.all
  
  var flight: FAFlight
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(name)
      Text(arrives).font(.caption)
      Text(origin).font(.caption)
    }
    .lineLimit(1)
  }
  
  var name: String {
    return "\(allAirlines[flight.airlineCode]?.friendlyName ?? "Unknown Airline") \(flight.number)"
  }
  
  var arrives: String {
    let time = DateFormatter.stringRelativeToToday(Date.currentFlightTime, from: flight.arrival)
    if flight.departure == nil {
      return "scheduled to arrive \(time) (not departed)"
    } else if flight.arrival < Date.currentFlightTime {
      return "arrived \(time)"
    } else {
      return "arrives \(time)"
    }
  }
  
  var origin: String {
    return "from " + (allAirports[flight.origin]?.friendlyName ?? "Unknown Airport")
  }
}

// 
// struct FlightListEntry_Previews: PreviewProvider {
//   static var data: FAFlight? = {
//     do {
//       
//       let r = try JSONDecoder().decode(FAFlight.self, from: "{\"ident\":\"AAL9607\",\"aircrafttype\":\"A320\",\"actualdeparturetime\":1589055129,\"estimatedarrivaltime\":1589072760,\"filed_departuretime\":1589054400,\"origin\":\"KCLT\",\"destination\":\"KLAS\",\"originName\":\"Charlotte/Douglas Intl\",\"originCity\":\"Charlotte, NC\",\"destinationName\":\"McCarran Intl\",\"destinationCity\":\"Las Vegas, NV\"}".data(using: .utf8)!)
//       return r
//     } catch {
//       return nil
//     }
//   }()
//   
//   static var previews: some View {
//     FlightListEntry(flight: data!)
//   }
// }
