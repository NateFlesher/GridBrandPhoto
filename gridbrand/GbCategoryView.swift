//
//  GbCategoryView.swift
//  postcraft
//
//  Created by LionStar on 1/15/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

protocol GbCategoryViewDelegate{
    func categorySelected(_ view:GbCategoryView, category:CategoryModel)
}

class GbCategoryView: GbCustomView {
    var delegate: GbCategoryViewDelegate? = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    func categoryBtnTouch(_ sender: UIButton) {
        let category = CategoryDao().findById(Int64(sender.tag))
        self.delegate?.categorySelected(self, category: category!)
    }
}

extension Reactive where Base: GbCategoryView {
    var data: UIBindingObserver<Base, [CategoryModel]> {
        return UIBindingObserver(UIElement: base) { view, categories in
            let margin: CGFloat = 10
            let dotSize = CGSize(width:6, height:6), iconSize = CGSize(width:16, height:16)
            let labelHeight: CGFloat = 13
            
            let cnt: CGFloat = CGFloat(categories.count)
            let scrollViewSize = view.scrollView.frame.size
            
            let estimateW = ((scrollViewSize.width - 2 * margin) - (cnt-1) * (2 * margin + dotSize.width)) / cnt
            let w:CGFloat = estimateW < 50 ? 50 : estimateW
            
            for (index, category) in categories.enumerated() {
                let v = UIView(frame: CGRect(x:margin + CGFloat(index) * (w + 2 * margin + dotSize.width), y:0, width:w, height:scrollViewSize.height))
                //v.backgroundColor = UIColor.green
                
                let icon = UIImageView(frame: CGRect(x:(v.frame.size.width - iconSize.width) / 2, y:(v.frame.size.height - iconSize.height - labelHeight - 5) / 2, width:iconSize.width, height:iconSize.height))
                icon.image = UIImage(named: category.icon_url)
                v.addSubview(icon)
                
                let label = UILabel(frame: CGRect(x:0, y:icon.frame.origin.y + icon.frame.size.height + 5, width:w, height:labelHeight))
                label.textAlignment = .center
                label.text = category.title
                label.textColor = UIColor(red: 3/255, green: 3/255, blue: 3/255, alpha: 1)
                label.font = UIFont(name:"HelveticaNeue-Light", size:11)
                //label.backgroundColor = UIColor.red
                v.addSubview(label)
                
                let button = UIButton(frame: CGRect(x:0, y:0, width:v.frame.size.width, height:v.frame.size.height))
                //button.backgroundColor = UIColor.blue
                button.tag = Int(category.id)
                button.addTarget(view, action: #selector(view.categoryBtnTouch), for: .touchUpInside)
                v.addSubview(button)
//                button.rx.tap.asObservable()
//                    .subscribe(onNext: {_ in
//                        view.delegate?.categorySelected(view, category: category)
//                    })
//                    .addDisposableTo(DisposeBag())
                
                view.scrollView.addSubview(v)
                
                if(index < Int(cnt-1)) { // add dot break image
                    let dot = UIImageView(frame: CGRect(x:v.frame.origin.x+v.frame.size.width+margin, y:(scrollViewSize.height-dotSize.height)/2, width:dotSize.width, height:dotSize.height))
                    dot.image = UIImage(named:"dot")
                    view.scrollView.addSubview(dot)
                }
            }
            
            view.scrollView.contentSize = CGSize(width: 2 * margin + (cnt-1) * (w + 2 * margin + dotSize.width) + w, height: scrollViewSize.height); print(view.scrollView.contentSize)
            view.scrollView.setContentOffset(CGPoint(x:0, y:0), animated:false)
            view.scrollView.contentInset = .zero
            
        }
    }
}
