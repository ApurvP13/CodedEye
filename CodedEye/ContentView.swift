//
//  ContentView.swift
//  CodedEye
//
//  Created by Apurv Pandey on 05/03/2023.
//
import Vision
import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
        CameraView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CameraView : View {
    @StateObject var camera = CameraModel()
    @State private var textToggle = false
    @State private var objectToggle = false
    @State private var personToggle = false
    @State private var textpopup = false
    @State var recognisedtext = "test"
    
    
    
    var body: some View {
        
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            if textpopup{
                
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        textpopup.toggle()
                        camera.retakePic()
                    }
            }
            
            VStack{
                
//                will be used to make the modes
                
                
                if textpopup{
                    
                    
                    Spacer()
                    
                    GeometryReader { geometry in
                                Text(recognisedtext)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .padding(.all)
                                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        
                                    
                            }
                    
                    Spacer()
                }
               else if camera.isTaken, !textpopup{
                    
                    HStack {
                        Spacer()
                        
                        Button(action: camera.retakePic, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                                
                        })
                        .padding(.trailing,10)
                    }
                }
                else if !camera.isTaken, !textpopup{
                    
                    HStack{
                        Button(action: {textToggle.toggle(); camera.textwork.toggle()}, label: {Image(systemName: "character.cursor.ibeam")
                                .foregroundColor(textToggle ? Color.green : Color.yellow)
                                .padding()
    //                        .background(Color.black)
                            .font(.system(size: 35))
                        })
                        
                            
                        Spacer()
                        
                        Button(action: {objectToggle.toggle()}, label: {Image(systemName: "baseball.diamond.bases")
                                .foregroundColor(objectToggle ? Color.green : Color.yellow)
                                .padding(.all)
    //                            .background(Color.black)
                                .font(.system(size: 35))
                        })
                        
                
                        Spacer()
                        
                        Button(action: {personToggle.toggle()}, label: {Image(systemName: "person.fill")
                                .foregroundColor(personToggle ? Color.green : Color.yellow)
                                .padding(.all)
    //                            .background(Color.black)
                                .font(.system(size: 35))
                        })
                    }
                    
                }
                
                Spacer()
                
                HStack{
                    
                    if camera.isTaken, !textpopup {
                        
                        Button(action: {
                            if textToggle{
                                camera.testxyz()
                                textpopup.toggle()
                            }else{
                                print("no text toggles also works")
                            }
                        }, label: {
                            Text("use this")
                                .foregroundColor(Color.black)
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                    }
                    else if !camera.isTaken, !textpopup{
                        Button(action: camera.takePic, label: {
                            
                            ZStack{
                                Circle().fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                    
                }
            }
        }
        .onAppear(perform: {
            camera.Check()
        })
    }
}

class CameraModel : NSObject,ObservableObject,AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var textwork = false
    
    // for the output
    @Published var output = AVCapturePhotoOutput()
    
    //for the preview
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    @Published var recognisedtext = ""
    
    func testxyz(){
        print("testing works")
    }
    
    
    func Check(){
        
        //checking if the app has permission for camera
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            //setting up the session
            SetUp()
            return
        case .notDetermined :
            //requesting for permission
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                
                if status{
                    self.SetUp()
                }
                
            }
        case .denied :
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func SetUp(){
        //setting up the camera
        
        do{
            //setting up the configs...
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            
            let input = try AVCaptureDeviceInput(device : device!)
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    //taking a picture
    
    func takePic(){
        DispatchQueue.global(qos: .background).async {
            
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            DispatchQueue.main.async { Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in self.session.stopRunning() } }
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func retakePic(){
        
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    

    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        if error != nil{
            return

        }

        print("pic taken")
        
        if self.textwork{
            guard let imageData = photo.fileDataRepresentation() else {return}
            guard let image = UIImage(data: imageData) else {return}
            guard let cgimage = image.cgImage else {return}
            
            let request = VNRecognizeTextRequest(completionHandler:  {(request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else{
                    print("Text recognition error : \(error?.localizedDescription ?? "")")
                    return
                }
                
                var recognizetext = ""
                
                for observation in observations {
                    guard let topCandidate = observation.topCandidates(1).first else {continue}
                    recognizetext += topCandidate.string + " "
                }
                
                print(recognizetext)
                
                self.recognisedtext = recognizetext
                
                //            DispatchQueue.main.async {
                //                if let cameraView = self.preview?.superlayer?.superlayer as? CameraView {
                //                    cameraView.recognisedtext = recognizetext.trimmingCharacters(in: .whitespacesAndNewlines)
                //                }
                //            }
            })
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let requests = [request]
            
            let imageRequestHandler = VNImageRequestHandler(cgImage: cgimage, orientation: .up, options: [:])
            
            do {
                try imageRequestHandler.perform(requests)
            } catch let error as NSError {
                print("failed \(error)")
            }
            
        }

  }
        
//
    
}

// setting the view for the preview

struct CameraPreview : UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    func makeUIView(context: Context) ->  UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        //starting session
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
