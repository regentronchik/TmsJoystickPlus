import UIKit

class ViewController: UIViewController {
    
    var startAgainButton = UIButton()
    let upImageView = UIImageView()
    let downImageView = UIImageView()
    let rightImageView = UIImageView()
    let leftImageView = UIImageView()
    var squareView: UIView!
    
    let buttonSize: CGFloat = 50.0
    var stepSize: CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let buttonSpacing: CGFloat = 20.0
        let buttonY: CGFloat = view.frame.size.height - 150.0
        
        upImageView.image = UIImage(named: "upArrow")
        upImageView.isUserInteractionEnabled = true
        let upTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveUp))
        upImageView.addGestureRecognizer(upTapGesture)
        view.addSubview(upImageView)
        
        downImageView.image = UIImage(named: "downArrow")
        downImageView.isUserInteractionEnabled = true
        let downTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveDown))
        downImageView.addGestureRecognizer(downTapGesture)
        view.addSubview(downImageView)
        
        rightImageView.image = UIImage(named: "rightArrow")
        rightImageView.isUserInteractionEnabled = true
        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveRight))
        rightImageView.addGestureRecognizer(rightTapGesture)
        view.addSubview(rightImageView)
        
        leftImageView.image = UIImage(named: "leftArrow")
        leftImageView.isUserInteractionEnabled = true
        let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveLeft))
        leftImageView.addGestureRecognizer(leftTapGesture)
        view.addSubview(leftImageView)
        
        upImageView.frame = CGRect(x: (view.frame.size.width - buttonSize) / 2,
                                   y: buttonY - buttonSize - buttonSpacing,
                                   width: buttonSize, height: buttonSize)
        downImageView.frame = CGRect(x: (view.frame.size.width - buttonSize) / 2,
                                     y: buttonY + buttonSize + buttonSpacing,
                                     width: buttonSize, height: buttonSize)
        leftImageView.frame = CGRect(x:(view.frame.size.width - buttonSize) / 2 - buttonSize - buttonSpacing,
                                     y: buttonY,
                                     width: buttonSize, height: buttonSize)
        rightImageView.frame = CGRect(x:(view.frame.size.width - buttonSize) / 2 + buttonSize + buttonSpacing,
                                      y: buttonY,
                                      width: buttonSize, height: buttonSize)
        
        var config = UIButton.Configuration.filled()
        config.title = "Start Again"
        config.titleAlignment = .center
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .systemBlue
        
        view.addSubview(startAgainButton)
        startAgainButton.addTarget(self, action: #selector(startAgain), for: .touchUpInside)
        startAgainButton.configuration = config
        startAgainButton.isHidden = true
        startAgainButton.frame = CGRect(x: (view.frame.size.width - (buttonSize * 2)) / 2 - buttonSize,
                                        y: buttonY,
                                        width: buttonSize * 4, height: buttonSize)

        squareView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        squareView.center = view.center
        squareView.backgroundColor = .red
        view.addSubview(squareView)
        
    }
    
    @objc func startAgain() {
        squareView.frame.origin = CGPoint(x: (view.frame.size.width - squareView.frame.size.width) / 2,
                                          y: (view.frame.size.height - squareView.frame.size.height) / 2)
        startAgainButton.isHidden = true
        upImageView.isHidden = false
        downImageView.isHidden = false
        leftImageView.isHidden = false
        rightImageView.isHidden = false
      }
    
    func checkCollision() {
        
        let safeArea = view.safeAreaLayoutGuide
        let maxX = safeArea.layoutFrame.maxX - squareView.frame.width
        let maxY = safeArea.layoutFrame.maxY - squareView.frame.height
        
        if squareView.frame.minX < safeArea.layoutFrame.minX // проверки на пересечение границ safeArea ( добавил т.к. не понимаю, как можно ограничить движения квадрата границами экрана а потом нарушить это условие, если у меня квадрат не может выйти за границу экрана, сами ограничения ниже)
            || squareView.frame.maxX > maxX
            || squareView.frame.minY < safeArea.layoutFrame.minY
            || squareView.frame.maxY > maxY
            || squareView.frame.intersects(upImageView.frame)
            || squareView.frame.intersects(downImageView.frame)
            || squareView.frame.intersects(leftImageView.frame)
            || squareView.frame.intersects(rightImageView.frame) {
            startAgainButton.isHidden = false
            upImageView.isHidden = true
            downImageView.isHidden = true
            leftImageView.isHidden = true
            rightImageView.isHidden = true
        }
    }
    
    @objc func moveUp() {
        if squareView.frame.origin.y - stepSize >= 0 {
            UIView.animate(withDuration: 0.3) {
                self.squareView.center.y -= self.stepSize
            }
            checkCollision()
        }
    }
    
    @objc func moveDown() {
        if squareView.frame.origin.y + squareView.frame.size.height + stepSize != view.frame.size.height  {
            UIView.animate(withDuration: 0.3) {
                self.squareView.center.y += self.stepSize
            }
            checkCollision()
        }
    }
    
    @objc func moveLeft() {
        if squareView.frame.origin.x - stepSize > 0 {
            UIView.animate(withDuration: 0.3) {
                self.squareView.center.x -= self.stepSize
            }
            checkCollision()
        }
    }
    
    @objc func moveRight() {
        if squareView.frame.origin.x + squareView.frame.size.width + stepSize <= view.frame.size.width {
            UIView.animate(withDuration: 0.3) {
                self.squareView.center.x += self.stepSize
            }
            checkCollision()
        }
    }
}
