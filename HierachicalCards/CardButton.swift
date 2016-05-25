import UIKit

// UIButtonを継承した独自クラス
class CardButton: UIButton{
    let delegate: CardButtonDelegate?
    let card: Card
    let color: String
    init(delegate:CardButtonDelegate,card:Card,color:String){
        self.delegate = delegate
        self.card = card
        self.color = color
        super.init(frame:CGRectMake(0,0,0,0))
        //初期化処理
        if card.type == 0{ //タイプがフォルダだったら
            self.addTarget(self, action: "cardTransition", forControlEvents: .TouchUpInside)
            self.backgroundColor = UIColor.hexStr(self.color, alpha: 255)
        }else if card.type == 1{ //タイプがカードだったら
            self.addTarget(self, action: "showCard", forControlEvents: .TouchUpInside)
            self.setTitleColor(UIColor.blackColor(), forState: .Normal)
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.hexStr(self.color, alpha: 255).CGColor
            self.setTitleColor(UIColor.hexStr(self.color, alpha: 255), forState: .Normal)
        }
        self.setTitle(self.card.title, forState: .Normal)
        let label = self.titleLabel
        label?.adjustsFontSizeToFitWidth = true
        label?.lineBreakMode = NSLineBreakMode.ByClipping
        label?.numberOfLines = 2
    }
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func cardTransition(){
        self.delegate?.cardTransition(self.card)
    }
    
    func showCard(){
        self.delegate?.showCard(self.card)
    }
    
    // 制約を追加
    func setConstraints(parent:UIView,index:Int, height:CGFloat, margin:CGFloat){
        
        parent.addConstraints([
            NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal,
                toItem: parent, attribute: .Top, multiplier: 1.0, constant: (height+margin) * CGFloat(index)),
            NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: parent, attribute: .Left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: parent, attribute: .Height ,multiplier: 0, constant: height),
            NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: parent, attribute: .Width ,multiplier: 0.85, constant: 0)
        ])
    }
}
