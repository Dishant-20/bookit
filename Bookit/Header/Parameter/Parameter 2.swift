//
//  Parameter.swift
//  Bookit App
//
//  Created by Ranjan on 14/01/22.
//

import UIKit



struct CustomerRegister: Encodable {
    
    //parameter
    let action: String
   let banner: String
    let fullName: String
   let email: String
   let password: String
   let contactNumber: String
   let address: String
   let device: String
   let role: String
   let latitude: String
   let longitude: String
   let deviceToken:String
    let countryId: String
    let image: String
    let state: String
    let openTime:String
    let closeTime:String

}

struct ClubRegister: Encodable {
    
    //parameter
    let action: String
   let banner: String
    let fullName: String
   let email: String
   let password: String
   let contactNumber: String
   let address: String
   let device: String
   let role: String
   let latitude: String
   let longitude: String
   let deviceToken:String
    let countryId: String
    let image: String
    let state: String
    let openTime:String
    let closeTime:String
    
}

struct ClubTableList: Encodable {
    
    //parameter
    let action: String
    let userId: String
    let clubId: String
    let pageNo: String

}

struct CustomerLogin: Encodable {
    
    //parameter
    let action: String
    let password:String
    let deviceToken:String
    let latitude :String
    let longitude :String
    let email: String

}

struct customer_dashboard: Encodable {
    
    //parameter
    let action: String
    let userId: String
    // let clubId:String
    // let pageNo:String
}

struct customer_table_listing: Encodable {
    
    /*
     action: tablelist
     userId:  // for Club
     clubId:  //for Customer
     pageNo:
     */
    //parameter
    let action: String
    // let action: String
    let clubId: String
    let pageNo: String
    
    // let clubId:String
    // let pageNo:String
}

/*
 action: addbooking
 userId:
 clubId:
 clubTableId:
 bookingDate:
 arrvingTime:
 totalSeat:
 seatPrice:
 adminFee:
 totalAmount:  ///totalAmount-adminFee

 advancePayment:
 fullPaymentStatus:  2=NO, 1=Full
 */

struct customer_book_a_table: Encodable {
    
    let action: String
    let userId: String
    let clubId: String
    let clubTableId: String
    let bookingDate: String
    let arrvingTime: String
    let totalSeat: String
    let seatPrice: String
    let adminFee: String
    let totalAmount: String
    let advancePayment: String
    let fullPaymentStatus: String
}

struct customer_booking_history: Encodable {
    
    let action: String
    let userId: String
    let userType: String
    let pageNo: String
}

struct club_reviews: Encodable {
    
    let action: String
    let userId: String
}

struct give_review_to_club: Encodable {
    
    let action: String
    let reviewTo: String
    let reviewFrom: String
    let star: String
    let message: String
}

struct like_to_club: Encodable {
    
    let action: String
    let userId: String
    let clubId: String
    let status: String
}

struct pay_pending_payment: Encodable {
    
    let action: String
    let userId: String
    let bookingId: String
    let fullPaymentStatus: String
    let remainPayment:String
    let remainTransactionID:String
}

struct update_payment_after_stripe: Encodable {
    
    let action: String
    let userId: String
    let bookingId: String
    let fullPaymentStatus: String
    let transactionId:String
}

class Parameter: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
