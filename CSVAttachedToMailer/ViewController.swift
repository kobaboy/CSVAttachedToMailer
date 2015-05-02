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
        
        var mailViewController = MFMailComposeViewController()
        var toRecipients = ["to@1gmail.com"]
        var CcRecipients = ["cc@1gmail.com","Cc2@1gmail.com"]
        var BccRecipients = ["Bcc@1gmail.com","Bcc2@1gmail.com"]
        var image = UIImage(named: "myphoto.png")
        var imageData = UIImageJPEGRepresentation(image, 1.0)
        
        
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("メールの件名")
        mailViewController.setToRecipients(toRecipients) //Toの表示
        mailViewController.setCcRecipients(CcRecipients) //Ccの表示
        mailViewController.setBccRecipients(BccRecipients) //Bccの表示
        mailViewController.setMessageBody("メールの本文", isHTML: false)
        mailViewController.addAttachmentData(imageData, mimeType: "image/png", fileName: "image")
        
        self.presentViewController(mailViewController, animated: true, completion: nil)
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

