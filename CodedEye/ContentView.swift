//
//  ContentView.swift
//  CodedEye
//
//  Created by Apurv Pandey on 05/03/2023.
//
import Vision
import SwiftUI
import AVFoundation
import CoreML

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
    @State private var objectpopup = false
    @State private var personpopup = false
    @State var recognisedtext = "test"
    
    
    
    var body: some View {
        
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
                
            
            if textpopup{
                
                Color.black
                    .opacity(0.9)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        textpopup.toggle()
                        camera.retakePic()
                    }
            }
            else if objectpopup || personpopup{
                Color.black
                    .opacity(0.01)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        if objectpopup{
                            objectpopup.toggle()
                        }
                        else if personpopup{
                            personpopup.toggle()
                        }
                        camera.retakePic()
                           
                    }
            }
            
            VStack{
                
//                will be used to make the modes
                
                
                if textpopup{
                        
                            Text("Text Result")
                            .font(.custom("Grenze", size: 80))
                                .fontWeight(.regular)
                                .multilineTextAlignment(.center)
//                                .foregroundColor(Color(red: 0.82, green: 0.77, blue: 0.77,opacity: 1.0))
                                .foregroundStyle(.primary)
                        
                                Spacer()
                            

                            
                            
                        GeometryReader {proxy in
                            ScrollView{
                                Text(camera.recognisedtext)
                                    .fontWeight(.light)
//                                    .foregroundColor(.white)
                                    .foregroundStyle(.secondary)
                                    .background(.ultraThinMaterial)
                                    .multilineTextAlignment(.center)
                                    .cornerRadius(12)
                                    .padding([.leading, .bottom, .trailing], 50.0)
                                    .shadow(color: Color.black.opacity(0.5), radius:15, x: 0, y: 10)
                                    .font(.custom("Hanuman", size: 25))
                                    .frame(minHeight: proxy.size.height)
                                
                                
                            }
                        }
                            
                    HStack {
                        Spacer()
                        Button(action: {textpopup.toggle(); camera.retakePic()}, label: {Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                                .foregroundColor(.black)
//                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                                .font(.system(size: 35))
                        })
                        .padding(.trailing,20)
                    }
                            
                            Spacer()
                        }
                else if objectpopup{
                    
                    Text("Object Result")
                    .font(.custom("Grenze", size: 80))
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
//                        .foregroundColor(Color(red: 0.88, green: 0.77, blue: 0.77,opacity: 1.0))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    HStack {
                        
                        
                        let objecttext = "Object: " + camera.objectdetect + "\n" + "Confidence:" + String(round(camera.confidence * 10) / 10) + "%"
                        Text(objecttext)
                                    .fontWeight(.light)
//                                    .foregroundColor(.black)
                                    .foregroundStyle(.secondary)
//                                    .background(
//                                            Color.white
//                                                .blur(radius: 70, opaque: false)
//                                        )
                                    .background(.ultraThinMaterial)
                                    .multilineTextAlignment(.center)
                                    .cornerRadius(12)
                                    .padding([.leading, .trailing], 20.0)
                                    .shadow(color: Color.black.opacity(0.5), radius:15, x: 0, y: 10)
                                    .font(.custom("Hanuman", size: 30))
                              
                        Spacer()
                        Button(action: {objectpopup.toggle(); camera.retakePic()}, label: {Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                                .foregroundColor(.black)
//                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                                .font(.system(size: 35))
                        })
                        .padding(.trailing,20)
                    }
                }
                
                else if personpopup{
                    
                    Text("Person Result")
                    .font(.custom("Grenze", size: 75))
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
//                        .foregroundColor(Color(red: 0.88, green: 0.77, blue: 0.77,opacity: 1.0))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    
                    HStack{
                        Text("There are " + String(camera.faceObservations.count) + " person")
                                    .fontWeight(.light)
//                                    .foregroundColor(.black)
                                    .foregroundStyle(.secondary)
//                                    .background(
//                                            Color.white
//                                                .blur(radius: 70, opaque: false)
//                                        )
                                    .background(.ultraThinMaterial)
                                    .multilineTextAlignment(.center)
                                    .cornerRadius(12)
                                    .padding([.leading, .trailing], 20.0)
                                    .shadow(color: Color.black.opacity(0.5), radius:15, x: 0, y: 10)
                                    .font(.custom("Hanuman", size: 30))
                              
                        Spacer()
                        Button(action: {personpopup.toggle(); camera.retakePic()}, label: {Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                                .foregroundColor(.black)
//                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                                .font(.system(size: 35))
                        })
                        .padding(.trailing,20)
                    }
                    
                   
                    
                }

               else if camera.isTaken, !textpopup, !objectpopup, !personpopup{
                    
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
                else if !camera.isTaken, !textpopup, !objectpopup{
                    
                    HStack{
                        Button(action: {textToggle.toggle(); camera.textwork.toggle()}, label: {Image(systemName: "character.cursor.ibeam")
                                .foregroundColor(textToggle ? Color.green : Color.yellow)
                                .padding()
    //                        .background(Color.black)
                            .font(.system(size: 35))
                        })
                        
                            
                        Spacer()
                        
                        Button(action: {objectToggle.toggle(); camera.objectwork.toggle()}, label: {Image(systemName: "baseball.diamond.bases")
                                .foregroundColor(objectToggle ? Color.green : Color.yellow)
                                .padding(.all)
    //                            .background(Color.black)
                                .font(.system(size: 35))
                        })
                        
                
                        Spacer()
                        
                        Button(action: {personToggle.toggle(); camera.personwork.toggle()}, label: {Image(systemName: "person.fill")
                                .foregroundColor(personToggle ? Color.green : Color.yellow)
                                .padding(.all)
    //                            .background(Color.black)
                                .font(.system(size: 35))
                        })
                    }
                    
                }
                if !textpopup,!objectpopup, !personpopup {
                    Spacer()
                }
                HStack{
                    
                    if camera.isTaken, !textpopup,!objectpopup, !personpopup {
                        
                        Button(action: {
                            if textToggle{
                                textpopup.toggle()
                            
                            }
                            else if objectToggle{
                                objectpopup.toggle()
                                print("object time")
                            }
                            else if personToggle{
                                personpopup.toggle()
                            }
                            else{
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
                    else if !camera.isTaken, !textpopup, !objectpopup, !personpopup{
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
    @Published var objectwork = false
    @Published var personwork = false
    
    // for the output
    @Published var output = AVCapturePhotoOutput()
    
    //for the preview
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    @Published var recognisedtext = ""
    
    @Published var objectdetect = ""
    @Published var confidence = 0.0
    @Published var faceObservations: [VNFaceObservation] = []
    @Published var userImage: UIImage?
    
    
    

    
    
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
        
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        guard let image = UIImage(data: imageData) else {return}
        guard let cgimage = image.cgImage else {return}
        
        self.userImage = image
        
        if self.textwork{
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
                
                //print(recognizetext)
                
                self.recognisedtext = recognizetext
                
                
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
        else if objectwork {

            guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
                        fatalError("Failed to load ResNet50 model.")
                    }
            let handler = VNImageRequestHandler(cgImage: cgimage)
            let request = VNCoreMLRequest(model: model, completionHandler: handlePrediction)
            try? handler.perform([request])
        }
        
        else if personwork{
            let request = VNDetectFaceRectanglesRequest(completionHandler: handleFaces)
                let handler = VNImageRequestHandler(cgImage: cgimage, options: [:])

                do {
                    try handler.perform([request])
                } catch {
                    print("Failed to perform detection: \(error)")
                }
        }

  }
    
    func handleFaces(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation] else { return }
        
        DispatchQueue.main.async {
            self.faceObservations = observations
        }

//        print(observations.count)
//        for face in observations {
//            print("Face found at \(face.boundingBox)")
//
//        }
    }
    
    func handlePrediction(request: VNRequest, error: Error?) {
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                return
            }
            print("Object detected: \(topResult.identifier), confidence: \(topResult.confidence)")
        self.objectdetect = topResult.identifier
        self.confidence = Double((topResult.confidence)*100)
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
