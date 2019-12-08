//
//  MockData.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 06/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import Foundation

final class MockService {
    static func getOpenAppointments() -> [Appointment] {
        // December 28 2019 09:30:30
        let date = Date(timeIntervalSince1970: 1577521830)
        // Januari 3 2020 14:00:00
        let date2 = Date(timeIntervalSince1970: 1578056400)
        return [
            Appointment(Id: "", AppointmentDatetime: date, Comment: "Plaats voor 5 totaal, 3 dev en 2 marketing", Address: "Jansweg 39 Haarlem", PhoneNumber: "0231234567", ContactPersonName: "Harry de Wit", ContactPersonPhoneNumber: "02341234567", ContactPersonFunction: "Designer", Active: true, Website: "https://pixelindustries.com/nl/", Logo: "", COCNumber: "", COCName: "PXL Widgets", FirstChoice: "", SecondChoice: "", ThirdChoice: "", CreatedDate: date, ModifiedDate: date),
            Appointment(Id: "", AppointmentDatetime: date2, Comment: "Kan 1 developer stage lopen", Address: "Oostelijke Handelskade 12H Amsterdam", PhoneNumber: "0201234567", ContactPersonName: "Hans de Wit", ContactPersonPhoneNumber: "0201234567", ContactPersonFunction: "CTO", Active: true, Website: "https://www.zimmermanzimmerman.nl/", Logo: "", COCNumber: "", COCName: "Zimmerman en Zimmerman", FirstChoice: "", SecondChoice: "", ThirdChoice: "", CreatedDate: date, ModifiedDate: date)
        ]
    }
    
    static func getAccpetedAppointments() -> [Appointment] {
        // December 20 2019 10:00:00
        let date = Date(timeIntervalSince1970: 1576832400)
        // December 23 2019 15:00:00
        let date2 = Date(timeIntervalSince1970: 1577109600)
        return [
            Appointment(Id: "", AppointmentDatetime: date, Comment: "Plaats voor 4 stagiairs", Address: "Nachtwachtlaan 20 Amsterdam", PhoneNumber: "0201234567", ContactPersonName: "Arthur van Loo", ContactPersonPhoneNumber: "0201234567", ContactPersonFunction: "Full stack developer", Active: true, Website: "https://www.gopublic.nl", Logo: "", COCNumber: "", COCName: "Gopublic", FirstChoice: "", SecondChoice: "", ThirdChoice: "", CreatedDate: date, ModifiedDate: date),
            Appointment(Id: "", AppointmentDatetime: date2, Comment: "Plaats voor 3 PHP stagiairs", Address: "Waterland 14 Beverwijk", PhoneNumber: "0251234567", ContactPersonName: "Jurijn Olie", ContactPersonPhoneNumber: "0251234567", ContactPersonFunction: "CEO", Active: true, Website: "https://soliede.nl", Logo: "", COCNumber: "", COCName: "Soliede", FirstChoice: "", SecondChoice: "", ThirdChoice: "", CreatedDate: date2, ModifiedDate: date2)
        ]
    }
    
    static func getDoneAppointments() -> [Appointment] {
        // December 3 2019 10:00:00
        let date = Date(timeIntervalSince1970: 1575363600)
        return [
            Appointment(Id: "", AppointmentDatetime: date, Comment: "Afspraak voor 3 IT stageplaatsen", Address: "Ohmstraat 11 Haarlem", PhoneNumber: "0612345678", ContactPersonName: "Bas Tolen", ContactPersonPhoneNumber: "0612345678", ContactPersonFunction: "CEO", Active: true, Website: "https://www.bos-tol.nl", Logo: "", COCNumber: "6435453", COCName: "Bos-Tol", FirstChoice: "", SecondChoice: "", ThirdChoice: "", CreatedDate: date, ModifiedDate: date)
        ]
    }
    
    static func getInvoices() -> [Invoice] {
        let date1 = Date(timeIntervalSince1970: 1572786000)
        let date2 = Date(timeIntervalSince1970: 1575378000)
        
        return [
            Invoice(Id: "", AdvisorId: "", UploadDate: date1, FileName: "Factuur_november_2019", FilePath: "", Base64EncodedPdf: ""),
            Invoice(Id: "", AdvisorId: "", UploadDate: date2, FileName: "Factuur_oktober_2019", FilePath: "", Base64EncodedPdf: ""),
        ]
    }
    
    static func getCarReservations() -> [CarReservation] {
        let date = Date(timeIntervalSince1970: 1577521830)
        let date2 = Date(timeIntervalSince1970: 1578056400)
        let date3 = Date(timeIntervalSince1970: 1576832400)
        
        return [
            CarReservation(Id: "", reservationDate: date, car: "Fiat 500 automaat", pickupPlace: "Haarlem", pickupAdres: "Ohmstraat 11, Haarlem", licencePlate: "GB-001-A"),
            CarReservation(Id: "", reservationDate: date2, car: "Fiat 500 schakel", pickupPlace: "Beverwijk", pickupAdres: "Waterland 14, Beverwijk", licencePlate: "GB-001-B"),
            CarReservation(Id: "", reservationDate: date3, car: "Fiat 500 schakel", pickupPlace: "Overveen", pickupAdres: "Bijdorplaan 15, Overveen", licencePlate: "GB-001-C")
        ]
    }
}
