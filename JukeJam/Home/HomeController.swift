import UIKit
import FBSDKLoginKit
import FacebookLogin
import MediaPlayer
import FirebaseAuth
import SCLAlertView

class HomeController: MusicPlayingController, UICollectionViewDelegate{

    @IBOutlet weak var friendsJams: UICollectionView!
    @IBOutlet  var myJamsCarousal: UICollectionView!
    @IBOutlet weak var featuredJams: UICollectionView!
    @IBOutlet weak var scroll: UIScrollView!
    var myJamsArt: [coverArt] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
        tempLoadData()
        customizeButtons()
        myJamsCarousal.dataSource = self
        featuredJams.dataSource = self
        friendsJams.dataSource = self
        establishCells()
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
//      scroll.contentSize = CGSize(width: self.view.frame.width, height: 1300)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tempLoadData(){
        myJamsArt.append(coverArt(title: "Baby Boy Blue", author: "Nirvana", image: UIImage(named: "album1")!))
        myJamsArt.append(coverArt(title: "Nothing Was the Same", author: "Drake", image: UIImage(named: "album2")!))
        myJamsArt.append(coverArt(title: "Astroworld", author: "Travis Scott", image: UIImage(named: "album3")!))
        myJamsArt.append(coverArt(title: "Kulture II", author: "Migos", image: UIImage(named: "album4")!))
        myJamsArt.append(coverArt(title: "The Life of Pablo", author: "Kanye West", image: UIImage(named: "album5")!))
    }
    
    func establishCells(){
        let insetX:CGFloat = 8
        let insetY: CGFloat = 8
        myJamsCarousal?.setCollectionViewLayout(myJamsCarousal.collectionViewLayout as! UICollectionViewFlowLayout, animated: false)
        myJamsCarousal.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        featuredJams?.setCollectionViewLayout(featuredJams.collectionViewLayout as! UICollectionViewFlowLayout, animated: false)
        featuredJams.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        friendsJams?.setCollectionViewLayout(friendsJams.collectionViewLayout as! UICollectionViewFlowLayout, animated: false)
        friendsJams.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
    func customizeButtons(){
        self.navigationItem.leftBarButtonItem = getTabBarButton(type: .user, selector:#selector(showProfile))
        self.navigationItem.rightBarButtonItem = getTabBarButton(type: .cog, selector:#selector(showSettings))
    }
    @objc func showProfile(){
        print("Profile")
    }
    @objc func showSettings(){
        print("Settings")
    }

    @IBAction func testFunc(_ sender: UIButton) {
        let handler: AppleHandler = AppleHandler()
        //Checks to see if User has authorized
        //Put below in AppleHandler.play([ID]'s) function
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myJams" {
            let DestViewController: SeeMoreController = segue.destination as! SeeMoreController
            DestViewController.myTitle = "My Jams"
        }
        else if segue.identifier == "friendsJams" {
            let DestViewController: SeeMoreController = segue.destination as! SeeMoreController
            DestViewController.myTitle = "Friend's Jams"
        }else if segue.identifier == "featuredJams" {
            let DestViewController: SeeMoreController = segue.destination as! SeeMoreController
            DestViewController.myTitle = "Featured Jams"
        }
   
    }
    //Logs people out of their account
    @IBAction func logOut(_ sender: UIButton) {
        guard Auth.auth().currentUser != nil else {
            return
        }
        do {
            try Auth.auth().signOut()
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            let cookies = HTTPCookieStorage.shared
            let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
            for cookie in facebookCookies! {
                cookies.deleteCookie(cookie )
            }
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as? ViewController
            {
                present(vc, animated: true, completion: nil)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}

extension HomeController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.myJamsCarousal {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FocalCell", for: indexPath) as! FocalCell
        cell.coverArt = myJamsArt[indexPath.item]
        return cell
        }
        else if collectionView == self.friendsJams{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendJams", for: indexPath) as! FocalCell
            cell.coverArt = myJamsArt[myJamsArt.count - 1 - indexPath.item]
            return cell
        }
     else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedJam", for: indexPath) as! FocalCell
            cell.coverArt = myJamsArt[myJamsArt.count - 1 - indexPath.item]
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myJamsArt.count
    }

}
