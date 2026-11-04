import AppKit
import Vision
import CoreImage

let src = NSImage(contentsOfFile: "aiya_ref.webp")!
var rect = NSRect(origin: .zero, size: src.size)
let cg = src.cgImage(forProposedRect: &rect, context: nil, hints: nil)!
let W = Double(cg.width), H = Double(cg.height)
print("image", W, H)

let handler = VNImageRequestHandler(cgImage: cg, options: [:])
let seg = VNGeneratePersonSegmentationRequest(); seg.qualityLevel = .accurate; seg.outputPixelFormat = kCVPixelFormatType_OneComponent8
let face = VNDetectFaceLandmarksRequest()
try! handler.perform([seg, face])
let maskBuf = seg.results!.first!.pixelBuffer
let fo = face.results!.first!
let bb = fo.boundingBox // normalized, origin bottom-left
print("face bb", bb)

// image coords (top-left origin, pixels)
func pt(_ p: CGPoint) -> CGPoint { CGPoint(x: p.x * W, y: (1 - p.y) * H) }
let lm = fo.landmarks!
func region(_ r: VNFaceLandmarkRegion2D?) -> [CGPoint] { (r?.pointsInImage(imageSize: CGSize(width: W, height: H)) ?? []).map { CGPoint(x: $0.x, y: H - $0.y) } }
let regs: [String: [CGPoint]] = [
  "leftEye": region(lm.leftEye), "rightEye": region(lm.rightEye),
  "leftPupil": region(lm.leftPupil), "rightPupil": region(lm.rightPupil),
  "leftBrow": region(lm.leftEyebrow), "rightBrow": region(lm.rightEyebrow),
  "outerLips": region(lm.outerLips), "innerLips": region(lm.innerLips),
  "contour": region(lm.faceContour), "nose": region(lm.nose),
]
// face box in pixels
let fx = bb.minX * W, fw = bb.width * W, fy = (1 - bb.maxY) * H, fh = bb.height * H
let cx = fx + fw / 2
let cropX = max(0, cx - fw * 1.75), cropW = min(W - cropX, fw * 3.5)
let cropY = max(0, fy - fh * 0.75), cropH = min(H - cropY, fh * 2.75)
print("crop", cropX, cropY, cropW, cropH)

// mask -> CGImage scaled to image size
let ciMask = CIImage(cvPixelBuffer: maskBuf)
let sx = W / ciMask.extent.width, sy = H / ciMask.extent.height
let ctx = CIContext()
let scaledMask = ciMask.transformed(by: CGAffineTransform(scaleX: sx, y: sy))
let maskCG = ctx.createCGImage(scaledMask, from: CGRect(x: 0, y: 0, width: W, height: H))!

let outW = 600, outH = Int(Double(outW) * cropH / cropW)
let cs = CGColorSpaceCreateDeviceRGB()
let out = CGContext(data: nil, width: outW, height: outH, bitsPerComponent: 8, bytesPerRow: outW * 4, space: cs, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
// draw masked crop: clip with mask
let k = Double(outW) / cropW
out.saveGState()
let maskRect = CGRect(x: -cropX * k, y: -(H - cropY - cropH) * k, width: W * k, height: H * k)
out.clip(to: maskRect, mask: maskCG)
out.draw(cg, in: maskRect)
out.restoreGState()
let outImg = out.makeImage()!
let rep = NSBitmapImageRep(cgImage: outImg)
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "aiya_cut.png"))

// landmarks in output pixel coords
var json: [String: [[Double]]] = [:]
for (k2, pts) in regs { json[k2] = pts.map { [($0.x - cropX) * k, ($0.y - cropY) * k] } }
json["size"] = [[Double(outW), Double(outH)]]
json["faceBox"] = [[(fx - cropX) * k, (fy - cropY) * k, fw * k, fh * k]]
let data = try! JSONSerialization.data(withJSONObject: json)
try! data.write(to: URL(fileURLWithPath: "aiya_landmarks.json"))
print("out", outW, outH)
