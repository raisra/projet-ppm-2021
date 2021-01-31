//
//  ChatViewController.swift
//  projet-ppm
//
//  Created by Nathan on 29/01/2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView



class ChatViewController: MessagesViewController, MessagesDataSource {
 
    //let currentUser = Sender(senderId: "self", displayName: "Supriya")
    //let otherUser = Sender(senderId: "other", displayName: "Bob")
    var messages = [Message]()
    var chatService: ChatService!
    var member: Sender!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        member = Sender(senderId: UIDevice.current.name, displayName: UIDevice.current.name)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.attributedTextMessageSizeCalculator.avatarLeadingTrailingPadding = .zero
            layout.setMessageIncomingCellTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: .zero))
            layout.setMessageOutgoingCellTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: .zero))
        }
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(backToGameView))
        recognizer.direction = [.right, .left]
        view.gestureRecognizers = [recognizer]
        
        chatService = ChatService(member: member, onRecievedMessage: {
            [weak self] message in
            self?.messages.append(message)
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToLastItem(animated: true)
        })

        chatService.connect()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.becomeFirstResponder()
    }
    
    @objc func backToGameView()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    func currentSender() -> SenderType {
        return Sender(senderId: member.senderId, displayName: member.displayName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {

        let name = message.sender.displayName
        return NSAttributedString(
          string: name,
          attributes: [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
            .foregroundColor: UIColor(white: 0.3, alpha: 1)
          ]
        )
      }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }

}


// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {

    func avatarSize(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath,
        with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
  
}

extension ChatViewController: MessagesDisplayDelegate {

    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        chatService.sendMessage(text)
        inputBar.inputTextView.text = ""
    }
    
}
