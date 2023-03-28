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

struct guest_register: Encodable {
    
    //parameter
    let action: String
    let fullName: String
    let email: String
    let password: String
    let device: String
    let role: String
    let deviceToken:String
    
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
    let keyword: String
    let latitude: String
    let longitude: String
    let countryId: String
    let stateId: String
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
    let pageNo: Int
}

struct customer_booking_history_for_club: Encodable {
    
    let action: String
    let userId: String
    let clubId: String
    let userType: String
    let pageNo: Int
}

struct customer_booking_history_earnings_for_club: Encodable {
    
    let action: String
    let userId: String
    let clubId: String
    let userType: String
    let pageNo: Int
    let completed: String
}

struct customer_booking_history_new: Encodable {
    
    let action: String
    let userId: String
    let clubId: String
    // let userType: String
    let pageNo: Int
}

struct club_reviews: Encodable {
    
    let action: String
    let userId: String
}

struct help_wb_call: Encodable {
    
    let action: String
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

struct update_payment_after_stripe_webservice: Encodable {
    
    let action: String
    let userId: String
    let bookingId: String
    let fullPaymentStatus: String
    let transactionId:String
}

struct add_table_from_club: Encodable {
    
    let action: String
    let userId: String
    let name: String
    let totalSeat: String
    let seatPrice:String
    let description:String
    let advancePercentage:String
}

struct edit_table_from_club: Encodable {
    
    let action: String
    let userId: String
    let clubTableId:String
    let name: String
    let totalSeat: String
    let seatPrice:String
    let description:String
    let advancePercentage:String
}




struct edit_club_profile: Encodable {
    
    let action: String
    let userId: String
    let address: String
    let countryId: String
    let stateId: String
    let openTime:String
    let closeTime:String
    let zipCode:String
    let city:String
    let about:String
}

struct show_club_images: Encodable {
    
    let action: String
    let userId: String
    // let clubTableId:String
    let pageNo: String
}

struct check_dates_availaibility:Encodable {
    
    // checkavailable
    let action: String
    let date: String
    let tableId: String
}

struct change_my_password: Encodable {
    let action: String
    let userId:String
    let oldPassword:String
    let newPassword:String
    
}

struct countryListWeb: Encodable {
    let action: String
}

struct state_list: Encodable {
    let action: String
    let countryId: String
}



struct edit_profile: Encodable {
    let action: String
    let userId:String
    let fullName:String
    let contactNumber:String
    let address:String
    let latitude:String
    let longitude:String
    
}

struct edit_profile_only_lat_long: Encodable {
    let action: String
    let userId:String
    let latitude:String
    let longitude:String
    
}

/*
 action: earning
 userId:
 */

struct club_earning: Encodable {
    let action: String
    let userId:String
}

struct club_earning_filter: Encodable {
    let action: String
    let userId:String
    let startDate:String
    let endDate:String
}

/*
 let action: String
 let userId: String
 let userType: String
 let pageNo: String
 */

struct show_booking_history_via_dates: Encodable {
    
    let action: String
    let clubId:String
    let userType:String
    let startDate:String
    let endDate:String
    
}

struct show_earnings_list: Encodable {
    
    let action: String
    let userId:String
    let completed:String
    let startDate:String
    let endDate:String
    
}


/*
 action: cashoutrequest
 userId:
 requestAmount:
 */

struct cashout: Encodable {
    
    let action: String
    let userId:String
    let requestAmount:String
    
}

struct cashout_history: Encodable {
    
    let action: String
    let userId:String
    let pageNo:String
    
}

/*
 action: addevent
 clubId:
 eventName:
 EventDate:
 EventTimeFrom:
 EventTimeTo:
 EventDescription:
 */
struct create_an_event: Encodable {
    
    let action: String
    let clubId:String
    let eventName:String
    let EventDate:String
    let EventTimeFrom:String
    let EventTimeTo:String
    let EventDescription:String
}

struct edit_an_event: Encodable {
    
    let action: String
    let eventId:String
    let clubId:String
    let eventName:String
    let EventDate:String
    let EventTimeFrom:String
    let EventTimeTo:String
    let EventDescription:String
}

/*
 action; deletetable
 clubId:
 clubTableId:
 */
struct club_delete_table: Encodable {
    
    let action: String
    let clubId:String
    let clubTableId:String
}

struct events_listing: Encodable {
    
    let action: String
    let userId:String
    let pageNo:Int
    let date:String
}

/*
 action: deleteevent
 clubId:
 eventId:
 */

struct delete_event: Encodable {
    
    let action: String
    let clubId:String
    let eventId:String
}

struct booking_list_for_upcoming_events: Encodable {
    
    let action: String
    // let userId: String
    let clubId: String
    let userType: String
    let pageNo: String
    let upcommimg: String
}

/*
 delete photo
 
 action: deleteclubphoto
 userId:
 tablephotoId:  //PHOTO ID
 
 */

struct delete_club_photo: Encodable {
    
    let action: String
    let userId: String
    let tablephotoId: String
}

struct forgot_password_webservice: Encodable {
    
    let action: String
    let email: String
}

struct cancel_booking: Encodable {
    
    let action: String
    let userId: String
    let bookingId: String
}

struct cancel_booking_request: Encodable {
    
    let action: String
    let userId: String
    let bookingId: String
    let cancelRequest:String
}

struct update_club_off_day: Encodable {
    
    let action: String
    let userId: String
    let Mon: String
    let Tue: String
    let Wed: String
    let Thu: String
    let Fri: String
    let Sat: String
    let Sun: String
}

struct update_token_for_club: Encodable {
    
    let action: String
    let userId: String
    let deviceToken: String
}

struct logout_my_app: Encodable {
    let action: String
    let userId: String
}

struct stripe_charger_amount: Encodable {
    let action: String
    let userId: String
    let amount: String
    let tokenID: String
}

struct check_stripe_registraiton: Encodable {
    
    let action: String
    let userId: String
    let email: String
}

struct check_profile_status: Encodable {
    
    let action: String
    let userId: String
}

struct check_stripe_status: Encodable {
    
    let action: String
    let userId: String
    let Account: String
}

struct edit_profile_for_stipe_payment_option: Encodable {
    
    let action: String
    let userId: String
    let currentPaymentOption: String
}

struct edit_profile_for_member_information: Encodable {
    
    let action: String
    let userId: String
    let address:String
    let countryId:String
    let stateId:String
    let zipCode:String
    let city:String
}

/*
 "action"        : "chargeramount",
 "userId"        : String(myString),
 "amount"        : strTotalAmount,//String("500"),
 "tokenID"       : String(strStripeTokenId),
 "DriverAmount"  : String(myInt3),
 "AccountNo"     : String(strAccountNumberIs)
 */

struct split_payment_via_stripe: Encodable {
    
    let action: String
    let userId: String
    let amount: String
    let tokenID: String
    let DriverAmount: String
    let AccountNo: String
}

struct edit_bank_details: Encodable {
    
    let action: String
    let userId: String
    let BankName: String
    let accountNo: String
    let RoutingNo: String
}

struct resend_email_verification: Encodable {
    
    let action: String
    let userId: String
}

struct forgot_password_WB: Encodable {
    
    let action: String
    let email: String
    let OTP: String
    let password: String
}

struct report_this_review_params: Encodable {
    
    let action: String
    let userId: String
    let reviewId: String
}


struct cwa_payment_system:Encodable {
    
    // checkavailable
    let zip: String
    let country: String
    let amount: Double
    let firstname: String
    let cvv: String
    let city: String
    let address1: String
    let type: String
    let lastname: String
    let security_key: String
    let phone: String
    let state: String
    let ccexp: String
    let ccnumber: String
}

class Parameter: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
