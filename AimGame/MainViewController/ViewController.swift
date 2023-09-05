//
//  ViewController.swift
//  AimGame
//
//  Created by mac on 9/4/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    //MARK: - Stored property
    var aim: UIView?
    var timer = Timer()
    var counter: Int = 0
    var winnerStringURL: String?
    var loserStringURL: String?
    var isUserWon = false
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        aim = .init(frame: CGRect(x: 50, y: 50, width: 64, height: 64))
        aim?.isHidden = true
        aim?.backgroundColor = UIColor.systemPink
        aim?.layer.cornerRadius = (aim?.frame.size.width ?? 64) / 2
        
        guard let aimView = aim else { return }
        contentView.addSubview(aimView)
    }
    
    //MARK: - Actions
    
    @objc func handleAimTap(_ sender: UITapGestureRecognizer? = nil) {
        changeAimCoordinates()
        updateCounter()
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        startGame()
        let handleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleAimTap(_:)))
        aim?.addGestureRecognizer(handleTap)
        startButton.isHidden = true
        print(counter)
    }
    
    //MARK: - Game Logic func
    func changeAimCoordinates() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.aim?.frame = CGRect(x: getRandomPoint(min: 0, max: Int(self.contentView.frame.size.width) - 64),
                                     y: getRandomPoint(min: 0, max: Int(self.contentView.frame.size.height) - 64),
                                     width: 64, height: 64)
        }
    }
    
    
    func startGame() {
        aim?.isHidden = false
        changeAimCoordinates()
        startTimer()
    }
    
    func gameEnded() {
        startButton.isHidden = false
        aim?.isHidden = true
        checkGameResult()
        counter = 0
        timerInvalidate()
    }
    
    func updateCounter() {
        if counter == 9 {
            gameEnded()
            isUserWon = true
        } else {
            counter += 1
        }
    }
    
    func checkGameResult() {
        fetchResultLink { [weak self] in
            guard let self = self else { return }
            if isUserWon == true {
                showResultVC(url: loserStringURL)
            } else {
                showResultVC(url: winnerStringURL)
            }
        }
    }
    
    //MARK: - Navigation
    func showResultVC(url: String?) {
        guard let url = url else { return }
        DispatchQueue.main.async {
            let vc = GameResultViewController(urlString: url)
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
        }
    }
    
    
    //MARK: - Timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(timeIsOver), userInfo: nil, repeats: true)
    }
    
    @objc func timeIsOver() {
        gameEnded()
    }
    
    func timerInvalidate() {
        timer.invalidate()
    }
    
    //MARK: - Helper
    func getRandomPoint(min: Int, max: Int) -> Int {
        return Int.random(in: min..<max)
    }
}

