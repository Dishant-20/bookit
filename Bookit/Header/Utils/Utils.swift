import UIKit
import CoreLocation

// MARK:- BASE URL -
//  let APPLICATION_BASE_URL = "https://demo4.evirtualservices.net/bookit/services/index"
  let APPLICATION_BASE_URL = "https://bookitweb.com/services/index"

let cwa_payment_URL = "https://cwamerchantservices.transactiongateway.com/api/transact.php"
let cwa_payment_api_key = "rzv73u6neV6sNdWH7r22q5WGJU3a9Q6T"

// apple pay
let merchant_id = "merchant.com.development.info.bookit"

// TEST
 let stripe_payment_update = "https://demo4.evirtualservices.net/bookit/webroot/strip_master/strip_master/charge_test.php"
 let STRIPE_PROCESS = "pk_test_51L2cVMEM1BPH63vEt5vXDoU19e9QkHgZWC8SVqyiKb19oq3EAORD87x4NED5u8ZCV3PLr5CJ3BcjM3N98pnkhbdP00luwDJBcS"
 let split_payment_URL = "https://demo4.evirtualservices.net/bookit/webroot/strip_master/strip_master/splitpayment_test.php"


// CWA PAYMENT
let cwa_payment_link = "https://cwamerchantservices.transactiongateway.com/api/transact.php"

/*
// LIVE
 let stripe_payment_update = "https://demo4.evirtualservices.net/bookit/webroot/strip_master/strip_master/charge.php"
  let STRIPE_PROCESS = "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"
  let split_payment_URL = "https://demo4.evirtualservices.net/bookit/webroot/strip_master/strip_master/splitpayment.php"

*/






// 207 , 231 , 244
let NAVIGATION_COLOR = UIColor.init(red: 8/255.0, green: 34/255.0, blue: 219.0/255.0, alpha: 1)

let APP_BASIC_COLOR = UIColor.init(red: 8.0/255.0, green: 3.0/255.0, blue: 26.0/255.0, alpha: 1)

let BUTTON_DARK_APP_COLOR = UIColor.init(red: 225.0/255.0, green: 33.0/255.0, blue: 71.0/255.0, alpha: 1)

let APP_BUTTON_COLOR = UIColor.black// UIColor.init(red: 43.0/255.0, green: 100.0/255.0, blue: 191.0/255.0, alpha: 1)

let bookit_terms = "https://bookitweb.com/pages/termandconditions"
let bookit_privacy = "https://bookitweb.com/pages/privacypolicy"

let NAVIGATION_TITLE_COLOR  = UIColor.white
let NAVIGATION_BACK_COLOR   = UIColor.white
let CART_COUNT_COLOR        = UIColor.black


// URLs
let URL_HARILOSS_SUPPORT_GROUP  = "https://www.google.co.in"

let cell_bg_color = UIColor.init(red: 230.0/255.0, green: 212.0/255.0, blue: 196.0/255.0, alpha: 1)






let ALERT_MESSAGE       = "Alert!"

// SERVER ISSUE
let SERVER_ISSUE_TITLE          = "Server Issue."
let SERVER_ISSUE_MESSAGE        = "Server Not Responding. Please check your Internet Connection."
let SERVER_ISSUE_MESSAGE_TWO    = "Please contact to Server Admin."


// NAVIGATION TITLES
let WELCOME_PAGE_NAVIGATION_TITLE = "CONTINUE AS A"
let DISCLAIMER_PAGE_NAVIGATION_TITLE = "DISCLAIMER"
let REGISTRATION_PAGE_NAVIGATION_TITLE = "REGISTRAITON"
let COMPLETE_ADDRESS_PAGE_NAVIGATION_TITLE = "COMPLETE ADDRESS"
let LOGIN_PAGE_NAVIGATION_TITLE = "LOGIN"
let DASHBOARD_PAGE_NAVIGATION_TITLE = "DASHBOARD"
let ORDER_FOOD_PAGE_NAVIGATION_TITLE = "ORDER FOOD"
let CART_LIST_NAVIGATION_TITLE = "CART"
let REVIEW_ORDER_NAVIGATION_TITLE = "REVIEW ORDER"
let DELIVERY_ADDRESS_NAVIGATION_TITLE = "DELIVERY ADDRESS"
let SUCCESS_NAVIGATION_TITLE = "SUCCESS"
let FOOD_ORDER_DETAILS_NAVIGATION_TITLE = "FOOD ORDER DETAILS"
let FORGOT_PASSWORD_NAVIGATION_TITLE = "FORGOT PASSWORD"
let CHANGE_PASSWORD_NAVIGATION_TITLE = "CHANGE PASSWORD"
let PAYMENT_NAVIGATION_TITLE = "PAYMENT"
let CASHAPP_NAVIGATION_TITLE = "CASHAPP"
let FOODVERIFICATION_NAVIGATION_TITLE = "VERIFICATION"
let VerificationNotification_NAVIGATION_TITLE = "ORDER PICKED UP CONFIRMED"
//let DELIVERY_NAVIGATION_TITLE = "ORDER PICKED UP CONFIRMED"
let ORDERHISTORY_NAVIGATION_TITLE = "ORDER HISTORY"
let JOBHISTORY_NAVIGATION_TITLE = "JOB HISTORY"

class Utils: NSObject {
    
    class func button_ui(button:UIButton , button_text:String ,button_bg_color:UIColor , button_text_color:UIColor) {
        
        button.setTitleColor(button_text_color, for: .normal)
        button.setTitle(button_text, for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 15.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 14
        button.backgroundColor = button_bg_color
        
    }
    
    class func showAlert(alerttitle :String, alertmessage: String,ButtonTitle: String, viewController: UIViewController) {
        
        let alertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: .alert)
        let okButtonOnAlertAction = UIAlertAction(title: ButtonTitle, style: .default)
        { (action) -> Void in
            //what happens when "ok" is pressed
            
        }
        alertController.addAction(okButtonOnAlertAction)
        alertController.show(viewController, sender: self)
        
    }
    
    // button
    class func textFieldUI(textField:UITextField,tfName:String,tfCornerRadius:CGFloat,tfpadding:CGFloat,tfBorderWidth:CGFloat,tfBorderColor:UIColor,tfAppearance:UIKeyboardAppearance,tfKeyboardType:UIKeyboardType,tfBackgroundColor:UIColor,tfPlaceholderText:String) {
        textField.text = tfName
        textField.textColor = UIColor.black
        textField.layer.cornerRadius = tfCornerRadius
        textField.clipsToBounds = true
        textField.setLeftPaddingPoints(tfpadding)
        textField.layer.borderWidth = tfBorderWidth
        textField.layer.borderColor = tfBorderColor.cgColor
        textField.keyboardAppearance = tfAppearance
        textField.keyboardType = tfKeyboardType
        textField.backgroundColor = tfBackgroundColor
        textField.placeholder = tfPlaceholderText
    }
    
    //MARK:- TEXT FIELD UI -
    class func setPaddingWithImage(textfield: UITextField,placeholder:String,bottomLineColor:UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = bottomLineColor.cgColor
        textfield.borderStyle = UITextField.BorderStyle.none
        textfield.layer.addSublayer(bottomLine)
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfield.frame.height))
        textfield.placeholder = placeholder
        textfield.leftViewMode = .always
        
        textfield.backgroundColor = .clear
    }
    
    /*
     btnDriver.layer.cornerRadius = 8
     btnDriver.clipsToBounds = true
     btnDriver.backgroundColor = NAVIGATION_COLOR
     btnDriver.setTitleColor(.black, for: .normal)
     btnDriver.setTitle("Driver", for: .normal)
     */
    
    // button
    class func buttonStyle(button:UIButton,bCornerRadius:CGFloat,bBackgroundColor:UIColor,bTitle:String,bTitleColor:UIColor) {
        button.layer.cornerRadius = bCornerRadius
        button.clipsToBounds = true
        button.backgroundColor = bBackgroundColor
        button.setTitle(bTitle, for: .normal)
        button.setTitleColor(bTitleColor, for: .normal)
    }
    
    // text field
    class func textFieldStyle(textField:UITextField,tfCornerRadius:CGFloat,tfBackgroundColor:UIColor,tfTitle:String,tfTitleColor:UIColor,tfpadding:CGFloat) {
        textField.layer.cornerRadius = tfCornerRadius
        textField.clipsToBounds = true
        textField.backgroundColor = tfBackgroundColor
        textField.text = tfTitle
        textField.textColor = tfTitleColor
        textField.setLeftPaddingPoints(tfpadding)
    }
    
    
    // MARK:- SCREEN ( MEMBERSHIP ) -
    /*
     btnSelectFour.layer.borderWidth = 1
     btnSelectFour.layer.borderColor = UIColor.white.cgColor
     btnSelectFour.layer.cornerRadius = 15
     btnSelectFour.clipsToBounds = true
     */
    
    class func membershipButtonStyle(button:UIButton,bCornerRadius:CGFloat,bBackgroundColor:UIColor,bBorderWidth:CGFloat,bBorderColor:UIColor) {
        button.layer.cornerRadius = bCornerRadius
        button.clipsToBounds = true
        button.backgroundColor = bBackgroundColor
        button.layer.borderWidth = bBorderWidth
        button.layer.borderColor = bBorderColor.cgColor
    }
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func validpassword(mypassword : String) -> Bool {
            // least one uppercase,
            // least one digit
            // least one lowercase
            // least one symbol
            //  min 8 characters total
            // let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
            let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
            let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
            return passwordCheck.evaluate(with: mypassword)

        
    }
    
}


extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?,_ country: String?, _ zipcode:  String?, _ localAddress:  String?, _ locality:  String?, _ subLocality:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality,$0?.first?.country, $0?.first?.postalCode,$0?.first?.subAdministrativeArea,$0?.first?.locality,$0?.first?.subLocality, $1) }
    }
    
    func countryCode(completion: @escaping (_ countryCodeIs:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.isoCountryCode, $1) }
    }
    
    func fullAddressFull(completion: @escaping (_ city: String?,_ country: String?, _ zipcode:  String?, _ localAddress:  String?, _ locality:  String?, _ subLocality:  String?,_ countryCodeIs:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality,$0?.first?.country, $0?.first?.postalCode,$0?.first?.administrativeArea,$0?.first?.locality,$0?.first?.subLocality,$0?.first?.isoCountryCode, $1) }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

extension String {
    
    static func randomNumberGenerate(length: Int = 8) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func toAttributed(alignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return toAttributed(attributes: [.paragraphStyle: paragraphStyle])
    }

    func toAttributed(attributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
}

extension UIViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
}

@objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y = 0
    }

}
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    func addDashBorder() {
        let color = UIColor.systemGray.cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()

        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [2,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath

        self.layer.masksToBounds = false

        self.layer.addSublayer(shapeLayer)
    }
}

extension UIView{
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
}

extension Date {
    func today(format : String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}


