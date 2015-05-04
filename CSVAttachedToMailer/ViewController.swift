//
//  ViewController.swift
//  CSVAttachedToMailer
//
//  Created by Keisuke.K on 2015/05/01.
//  Copyright (c) 2015年 Keisuke.K. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate{

    let startMailerBtn = UIButton(frame: CGRectMake(0,0,200,30))
    var csvData=[[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startMailerBtn.layer.position = CGPoint(x:self.view.bounds.width/2,y:self.view.bounds.height/2);
        startMailerBtn.setTitle("メール送信", forState: .Normal)
        startMailerBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        startMailerBtn.addTarget(self, action: "onClickStartMailerBtn:", forControlEvents: .TouchUpInside)
        self.view.addSubview(startMailerBtn)
        
    }

    func onClickStartMailerBtn(sender: UIButton) {
        //メールを送信できるかチェック
        if MFMailComposeViewController.canSendMail()==false {
            println("Email Send Failed")
            return
        }
        
        //CSVデータの作成
        csvData.append(["日付","データ１","データ２","データ３","データ４"])
        csvData.append(["2015年5月5日","aaa","bbb","ccc","ddd"])
        
        sendMailWithCSV("メール件名", message: "メール本文", csv: csvData)
        
    }
    
    func sendMailWithCSV(subject: String, message: String, csv: [[String]]) {
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        var toRecipients = ["to@1gmail.com"]
        var CcRecipients = ["cc@1gmail.com"]
        var BccRecipients = ["Bcc1@1gamil.com","Bcc2@1gmail.com"]
        var image = UIImage(named: "myphoto.png")
        var imageData = UIImageJPEGRepresentation(image, 1.0)
        
        mailViewController.setSubject(subject)
        mailViewController.setToRecipients(toRecipients)
        mailViewController.setCcRecipients(CcRecipients)
        mailViewController.setBccRecipients(BccRecipients)
        mailViewController.setMessageBody(message, isHTML: false)
        mailViewController.addAttachmentData(imageData, mimeType: "image/png", fileName: "image")
        mailViewController.addAttachmentData(toCSV(csv).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), mimeType: "text/csv", fileName: "sample.csv")
        self.presentViewController(mailViewController, animated: true) {}
    }
    
    func toCSV(a: [[String]]) -> String {
        return join("\n", a.map { join(",", $0.map { e in
            contains(e) { contains("\n\",", $0) } ?
                "\"" + e.stringByReplacingOccurrencesOfString("\"", withString: "\"\"", options: nil, range: nil) + "\"" : e
            })}) + "\n"
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Email Send Cancelled")
            break
        case MFMailComposeResultSaved.value:
            println("Email Saved as a Draft")
            break
        case MFMailComposeResultSent.value:
            println("Email Sent Successfully")
            break
        case MFMailComposeResultFailed.value:
            println("Email Send Failed")
            break
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

