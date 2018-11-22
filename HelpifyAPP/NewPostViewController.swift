
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class NewPostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imageUploaded : Bool = false
    var profileImage : UIImage = UIImage()
    var imagePicker = UIImagePickerController()
    var ref: DatabaseReference! = Database.database().reference()
    var storageRef = Storage.storage().reference()
    var postID : String = ""
    var downloadLink : String = ""
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var postTextView: UITextView!

    @IBAction func uploadImageButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select a source", message: "Passwords do not match", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadPostButton(_ sender: Any) {
        if imageUploaded{
            let currentUID = Auth.auth().currentUser?.uid
            let now = Date()
            let formatterA = DateFormatter()
            formatterA.timeZone = TimeZone.current
            formatterA.dateFormat = "yyyy-MM-dd"
            let formatterB = DateFormatter()
            formatterB.timeZone = TimeZone.current
            formatterB.dateFormat = "HH-mm"
            let date = formatterA.string(from: now)
            let time = formatterB.string(from: now)
            self.postID = currentUID! + time + date
            startAnimation()
            self.ref.child("Posts").child(currentUID!+date+"-"+time)
            ref.child("Users").child(currentUID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! NSDictionary
                let name = value["fullname"]!
                let pp = value["profileimage"]!
                self.ref.child("Posts").child(self.postID).updateChildValues(["date" : date])
                self.ref.child("Posts").child(self.postID).updateChildValues(["time" : time])
                self.ref.child("Posts").child(self.postID).updateChildValues(["fullname" : name])
                self.ref.child("Posts").child(self.postID).updateChildValues(["postimage" : self.downloadLink])
                self.ref.child("Posts").child(self.postID).updateChildValues(["profileimage" : pp as! String])
                self.ref.child("Posts").child(self.postID).updateChildValues(["uid" : currentUID!])
                self.ref.child("Posts").child(self.postID).updateChildValues(["description" : self.postTextView.text])
                DataManager.data.loadPosts(completion: { (didFinish) in
                    DataManager.data.MYtempPosts = Array<HelpifyPost>()
                    DataManager.data.fetchInstitutionPostsForMe(name: DataManager.data.user.fullname, completion: { (didFinish) in
                        self.stopAnimation()
                        self.performSegue(withIdentifier: "backFromPost" , sender: nil)
                    })
                })
            })
        }
        else{
            let alert = UIAlertController(title: "No post picture", message: "You must succesfully upload a post picture first, please wait until the upload process concludes.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let currentUID = Auth.auth().currentUser?.uid
        let now = Date()
        let formatterA = DateFormatter()
        formatterA.timeZone = TimeZone.current
        formatterA.dateFormat = "yyyy-MM-dd"
        let formatterB = DateFormatter()
        formatterB.timeZone = TimeZone.current
        formatterB.dateFormat = "HH-mm"
        let date = formatterA.string(from: now)
        let time = formatterB.string(from: now)
        self.postID = currentUID! + time + date
        var borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        postTextView.layer.borderWidth = 0.5
        postTextView.layer.borderColor = borderColor.cgColor
        postTextView.layer.cornerRadius = 5.0
        self.hideKeyboardWhenTappedAround()
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.profileImage = selectedImage
        startAnimation()
        let photoRef = self.storageRef.child("Post Images").child(self.postID + ".png")
        let data = self.profileImage.jpegData(compressionQuality: 0.05)! as NSData
        photoRef.putData(data as Data, metadata: nil, completion: { (mata, error) in
            photoRef.downloadURL(completion: { (url, error) in
                if let urlText = url?.absoluteString{
                    self.downloadLink = urlText
                    print("aquiiii!")
                    self.imageUploaded = true
                    self.stopAnimation()
                }
                else{
                    print("post error")
                }
            })
        })
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
    }
    
    func startAnimation(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopAnimation(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}
