/// 艾婭 A.I.Y.A 共用套件：城市低語（app: mw）與旅行團 TourChip（app: tour）共用。
/// - 繪圖：粒子全息（AiyaHolo／AiyaHoloPainter）、影片片段（AiyaVideo）、臉部表情、造型
/// - 伺服器：AiyaApi（status / consent / open / say 串流 / speak / close / report / verify）
/// - 語音通話：AiyaCall（艾婭之友，OpenAI GPT-Live）；舊的語音朗讀 AiyaVoice 保留
/// 聊天畫面、內購與文字翻譯留在各自的 App（設計系統與商品不同）。
library;

export 'src/aiya_api.dart';
export 'src/aiya_call.dart';
export 'src/aiya_face.dart';
export 'src/aiya_particles.dart';
export 'src/aiya_skins.dart';
export 'src/aiya_video.dart';
export 'src/aiya_voice.dart';
