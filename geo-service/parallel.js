// ============================================================================
// 平行宇宙：把其他國家的人，疊到你所在城市的雷達上
//
// 對應法：每座城市以它的中央車站為中心點（例如大台北＝台北車站、桃園＝桃園車站、
// 東京＝東京車站、橫濱＝橫濱車站）。你離自家車站往哪個方向、多少公里，
// 在對方城市就出現在離對方車站同方向、同樣公里數的地方（1:1，不縮放）。
// 所以台北車站東邊 3 公里的人，東京的人會在東京車站東邊約 3 公里看到他；
// 橫濱車站北邊 2 公里的人，台北的人會在台北車站北邊約 2 公里看到他。
//
// 誰對到誰：目前固定是「台灣 ↔ 其他國家」：台灣各縣市疊上所有國外城市，
// 國外城市疊上台灣各縣市；同一個國家內、國外之間不互疊。之後可能開放讓使用者選擇。
//
// 誰看得到誰：只要「其中一人」開啟平行宇宙就看得到對方。
//   都沒開 → 互相看不到；只有 B 開 → A 只看到 B 一個人，B 看到 A 城市所有人；
//   都開 → 兩座城市重疊，都看到對方城市所有人。
// 只有正開著 App 的人會跨城市；殘影、低語、低語穿越、集會都是在地的，不進平行宇宙。
//
// 位置不可還原：先在「原本的城市」把精確位置吸附到 500 公尺網格，
// 加上每人每天固定的偏移，才疊過去。所以看到的位置都至少有 500 公尺的誤差，也不會顯示真實距離。
//
// 永遠不包含中國大陸。
// ============================================================================

const crypto = require('crypto');

const GEO_KEY = 'parallel_users'; // 只放開啟平行宇宙的人（精確座標，跟 city_users 一樣不對外）
const ALL_KEY = 'city_users'; // 開啟的人看得到其他城市所有人
const CELL_METERS = 500;
const JITTER_FRACTION = 0.3; // 格內偏移最多 ±30%（±150 公尺）
const FUZZ_MARGIN_KM = 1; // 模糊化最多讓位置偏多遠（格子半對角線＋偏移，約 0.6 公里）再留餘裕
const DEFAULT_KM = 40; // 國外城市：離中心車站多少公里內算這座城市
const PER_CITY_RESULTS = 60;
const MAX_RESULTS = 30;
const METERS_PER_DEG_LAT = 111320;
const TAIWAN = 'tw';

// 台灣本島：方框內的位置都歸最近的縣市車站（方框內沒有中國大陸的土地）
const TAIWAN_MAIN_ISLAND = { box: [21.85, 25.35, 119.95, 122.1] };

// 城市：中心點（中央車站）、國家、成員範圍、各語言名稱
// 名稱順序 [繁中, 簡中, 英, 日, 韓, 馬來, 印尼, 越南, 泰, 葡, 西, 印地]（缺的語言用英文）。
// 成員範圍：預設是離車站 DEFAULT_KM 內；box = [南, 北, 西, 東]；circles = [[lat, lng, km], ...]
const CITIES = [
    // ---- 台灣：各縣市的中央車站 ----
    { id: 'keelung', country: TAIWAN, lat: 25.1319, lng: 121.7397, ...TAIWAN_MAIN_ISLAND, names: ['基隆', '基隆', 'Keelung', '基隆', '지룽', 'Keelung', 'Keelung', 'Cơ Long', 'จีหลง', 'Keelung', 'Keelung', 'कीलुंग'] }, // 基隆車站
    { id: 'taipei', country: TAIWAN, lat: 25.0478, lng: 121.5170, ...TAIWAN_MAIN_ISLAND, names: ['台北', '台北', 'Taipei', '台北', '타이베이', 'Taipei', 'Taipei', 'Đài Bắc', 'ไทเป', 'Taipé', 'Taipéi', 'ताइपे'] }, // 台北車站（大台北）
    { id: 'taoyuan', country: TAIWAN, lat: 24.9891, lng: 121.3134, ...TAIWAN_MAIN_ISLAND, names: ['桃園', '桃园', 'Taoyuan', '桃園', '타오위안', 'Taoyuan', 'Taoyuan', 'Đào Viên', 'เถาหยวน', 'Taoyuan', 'Taoyuan', 'ताओयुआन'] }, // 桃園車站
    { id: 'hsinchu', country: TAIWAN, lat: 24.8016, lng: 120.9716, ...TAIWAN_MAIN_ISLAND, names: ['新竹', '新竹', 'Hsinchu', '新竹', '신주', 'Hsinchu', 'Hsinchu', 'Tân Trúc', 'ซินจู๋', 'Hsinchu', 'Hsinchu', 'शिनचू'] }, // 新竹車站
    { id: 'miaoli', country: TAIWAN, lat: 24.5703, lng: 120.8222, ...TAIWAN_MAIN_ISLAND, names: ['苗栗', '苗栗', 'Miaoli', '苗栗', '먀오리', 'Miaoli', 'Miaoli', 'Miêu Lật', 'เหมียวลี่', 'Miaoli', 'Miaoli', 'मियाओली'] }, // 苗栗車站
    { id: 'taichung', country: TAIWAN, lat: 24.1372, lng: 120.6866, ...TAIWAN_MAIN_ISLAND, names: ['台中', '台中', 'Taichung', '台中', '타이중', 'Taichung', 'Taichung', 'Đài Trung', 'ไถจง', 'Taichung', 'Taichung', 'ताइचुंग'] }, // 台中車站
    { id: 'changhua', country: TAIWAN, lat: 24.0817, lng: 120.5386, ...TAIWAN_MAIN_ISLAND, names: ['彰化', '彰化', 'Changhua', '彰化', '장화', 'Changhua', 'Changhua', 'Chương Hóa', 'จางฮว่า', 'Changhua', 'Changhua', 'चांगहुआ'] }, // 彰化車站
    { id: 'nantou', country: TAIWAN, lat: 23.9106, lng: 120.6855, ...TAIWAN_MAIN_ISLAND, names: ['南投', '南投', 'Nantou', '南投', '난터우', 'Nantou', 'Nantou', 'Nam Đầu', 'หนานโถว', 'Nantou', 'Nantou', 'नानतोउ'] }, // 南投轉運站（南投市沒有火車站）
    { id: 'yunlin', country: TAIWAN, lat: 23.7116, lng: 120.5411, ...TAIWAN_MAIN_ISLAND, names: ['雲林', '云林', 'Yunlin', '雲林', '윈린', 'Yunlin', 'Yunlin', 'Vân Lâm', 'หยุนหลิน', 'Yunlin', 'Yunlin', 'युनलिन'] }, // 斗六車站
    { id: 'chiayi', country: TAIWAN, lat: 23.4791, lng: 120.4412, ...TAIWAN_MAIN_ISLAND, names: ['嘉義', '嘉义', 'Chiayi', '嘉義', '자이', 'Chiayi', 'Chiayi', 'Gia Nghĩa', 'เจียอี้', 'Chiayi', 'Chiayi', 'च्याई'] }, // 嘉義車站
    { id: 'tainan', country: TAIWAN, lat: 22.9971, lng: 120.2124, ...TAIWAN_MAIN_ISLAND, names: ['台南', '台南', 'Tainan', '台南', '타이난', 'Tainan', 'Tainan', 'Đài Nam', 'ไถหนาน', 'Tainan', 'Tainan', 'ताइनान'] }, // 台南車站
    { id: 'kaohsiung', country: TAIWAN, lat: 22.6393, lng: 120.3024, ...TAIWAN_MAIN_ISLAND, names: ['高雄', '高雄', 'Kaohsiung', '高雄', '가오슝', 'Kaohsiung', 'Kaohsiung', 'Cao Hùng', 'เกาสง', 'Kaohsiung', 'Kaohsiung', 'काओशुंग'] }, // 高雄車站
    { id: 'pingtung', country: TAIWAN, lat: 22.6693, lng: 120.4864, ...TAIWAN_MAIN_ISLAND, names: ['屏東', '屏东', 'Pingtung', '屏東', '핑둥', 'Pingtung', 'Pingtung', 'Bình Đông', 'ผิงตง', 'Pingtung', 'Pingtung', 'पिंगतुंग'] }, // 屏東車站
    { id: 'yilan', country: TAIWAN, lat: 24.7546, lng: 121.7582, ...TAIWAN_MAIN_ISLAND, names: ['宜蘭', '宜兰', 'Yilan', '宜蘭', '이란', 'Yilan', 'Yilan', 'Nghi Lan', 'อี๋หลาน', 'Yilan', 'Yilan', 'यिलान'] }, // 宜蘭車站
    { id: 'hualien', country: TAIWAN, lat: 23.9929, lng: 121.6013, ...TAIWAN_MAIN_ISLAND, names: ['花蓮', '花莲', 'Hualien', '花蓮', '화롄', 'Hualien', 'Hualien', 'Hoa Liên', 'ฮัวเหลียน', 'Hualien', 'Hualien', 'ह्वालिएन'] }, // 花蓮車站
    { id: 'taitung', country: TAIWAN, lat: 22.7935, lng: 121.1233, ...TAIWAN_MAIN_ISLAND, names: ['台東', '台东', 'Taitung', '台東', '타이둥', 'Taitung', 'Taitung', 'Đài Đông', 'ไถตง', 'Taitung', 'Taitung', 'ताइतुंग'] }, // 台東車站
    { id: 'penghu', country: TAIWAN, lat: 23.5667, lng: 119.5660, km: 35, names: ['澎湖', '澎湖', 'Penghu', '澎湖', '펑후', 'Penghu', 'Penghu', 'Bành Hồ', 'เผิงหู', 'Penghu', 'Penghu', 'पेंगहू'] }, // 馬公
    // 金門、馬祖緊鄰中國大陸：只收島上的範圍
    { id: 'kinmen', country: TAIWAN, lat: 24.4337, lng: 118.3170, box: [24.38, 24.535, 118.21, 118.48], names: ['金門', '金门', 'Kinmen', '金門', '진먼', 'Kinmen', 'Kinmen', 'Kim Môn', 'จินเหมิน', 'Kinmen', 'Kinmen', 'किनमेन'] }, // 金城車站
    { id: 'matsu', country: TAIWAN, lat: 26.1606, lng: 119.9497, circles: [[26.155, 119.935, 4], [26.225, 119.995, 3], [25.965, 119.95, 3], [26.365, 120.49, 3]], names: ['馬祖', '马祖', 'Matsu', '馬祖', '마쭈', 'Matsu', 'Matsu', 'Mã Tổ', 'หมาจู่', 'Matsu', 'Matsu', 'मात्सु'] }, // 南竿福澳港

    // ---- 日本 ----
    { id: 'tokyo', country: 'jp', lat: 35.6812, lng: 139.7671, names: ['東京', '东京', 'Tokyo', '東京', '도쿄', 'Tokyo', 'Tokyo', 'Tokyo', 'โตเกียว', 'Tóquio', 'Tokio', 'टोक्यो'] }, // 東京駅
    { id: 'yokohama', country: 'jp', lat: 35.4660, lng: 139.6223, names: ['橫濱', '横滨', 'Yokohama', '横浜', '요코하마', 'Yokohama', 'Yokohama', 'Yokohama', 'โยโกฮามา', 'Yokohama', 'Yokohama', 'योकोहामा'] }, // 横浜駅
    { id: 'osaka', country: 'jp', lat: 34.7024, lng: 135.4959, names: ['大阪', '大阪', 'Osaka', '大阪', '오사카', 'Osaka', 'Osaka', 'Osaka', 'โอซาก้า', 'Osaka', 'Osaka', 'ओसाका'] }, // 大阪駅
    { id: 'kyoto', country: 'jp', lat: 34.9858, lng: 135.7588, names: ['京都', '京都', 'Kyoto', '京都', '교토', 'Kyoto', 'Kyoto', 'Kyoto', 'เกียวโต', 'Quioto', 'Kioto', 'क्योटो'] }, // 京都駅
    { id: 'kobe', country: 'jp', lat: 34.6947, lng: 135.1953, names: ['神戶', '神户', 'Kobe', '神戸', '고베', 'Kobe', 'Kobe', 'Kobe', 'โกเบ', 'Kobe', 'Kobe', 'कोबे'] }, // 三ノ宮駅
    { id: 'nagoya', country: 'jp', lat: 35.1709, lng: 136.8815, names: ['名古屋', '名古屋', 'Nagoya', '名古屋', '나고야', 'Nagoya', 'Nagoya', 'Nagoya', 'นาโงยา', 'Nagoya', 'Nagoya', 'नागोया'] }, // 名古屋駅
    { id: 'fukuoka', country: 'jp', lat: 33.5902, lng: 130.4207, names: ['福岡', '福冈', 'Fukuoka', '福岡', '후쿠오카', 'Fukuoka', 'Fukuoka', 'Fukuoka', 'ฟุกุโอกะ', 'Fukuoka', 'Fukuoka', 'फ़ुकुओका'] }, // 博多駅
    { id: 'sapporo', country: 'jp', lat: 43.0686, lng: 141.3508, names: ['札幌', '札幌', 'Sapporo', '札幌', '삿포로', 'Sapporo', 'Sapporo', 'Sapporo', 'ซัปโปโร', 'Sapporo', 'Sapporo', 'सापोरो'] }, // 札幌駅
    { id: 'sendai', country: 'jp', lat: 38.2601, lng: 140.8823, names: ['仙台', '仙台', 'Sendai', '仙台', '센다이', 'Sendai', 'Sendai', 'Sendai', 'เซ็นได', 'Sendai', 'Sendai', 'सेंदाई'] }, // 仙台駅
    { id: 'hiroshima', country: 'jp', lat: 34.3973, lng: 132.4753, names: ['廣島', '广岛', 'Hiroshima', '広島', '히로시마', 'Hiroshima', 'Hiroshima', 'Hiroshima', 'ฮิโรชิมะ', 'Hiroshima', 'Hiroshima', 'हिरोशिमा'] }, // 広島駅
    { id: 'naha', country: 'jp', lat: 26.2149, lng: 127.6793, names: ['那霸', '那霸', 'Naha', '那覇', '나하', 'Naha', 'Naha', 'Naha', 'นาฮะ', 'Naha', 'Naha', 'नाहा'] }, // 県庁前駅
    { id: 'saitama', country: 'jp', lat: 35.9064, lng: 139.6239, names: ['埼玉', '埼玉', 'Saitama', 'さいたま', '사이타마', 'Saitama', 'Saitama', 'Saitama', 'ไซตามะ', 'Saitama', 'Saitama', 'साइतामा'] }, // 大宮駅
    { id: 'chiba', country: 'jp', lat: 35.6131, lng: 140.1134, names: ['千葉', '千叶', 'Chiba', '千葉', '지바', 'Chiba', 'Chiba', 'Chiba', 'ชิบะ', 'Chiba', 'Chiba', 'चिबा'] }, // 千葉駅
    { id: 'kawasaki', country: 'jp', lat: 35.5313, lng: 139.6969, names: ['川崎', '川崎', 'Kawasaki', '川崎', '가와사키', 'Kawasaki', 'Kawasaki', 'Kawasaki', 'คาวาซากิ', 'Kawasaki', 'Kawasaki', 'कावासाकी'] }, // 川崎駅
    { id: 'utsunomiya', country: 'jp', lat: 36.559, lng: 139.8985, names: ['宇都宮', '宇都宫', 'Utsunomiya', '宇都宮', '우쓰노미야', 'Utsunomiya', 'Utsunomiya', 'Utsunomiya', 'อุตสึโนมิยะ', 'Utsunomiya', 'Utsunomiya', 'उत्सुनोमिया'] }, // 宇都宮駅
    { id: 'mito', country: 'jp', lat: 36.3709, lng: 140.4764, names: ['水戶', '水户', 'Mito', '水戸', '미토', 'Mito', 'Mito', 'Mito', 'มิโตะ', 'Mito', 'Mito', 'मितो'] }, // 水戸駅
    { id: 'takasaki', country: 'jp', lat: 36.3227, lng: 139.0127, names: ['高崎', '高崎', 'Takasaki', '高崎', '다카사키', 'Takasaki', 'Takasaki', 'Takasaki', 'ทากาซากิ', 'Takasaki', 'Takasaki', 'ताकासाकी'] }, // 高崎駅
    { id: 'kofu', country: 'jp', lat: 35.6668, lng: 138.5688, names: ['甲府', '甲府', 'Kofu', '甲府', '고후', 'Kofu', 'Kofu', 'Kofu', 'โคฟุ', 'Kofu', 'Kofu', 'कोफ़ू'] }, // 甲府駅
    { id: 'shizuoka', country: 'jp', lat: 34.9716, lng: 138.389, names: ['靜岡', '静冈', 'Shizuoka', '静岡', '시즈오카', 'Shizuoka', 'Shizuoka', 'Shizuoka', 'ชิซูโอกะ', 'Shizuoka', 'Shizuoka', 'शिज़ुओका'] }, // 静岡駅
    { id: 'hamamatsu', country: 'jp', lat: 34.7037, lng: 137.7349, names: ['濱松', '滨松', 'Hamamatsu', '浜松', '하마마쓰', 'Hamamatsu', 'Hamamatsu', 'Hamamatsu', 'ฮามามัตสึ', 'Hamamatsu', 'Hamamatsu', 'हामामात्सु'] }, // 浜松駅
    { id: 'gifu', country: 'jp', lat: 35.4095, lng: 136.7564, names: ['岐阜', '岐阜', 'Gifu', '岐阜', '기후', 'Gifu', 'Gifu', 'Gifu', 'กิฟุ', 'Gifu', 'Gifu', 'गिफ़ू'] }, // 岐阜駅
    { id: 'nagano', country: 'jp', lat: 36.643, lng: 138.1887, names: ['長野', '长野', 'Nagano', '長野', '나가노', 'Nagano', 'Nagano', 'Nagano', 'นางาโนะ', 'Nagano', 'Nagano', 'नागानो'] }, // 長野駅
    { id: 'matsumoto', country: 'jp', lat: 36.2309, lng: 137.9644, names: ['松本', '松本', 'Matsumoto', '松本', '마쓰모토', 'Matsumoto', 'Matsumoto', 'Matsumoto', 'มัตสึโมโตะ', 'Matsumoto', 'Matsumoto', 'मात्सुमोतो'] }, // 松本駅
    { id: 'niigata', country: 'jp', lat: 37.9122, lng: 139.0613, names: ['新潟', '新潟', 'Niigata', '新潟', '니가타', 'Niigata', 'Niigata', 'Niigata', 'นีงาตะ', 'Niigata', 'Niigata', 'नीगाता'] }, // 新潟駅
    { id: 'toyama', country: 'jp', lat: 36.7012, lng: 137.2133, names: ['富山', '富山', 'Toyama', '富山', '도야마', 'Toyama', 'Toyama', 'Toyama', 'โทยามะ', 'Toyama', 'Toyama', 'तोयामा'] }, // 富山駅
    { id: 'kanazawa', country: 'jp', lat: 36.5781, lng: 136.648, names: ['金澤', '金泽', 'Kanazawa', '金沢', '가나자와', 'Kanazawa', 'Kanazawa', 'Kanazawa', 'คานาซาวะ', 'Kanazawa', 'Kanazawa', 'कानाज़ावा'] }, // 金沢駅
    { id: 'fukui', country: 'jp', lat: 36.062, lng: 136.2233, names: ['福井', '福井', 'Fukui', '福井', '후쿠이', 'Fukui', 'Fukui', 'Fukui', 'ฟุกุอิ', 'Fukui', 'Fukui', 'फ़ुकुई'] }, // 福井駅
    { id: 'nara', country: 'jp', lat: 34.6809, lng: 135.8196, names: ['奈良', '奈良', 'Nara', '奈良', '나라', 'Nara', 'Nara', 'Nara', 'นารา', 'Nara', 'Nara', 'नारा'] }, // 奈良駅
    { id: 'wakayama', country: 'jp', lat: 34.232, lng: 135.1914, names: ['和歌山', '和歌山', 'Wakayama', '和歌山', '와카야마', 'Wakayama', 'Wakayama', 'Wakayama', 'วากายามะ', 'Wakayama', 'Wakayama', 'वाकायामा'] }, // 和歌山駅
    { id: 'himeji', country: 'jp', lat: 34.827, lng: 134.6907, names: ['姬路', '姬路', 'Himeji', '姫路', '히메지', 'Himeji', 'Himeji', 'Himeji', 'ฮิเมจิ', 'Himeji', 'Himeji', 'हिमेजी'] }, // 姫路駅
    { id: 'okayama', country: 'jp', lat: 34.6661, lng: 133.9183, names: ['岡山', '冈山', 'Okayama', '岡山', '오카야마', 'Okayama', 'Okayama', 'Okayama', 'โอกายามะ', 'Okayama', 'Okayama', 'ओकायामा'] }, // 岡山駅
    { id: 'tottori', country: 'jp', lat: 35.494, lng: 134.2257, names: ['鳥取', '鸟取', 'Tottori', '鳥取', '돗토리', 'Tottori', 'Tottori', 'Tottori', 'ทตโตริ', 'Tottori', 'Tottori', 'तोत्तोरी'] }, // 鳥取駅
    { id: 'matsue', country: 'jp', lat: 35.4643, lng: 133.0631, names: ['松江', '松江', 'Matsue', '松江', '마쓰에', 'Matsue', 'Matsue', 'Matsue', 'มัตสึเอะ', 'Matsue', 'Matsue', 'मात्सुए'] }, // 松江駅
    { id: 'takamatsu', country: 'jp', lat: 34.3505, lng: 134.0467, names: ['高松', '高松', 'Takamatsu', '高松', '다카마쓰', 'Takamatsu', 'Takamatsu', 'Takamatsu', 'ทากามัตสึ', 'Takamatsu', 'Takamatsu', 'ताकामात्सु'] }, // 高松駅
    { id: 'tokushima', country: 'jp', lat: 34.0742, lng: 134.5512, names: ['德島', '德岛', 'Tokushima', '徳島', '도쿠시마', 'Tokushima', 'Tokushima', 'Tokushima', 'โทกูชิมะ', 'Tokushima', 'Tokushima', 'तोकुशिमा'] }, // 徳島駅
    { id: 'matsuyama', country: 'jp', lat: 33.8358, lng: 132.7636, names: ['愛媛松山', '爱媛松山', 'Matsuyama', '松山', '마쓰야마', 'Matsuyama', 'Matsuyama', 'Matsuyama', 'มัตสึยามะ', 'Matsuyama', 'Matsuyama', 'मात्सुयामा'] }, // 松山市駅
    { id: 'kochi', country: 'jp', lat: 33.5672, lng: 133.5434, names: ['高知', '高知', 'Kochi', '高知', '고치', 'Kochi', 'Kochi', 'Kochi', 'โคจิ', 'Kochi', 'Kochi', 'कोची (जापान)'] }, // 高知駅
    { id: 'kitakyushu', country: 'jp', lat: 33.8865, lng: 130.8827, names: ['北九州', '北九州', 'Kitakyushu', '北九州', '기타큐슈', 'Kitakyushu', 'Kitakyushu', 'Kitakyushu', 'คิตะกีวชู', 'Kitakyushu', 'Kitakyushu', 'कितक्यूशू'] }, // 小倉駅
    { id: 'saga', country: 'jp', lat: 33.2643, lng: 130.2975, names: ['佐賀', '佐贺', 'Saga', '佐賀', '사가', 'Saga', 'Saga', 'Saga', 'ซางะ', 'Saga', 'Saga', 'सागा'] }, // 佐賀駅
    { id: 'nagasaki', country: 'jp', lat: 32.7522, lng: 129.8697, names: ['長崎', '长崎', 'Nagasaki', '長崎', '나가사키', 'Nagasaki', 'Nagasaki', 'Nagasaki', 'นางาซากิ', 'Nagasaki', 'Nagasaki', 'नागासाकी'] }, // 長崎駅
    { id: 'kumamoto', country: 'jp', lat: 32.7899, lng: 130.6886, names: ['熊本', '熊本', 'Kumamoto', '熊本', '구마모토', 'Kumamoto', 'Kumamoto', 'Kumamoto', 'คุมาโมโตะ', 'Kumamoto', 'Kumamoto', 'कुमामोतो'] }, // 熊本駅
    { id: 'oita', country: 'jp', lat: 33.2333, lng: 131.6064, names: ['大分', '大分', 'Oita', '大分', '오이타', 'Oita', 'Oita', 'Oita', 'โออิตะ', 'Oita', 'Oita', 'ओइता'] }, // 大分駅
    { id: 'miyazaki', country: 'jp', lat: 31.9156, lng: 131.432, names: ['宮崎', '宫崎', 'Miyazaki', '宮崎', '미야자키', 'Miyazaki', 'Miyazaki', 'Miyazaki', 'มิยาซากิ', 'Miyazaki', 'Miyazaki', 'मियाज़ाकी'] }, // 宮崎駅
    { id: 'kagoshima', country: 'jp', lat: 31.5838, lng: 130.5413, names: ['鹿兒島', '鹿儿岛', 'Kagoshima', '鹿児島', '가고시마', 'Kagoshima', 'Kagoshima', 'Kagoshima', 'คาโงชิมะ', 'Kagoshima', 'Kagoshima', 'कागोशिमा'] }, // 鹿児島中央駅
    { id: 'fukushima', country: 'jp', lat: 37.7544, lng: 140.4593, names: ['福島', '福岛', 'Fukushima', '福島', '후쿠시마', 'Fukushima', 'Fukushima', 'Fukushima', 'ฟุกุชิมะ', 'Fukushima', 'Fukushima', 'फ़ुकुशिमा'] }, // 福島駅
    { id: 'yamagata', country: 'jp', lat: 38.2486, lng: 140.3277, names: ['山形', '山形', 'Yamagata', '山形', '야마가타', 'Yamagata', 'Yamagata', 'Yamagata', 'ยามากาตะ', 'Yamagata', 'Yamagata', 'यामागाता'] }, // 山形駅
    { id: 'akita', country: 'jp', lat: 39.717, lng: 140.1294, names: ['秋田', '秋田', 'Akita', '秋田', '아키타', 'Akita', 'Akita', 'Akita', 'อากิตะ', 'Akita', 'Akita', 'अकिता'] }, // 秋田駅
    { id: 'morioka', country: 'jp', lat: 39.7016, lng: 141.1365, names: ['盛岡', '盛冈', 'Morioka', '盛岡', '모리오카', 'Morioka', 'Morioka', 'Morioka', 'โมริโอกะ', 'Morioka', 'Morioka', 'मोरिओका'] }, // 盛岡駅
    { id: 'aomori', country: 'jp', lat: 40.8288, lng: 140.7341, names: ['青森', '青森', 'Aomori', '青森', '아오모리', 'Aomori', 'Aomori', 'Aomori', 'อาโอโมริ', 'Aomori', 'Aomori', 'आओमोरी'] }, // 青森駅
    { id: 'hakodate', country: 'jp', lat: 41.7737, lng: 140.7266, names: ['函館', '函馆', 'Hakodate', '函館', '하코다테', 'Hakodate', 'Hakodate', 'Hakodate', 'ฮาโกดาเตะ', 'Hakodate', 'Hakodate', 'हाकोदाते'] }, // 函館駅
    { id: 'asahikawa', country: 'jp', lat: 43.7628, lng: 142.3581, names: ['旭川', '旭川', 'Asahikawa', '旭川', '아사히카와', 'Asahikawa', 'Asahikawa', 'Asahikawa', 'อาซาฮิกาวะ', 'Asahikawa', 'Asahikawa', 'असाहिकावा'] }, // 旭川駅

    // ---- 韓國 ----
    { id: 'seoul', country: 'kr', lat: 37.5547, lng: 126.9707, names: ['首爾', '首尔', 'Seoul', 'ソウル', '서울', 'Seoul', 'Seoul', 'Seoul', 'โซล', 'Seul', 'Seúl', 'सियोल'] }, // 서울역
    { id: 'busan', country: 'kr', lat: 35.1152, lng: 129.0414, names: ['釜山', '釜山', 'Busan', '釜山', '부산', 'Busan', 'Busan', 'Busan', 'ปูซาน', 'Busan', 'Busan', 'बुसान'] }, // 부산역
    { id: 'daegu', country: 'kr', lat: 35.8793, lng: 128.6285, names: ['大邱', '大邱', 'Daegu', '大邱', '대구', 'Daegu', 'Daegu', 'Daegu', 'แทกู', 'Daegu', 'Daegu', 'देगू'] }, // 동대구역
    { id: 'daejeon', country: 'kr', lat: 36.3323, lng: 127.4346, names: ['大田', '大田', 'Daejeon', '大田', '대전', 'Daejeon', 'Daejeon', 'Daejeon', 'แทจอน', 'Daejeon', 'Daejeon', 'देजॉन'] }, // 대전역
    { id: 'gwangju', country: 'kr', lat: 35.1655, lng: 126.9092, names: ['光州', '光州', 'Gwangju', '光州', '광주', 'Gwangju', 'Gwangju', 'Gwangju', 'ควังจู', 'Gwangju', 'Gwangju', 'ग्वांगजू'] }, // 광주역
    { id: 'incheon', country: 'kr', lat: 37.4563, lng: 126.7052, names: ['仁川', '仁川', 'Incheon', '仁川', '인천', 'Incheon', 'Incheon', 'Incheon', 'อินชอน', 'Incheon', 'Incheon', 'इंचियोन'] }, // 인천시청（沒有中央車站）
    { id: 'suwon', country: 'kr', lat: 37.2659, lng: 127.0, names: ['水原', '水原', 'Suwon', '水原', '수원', 'Suwon', 'Suwon', 'Suwon', 'ซูวอน', 'Suwon', 'Suwon', 'सुवॉन'] }, // 수원역
    { id: 'ulsan', country: 'kr', lat: 35.5384, lng: 129.3114, names: ['蔚山', '蔚山', 'Ulsan', '蔚山', '울산', 'Ulsan', 'Ulsan', 'Ulsan', 'อุลซาน', 'Ulsan', 'Ulsan', 'उल्सान'] }, // 울산시청
    { id: 'changwon', country: 'kr', lat: 35.228, lng: 128.6811, names: ['昌原', '昌原', 'Changwon', '昌原', '창원', 'Changwon', 'Changwon', 'Changwon', 'ชางวอน', 'Changwon', 'Changwon', 'चांगवॉन'] }, // 창원시청
    { id: 'gyeongju', country: 'kr', lat: 35.8562, lng: 129.2247, names: ['慶州', '庆州', 'Gyeongju', '慶州', '경주', 'Gyeongju', 'Gyeongju', 'Gyeongju', 'คย็องจู', 'Gyeongju', 'Gyeongju', 'ग्योंगजू'] }, // 경주시청
    { id: 'jeonju', country: 'kr', lat: 35.85, lng: 127.1617, names: ['全州', '全州', 'Jeonju', '全州', '전주', 'Jeonju', 'Jeonju', 'Jeonju', 'ชอนจู', 'Jeonju', 'Jeonju', 'जॉनजू'] }, // 전주역
    { id: 'jeju', country: 'kr', lat: 33.4996, lng: 126.5312, km: 35, names: ['濟州', '济州', 'Jeju', '済州', '제주', 'Jeju', 'Jeju', 'Jeju', 'เชจู', 'Jeju', 'Jeju', 'जेजू'] }, // 제주시청（島上沒有鐵路）

    // ---- 香港、澳門：北邊就是中國大陸，只收原本的範圍並排除邊界 ----
    { id: 'hongkong', country: 'hk', lat: 22.2850, lng: 114.1580, circles: [[22.3193, 114.1694, 26]], names: ['香港', '香港', 'Hong Kong', '香港', '홍콩', 'Hong Kong', 'Hong Kong', 'Hồng Kông', 'ฮ่องกง', 'Hong Kong', 'Hong Kong', 'हांगकांग'] }, // 香港站
    { id: 'macau', country: 'mo', lat: 22.1935, lng: 113.5395, circles: [[22.1757, 113.5560, 7]], names: ['澳門', '澳门', 'Macau', 'マカオ', '마카오', 'Macau', 'Makau', 'Ma Cao', 'มาเก๊า', 'Macau', 'Macao', 'मकाऊ'] }, // 議事亭前地

    // ---- 東南亞 ----
    // 新加坡：只收新加坡島（北邊柔佛海峽、南邊巴淡島不算）
    { id: 'singapore', country: 'sg', lat: 1.2930, lng: 103.8520, box: [1.19, 1.452, 103.59, 104.1], names: ['新加坡', '新加坡', 'Singapore', 'シンガポール', '싱가포르', 'Singapura', 'Singapura', 'Singapore', 'สิงคโปร์', 'Singapura', 'Singapur', 'सिंगापुर'] }, // City Hall
    { id: 'kualalumpur', country: 'my', lat: 3.1343, lng: 101.6863, names: ['吉隆坡', '吉隆坡', 'Kuala Lumpur', 'クアラルンプール', '쿠알라룸푸르', 'Kuala Lumpur', 'Kuala Lumpur', 'Kuala Lumpur', 'กัวลาลัมเปอร์', 'Kuala Lumpur', 'Kuala Lumpur', 'कुआलालंपुर'] }, // KL Sentral
    { id: 'penang', country: 'my', lat: 5.4145, lng: 100.3295, km: 25, names: ['檳城', '槟城', 'Penang', 'ペナン', '페낭', 'Pulau Pinang', 'Penang', 'Penang', 'ปีนัง', 'Penang', 'Penang', 'पेनांग'] }, // Komtar
    { id: 'johorbahru', country: 'my', lat: 1.4632, lng: 103.7646, box: [1.452, 1.75, 103.4, 104.1], names: ['新山', '新山', 'Johor Bahru', 'ジョホールバル', '조호르바루', 'Johor Bahru', 'Johor Bahru', 'Johor Bahru', 'ยะโฮร์บาห์รู', 'Johor Bahru', 'Johor Bahru', 'जोहोर बाहरू'] }, // JB Sentral
    { id: 'melaka', country: 'my', lat: 2.1942, lng: 102.249, km: 30, names: ['馬六甲', '马六甲', 'Malacca', 'マラッカ', '믈라카', 'Melaka', 'Malaka', 'Malacca', 'มะละกา', 'Malaca', 'Malaca', 'मलक्का'] }, // Stadthuys 紅屋（舊市政廳）
    { id: 'seremban', country: 'my', lat: 2.7189, lng: 101.9405, km: 25, names: ['芙蓉', '芙蓉', 'Seremban', 'スレンバン', '세렘반', 'Seremban', 'Seremban', 'Seremban', 'เซเรมบัน', 'Seremban', 'Seremban', 'सेरेम्बान'] }, // Seremban 車站
    { id: 'ipoh', country: 'my', lat: 4.5975, lng: 101.0748, names: ['怡保', '怡保', 'Ipoh', 'イポー', '이포', 'Ipoh', 'Ipoh', 'Ipoh', 'อีโปห์', 'Ipoh', 'Ipoh', 'ईपोह'] }, // Ipoh 車站
    { id: 'alorsetar', country: 'my', lat: 6.121, lng: 100.3678, names: ['亞羅士打', '亚罗士打', 'Alor Setar', 'アロースター', '알로르스타르', 'Alor Setar', 'Alor Setar', 'Alor Setar', 'อลอร์สตาร์', 'Alor Setar', 'Alor Setar', 'अलोर सेतार'] }, // Alor Setar 車站
    { id: 'langkawi', country: 'my', lat: 6.324, lng: 99.85, km: 25, names: ['蘭卡威', '兰卡威', 'Langkawi', 'ランカウイ', '랑카위', 'Langkawi', 'Langkawi', 'Langkawi', 'ลังกาวี', 'Langkawi', 'Langkawi', 'लंगकावी'] }, // Kuah
    { id: 'kotabharu', country: 'my', lat: 6.1254, lng: 102.2381, names: ['哥打峇魯', '哥打巴鲁', 'Kota Bharu', 'コタバル', '코타바루', 'Kota Bharu', 'Kota Bharu', 'Kota Bharu', 'โกตาบารู', 'Kota Bharu', 'Kota Bharu', 'कोटा भारू'] }, // Kota Bharu 市中心
    { id: 'kualaterengganu', country: 'my', lat: 5.3302, lng: 103.1408, names: ['瓜拉登嘉樓', '瓜拉登嘉楼', 'Kuala Terengganu', 'クアラトレンガヌ', '쿠알라테렝가누', 'Kuala Terengganu', 'Kuala Terengganu', 'Kuala Terengganu', 'กัวลาตรังกานู', 'Kuala Terengganu', 'Kuala Terengganu', 'कुआला तेरेंगानु'] }, // Kuala Terengganu 市中心
    { id: 'kuantan', country: 'my', lat: 3.8077, lng: 103.326, names: ['關丹', '关丹', 'Kuantan', 'クアンタン', '콴탄', 'Kuantan', 'Kuantan', 'Kuantan', 'กวนตัน', 'Kuantan', 'Kuantan', 'कुआंतान'] }, // Kuantan 市中心
    { id: 'kuching', country: 'my', lat: 1.5576, lng: 110.3439, names: ['古晉', '古晋', 'Kuching', 'クチン', '쿠칭', 'Kuching', 'Kuching', 'Kuching', 'กูชิง', 'Kuching', 'Kuching', 'कूचिंग'] }, // Kuching Waterfront
    { id: 'sibu', country: 'my', lat: 2.287, lng: 111.8305, names: ['詩巫', '诗巫', 'Sibu', 'シブ', '시부', 'Sibu', 'Sibu', 'Sibu', 'ซีบู', 'Sibu', 'Sibu', 'सिबू'] }, // Sibu 市中心
    { id: 'miri', country: 'my', lat: 4.3995, lng: 113.9914, km: 30, names: ['美里', '美里', 'Miri', 'ミリ', '미리', 'Miri', 'Miri', 'Miri', 'มีรี', 'Miri', 'Miri', 'मिरी'] }, // Miri 市中心
    { id: 'kotakinabalu', country: 'my', lat: 5.9804, lng: 116.0735, names: ['亞庇', '亚庇', 'Kota Kinabalu', 'コタキナバル', '코타키나발루', 'Kota Kinabalu', 'Kota Kinabalu', 'Kota Kinabalu', 'โกตากินาบาลู', 'Kota Kinabalu', 'Kota Kinabalu', 'कोटा किनाबालु'] }, // Kota Kinabalu 市中心
    { id: 'jakarta', country: 'id', lat: -6.1766, lng: 106.8307, names: ['雅加達', '雅加达', 'Jakarta', 'ジャカルタ', '자카르타', 'Jakarta', 'Jakarta', 'Jakarta', 'จาการ์ตา', 'Jacarta', 'Yakarta', 'जकार्ता'] }, // Stasiun Gambir
    { id: 'bandung', country: 'id', lat: -6.9142, lng: 107.6025, km: 30, names: ['萬隆', '万隆', 'Bandung', 'バンドン', '반둥', 'Bandung', 'Bandung', 'Bandung', 'บันดุง', 'Bandung', 'Bandung', 'बांडुंग'] }, // Stasiun Bandung
    { id: 'surabaya', country: 'id', lat: -7.2654, lng: 112.7517, names: ['泗水', '泗水', 'Surabaya', 'スラバヤ', '수라바야', 'Surabaya', 'Surabaya', 'Surabaya', 'สุราบายา', 'Surabaya', 'Surabaya', 'सुराबाया'] }, // Stasiun Gubeng
    { id: 'bali', country: 'id', lat: -8.6566, lng: 115.2166, km: 35, names: ['峇里島', '巴厘岛', 'Bali', 'バリ島', '발리', 'Bali', 'Bali', 'Bali', 'บาหลี', 'Bali', 'Bali', 'बाली'] }, // Denpasar
    { id: 'batam', country: 'id', lat: 1.129, lng: 104.053, box: [0.9, 1.19, 103.85, 104.25], names: ['巴淡島', '巴淡岛', 'Batam', 'バタム', '바탐', 'Batam', 'Batam', 'Batam', 'บาตัม', 'Batam', 'Batam', 'बाटाम'] }, // Batam Centre（新加坡島不算）
    { id: 'medan', country: 'id', lat: 3.5913, lng: 98.6797, names: ['棉蘭', '棉兰', 'Medan', 'メダン', '메단', 'Medan', 'Medan', 'Medan', 'เมดาน', 'Medan', 'Medan', 'मेदान'] }, // Stasiun Medan
    { id: 'semarang', country: 'id', lat: -6.9645, lng: 110.4278, names: ['三寶壟', '三宝垄', 'Semarang', 'スマラン', '스마랑', 'Semarang', 'Semarang', 'Semarang', 'เซมารัง', 'Semarang', 'Semarang', 'सेमारांग'] }, // Stasiun Tawang
    { id: 'yogyakarta', country: 'id', lat: -7.7891, lng: 110.3634, names: ['日惹', '日惹', 'Yogyakarta', 'ジョグジャカルタ', '욕야카르타', 'Yogyakarta', 'Yogyakarta', 'Yogyakarta', 'ยอกยาการ์ตา', 'Yogyakarta', 'Yogyakarta', 'योग्याकार्ता'] }, // Stasiun Tugu
    { id: 'makassar', country: 'id', lat: -5.1435, lng: 119.4075, names: ['望加錫', '望加锡', 'Makassar', 'マカッサル', '마카사르', 'Makassar', 'Makassar', 'Makassar', 'มากัสซาร์', 'Makassar', 'Makassar', 'मकास्सर'] }, // Pantai Losari
    { id: 'hochiminh', country: 'vn', lat: 10.7823, lng: 106.6770, names: ['胡志明市', '胡志明市', 'Ho Chi Minh City', 'ホーチミン', '호찌민', 'Ho Chi Minh', 'Ho Chi Minh', 'TP. Hồ Chí Minh', 'โฮจิมินห์', 'Cidade de Ho Chi Minh', 'Ciudad Ho Chi Minh', 'हो ची मिन्ह सिटी'] }, // Ga Sài Gòn
    { id: 'hanoi', country: 'vn', lat: 21.0246, lng: 105.8411, names: ['河內', '河内', 'Hanoi', 'ハノイ', '하노이', 'Hanoi', 'Hanoi', 'Hà Nội', 'ฮานอย', 'Hanói', 'Hanói', 'हनोई'] }, // Ga Hà Nội
    { id: 'danang', country: 'vn', lat: 16.0716, lng: 108.2093, km: 30, names: ['峴港', '岘港', 'Da Nang', 'ダナン', '다낭', 'Da Nang', 'Da Nang', 'Đà Nẵng', 'ดานัง', 'Da Nang', 'Da Nang', 'दा नांग'] }, // Ga Đà Nẵng
    { id: 'haiphong', country: 'vn', lat: 20.8564, lng: 106.688, names: ['海防', '海防', 'Hai Phong', 'ハイフォン', '하이퐁', 'Hai Phong', 'Hai Phong', 'Hải Phòng', 'ไฮฟอง', 'Hai Phong', 'Hai Phong', 'हाइफ़ोंग'] }, // Ga Hải Phòng
    { id: 'halong', country: 'vn', lat: 20.955, lng: 107.045, km: 30, names: ['下龍', '下龙', 'Ha Long', 'ハロン', '하롱', 'Ha Long', 'Ha Long', 'Hạ Long', 'ฮาลอง', 'Ha Long', 'Ha Long', 'हा लॉन्ग'] }, // Bãi Cháy
    { id: 'vinh', country: 'vn', lat: 18.683, lng: 105.672, names: ['榮市', '荣市', 'Vinh', 'ヴィン', '빈', 'Vinh', 'Vinh', 'Vinh', 'วินห์', 'Vinh', 'Vinh', 'विन्ह'] }, // Ga Vinh
    { id: 'hue', country: 'vn', lat: 16.4567, lng: 107.5784, names: ['順化', '顺化', 'Hue', 'フエ', '후에', 'Hue', 'Hue', 'Huế', 'เว้', 'Huế', 'Hue', 'ह्वे'] }, // Ga Huế
    { id: 'hoian', country: 'vn', lat: 15.8801, lng: 108.338, km: 20, names: ['會安', '会安', 'Hoi An', 'ホイアン', '호이안', 'Hoi An', 'Hoi An', 'Hội An', 'ฮอยอัน', 'Hoi An', 'Hoi An', 'होई आन'] }, // Hội An 古城
    { id: 'quynhon', country: 'vn', lat: 13.7765, lng: 109.2237, names: ['歸仁', '归仁', 'Quy Nhon', 'クイニョン', '꾸이년', 'Quy Nhon', 'Quy Nhon', 'Quy Nhơn', 'กวีเญิน', 'Quy Nhon', 'Quy Nhon', 'क्वी न्होन'] }, // Quy Nhơn 市中心
    { id: 'nhatrang', country: 'vn', lat: 12.2486, lng: 109.1817, names: ['芽莊', '芽庄', 'Nha Trang', 'ニャチャン', '나트랑', 'Nha Trang', 'Nha Trang', 'Nha Trang', 'ญาจาง', 'Nha Trang', 'Nha Trang', 'न्हा ट्रांग'] }, // Ga Nha Trang
    { id: 'dalat', country: 'vn', lat: 11.9429, lng: 108.4371, names: ['大叻', '大叻', 'Da Lat', 'ダラット', '달랏', 'Da Lat', 'Da Lat', 'Đà Lạt', 'ดาลัด', 'Da Lat', 'Da Lat', 'दा लाट'] }, // Chợ Đà Lạt
    { id: 'binhduong', country: 'vn', lat: 10.9804, lng: 106.6519, km: 25, names: ['平陽', '平阳', 'Binh Duong', 'ビンズオン', '빈즈엉', 'Binh Duong', 'Binh Duong', 'Bình Dương', 'บิ่ญเซือง', 'Binh Duong', 'Binh Duong', 'बिन्ह दुओंग'] }, // Thủ Dầu Một 市中心
    { id: 'bienhoa', country: 'vn', lat: 10.9447, lng: 106.8243, km: 25, names: ['邊和', '边和', 'Bien Hoa', 'ビエンホア', '비엔호아', 'Bien Hoa', 'Bien Hoa', 'Biên Hòa', 'เบียนหัว', 'Bien Hoa', 'Bien Hoa', 'बिएन होआ'] }, // Ga Biên Hòa
    { id: 'vungtau', country: 'vn', lat: 10.346, lng: 107.0843, km: 30, names: ['頭頓', '头顿', 'Vung Tau', 'ブンタウ', '붕따우', 'Vung Tau', 'Vung Tau', 'Vũng Tàu', 'หวุงเต่า', 'Vung Tau', 'Vung Tau', 'वुंग ताउ'] }, // Vũng Tàu 市中心
    { id: 'cantho', country: 'vn', lat: 10.034, lng: 105.788, names: ['芹苴', '芹苴', 'Can Tho', 'カントー', '껀터', 'Can Tho', 'Can Tho', 'Cần Thơ', 'เกิ่นเทอ', 'Can Tho', 'Can Tho', 'कान थो'] }, // Bến Ninh Kiều
    { id: 'phuquoc', country: 'vn', lat: 10.217, lng: 103.959, km: 30, names: ['富國島', '富国岛', 'Phu Quoc', 'フーコック', '푸꾸옥', 'Phu Quoc', 'Phu Quoc', 'Phú Quốc', 'ฟูโกว๊ก', 'Phu Quoc', 'Phu Quoc', 'फ़ू क्वोक'] }, // Dương Đông
    // 泰國、菲律賓：曼谷以華藍蓬（舊中央車站）為中心；馬尼拉以 LRT 中央車站（Central Terminal）為中心
    { id: 'bangkok', country: 'th', lat: 13.7392, lng: 100.5172, names: ['曼谷', '曼谷', 'Bangkok', 'バンコク', '방콕', 'Bangkok', 'Bangkok', 'Bangkok', 'กรุงเทพฯ', 'Bangkok', 'Bangkok', 'बैंकॉक'] }, // หัวลำโพง
    { id: 'chiangmai', country: 'th', lat: 18.7877, lng: 98.9931, names: ['清邁', '清迈', 'Chiang Mai', 'チェンマイ', '치앙마이', 'Chiang Mai', 'Chiang Mai', 'Chiang Mai', 'เชียงใหม่', 'Chiang Mai', 'Chiang Mai', 'चियांग माई'] }, // ประตูท่าแพ 塔佩門
    { id: 'khonkaen', country: 'th', lat: 16.432, lng: 102.8236, names: ['孔敬', '孔敬', 'Khon Kaen', 'コンケン', '콘깬', 'Khon Kaen', 'Khon Kaen', 'Khon Kaen', 'ขอนแก่น', 'Khon Kaen', 'Khon Kaen', 'खोन केन'] }, // สถานีขอนแก่น
    { id: 'korat', country: 'th', lat: 14.975, lng: 102.099, names: ['呵叻', '呵叻', 'Korat', 'コラート', '코랏', 'Korat', 'Korat', 'Korat', 'โคราช', 'Korat', 'Korat', 'कोराट'] }, // สถานีนครราชสีมา
    { id: 'pattaya', country: 'th', lat: 12.9276, lng: 100.8771, km: 25, names: ['芭達雅', '芭堤雅', 'Pattaya', 'パタヤ', '파타야', 'Pattaya', 'Pattaya', 'Pattaya', 'พัทยา', 'Pattaya', 'Pattaya', 'पटाया'] }, // Pattaya 市中心
    { id: 'phuket', country: 'th', lat: 7.884, lng: 98.3923, km: 30, names: ['普吉', '普吉', 'Phuket', 'プーケット', '푸껫', 'Phuket', 'Phuket', 'Phuket', 'ภูเก็ต', 'Phuket', 'Phuket', 'फ़ुकेत'] }, // Phuket Town
    { id: 'hatyai', country: 'th', lat: 7.0086, lng: 100.4747, names: ['合艾', '合艾', 'Hat Yai', 'ハジャイ', '핫야이', 'Hat Yai', 'Hat Yai', 'Hat Yai', 'หาดใหญ่', 'Hat Yai', 'Hat Yai', 'हात याई'] }, // สถานีหาดใหญ่
    { id: 'manila', country: 'ph', lat: 14.5929, lng: 120.9817, names: ['馬尼拉', '马尼拉', 'Manila', 'マニラ', '마닐라', 'Manila', 'Manila', 'Manila', 'มะนิลา', 'Manila', 'Manila', 'मनीला'] }, // Central Terminal
    { id: 'makati', country: 'ph', lat: 14.5683, lng: 121.0244, names: ['馬卡蒂', '马卡蒂', 'Makati', 'マカティ', '마카티', 'Makati', 'Makati', 'Makati', 'มากาตี', 'Makati', 'Makati', 'मकाती'] }, // Makati City Hall
    { id: 'baguio', country: 'ph', lat: 16.4155, lng: 120.5969, km: 25, names: ['碧瑤', '碧瑶', 'Baguio', 'バギオ', '바기오', 'Baguio', 'Baguio', 'Baguio', 'บาเกียว', 'Baguio', 'Baguio', 'बागुइओ'] }, // Baguio City Hall
    { id: 'iloilo', country: 'ph', lat: 10.6962, lng: 122.5644, km: 30, names: ['怡朗', '伊洛伊洛', 'Iloilo', 'イロイロ', '일로일로', 'Iloilo', 'Iloilo', 'Iloilo', 'อีโลอีโล', 'Iloilo', 'Iloilo', 'इलोइलो'] }, // Iloilo City Hall
    { id: 'cebu', country: 'ph', lat: 10.2929, lng: 123.9019, names: ['宿霧', '宿务', 'Cebu', 'セブ', '세부', 'Cebu', 'Cebu', 'Cebu', 'เซบู', 'Cebu', 'Cebu', 'सेबू'] }, // Cebu City Hall
    { id: 'davao', country: 'ph', lat: 7.0644, lng: 125.6078, names: ['達沃', '达沃', 'Davao', 'ダバオ', '다바오', 'Davao', 'Davao', 'Davao', 'ดาเวา', 'Davao', 'Davao', 'दावाओ'] }, // Davao City Hall

    // ---- 澳洲 ----
    { id: 'sydney', country: 'au', lat: -33.8832, lng: 151.2063, names: ['雪梨', '悉尼', 'Sydney', 'シドニー', '시드니', 'Sydney', 'Sydney', 'Sydney', 'ซิดนีย์', 'Sydney', 'Sídney', 'सिडनी'] }, // Central Station
    { id: 'melbourne', country: 'au', lat: -37.8183, lng: 144.9671, names: ['墨爾本', '墨尔本', 'Melbourne', 'メルボルン', '멜버른', 'Melbourne', 'Melbourne', 'Melbourne', 'เมลเบิร์น', 'Melbourne', 'Melbourne', 'मेलबर्न'] }, // Flinders Street Station
    { id: 'brisbane', country: 'au', lat: -27.466, lng: 153.0195, km: 35, names: ['布里斯本', '布里斯班', 'Brisbane', 'ブリスベン', '브리즈번', 'Brisbane', 'Brisbane', 'Brisbane', 'บริสเบน', 'Brisbane', 'Brisbane', 'ब्रिस्बेन'] }, // Roma Street Station
    { id: 'goldcoast', country: 'au', lat: -28.0023, lng: 153.4145, km: 30, names: ['黃金海岸', '黄金海岸', 'Gold Coast', 'ゴールドコースト', '골드코스트', 'Gold Coast', 'Gold Coast', 'Gold Coast', 'โกลด์โคสต์', 'Gold Coast', 'Gold Coast', 'गोल्ड कोस्ट'] }, // Surfers Paradise
    { id: 'canberra', country: 'au', lat: -35.2809, lng: 149.13, km: 30, names: ['坎培拉', '堪培拉', 'Canberra', 'キャンベラ', '캔버라', 'Canberra', 'Canberra', 'Canberra', 'แคนเบอร์รา', 'Canberra', 'Canberra', 'कैनबरा'] }, // Civic
    { id: 'adelaide', country: 'au', lat: -34.921, lng: 138.596, names: ['阿德雷德', '阿德莱德', 'Adelaide', 'アデレード', '애들레이드', 'Adelaide', 'Adelaide', 'Adelaide', 'แอดิเลด', 'Adelaide', 'Adelaide', 'एडिलेड'] }, // Adelaide Railway Station
    { id: 'perth', country: 'au', lat: -31.9512, lng: 115.8604, names: ['伯斯', '珀斯', 'Perth', 'パース', '퍼스', 'Perth', 'Perth', 'Perth', 'เพิร์ท', 'Perth', 'Perth', 'पर्थ'] }, // Perth Station
    // ---- 紐西蘭、印度、巴西、阿根廷、南非（2026-11-08 加入）----
    { id: 'auckland', country: 'nz', lat: -36.8443, lng: 174.7676, names: ['奧克蘭', '奥克兰', 'Auckland', 'オークランド', '오클랜드', 'Auckland', 'Auckland', 'Auckland', 'โอ๊คแลนด์', 'Auckland', 'Auckland', 'ऑकलैंड'] }, // Britomart Transport Centre
    { id: 'wellington', country: 'nz', lat: -41.2789, lng: 174.7806, km: 30, names: ['威靈頓', '惠灵顿', 'Wellington', 'ウェリントン', '웰링턴', 'Wellington', 'Wellington', 'Wellington', 'เวลลิงตัน', 'Wellington', 'Wellington', 'वेलिंगटन'] }, // Wellington Railway Station
    { id: 'christchurch', country: 'nz', lat: -43.5321, lng: 172.6311, km: 30, names: ['基督城', '基督城', 'Christchurch', 'クライストチャーチ', '크라이스트처치', 'Christchurch', 'Christchurch', 'Christchurch', 'ไครสต์เชิร์ช', 'Christchurch', 'Christchurch', 'क्राइस्टचर्च'] }, // Civic Offices（市政府）
    { id: 'hamilton', country: 'nz', lat: -37.787, lng: 175.2793, km: 25, names: ['漢米爾頓', '汉密尔顿', 'Hamilton', 'ハミルトン', '해밀턴', 'Hamilton', 'Hamilton', 'Hamilton', 'แฮมิลตัน', 'Hamilton', 'Hamilton', 'हैमिल्टन'] }, // Hamilton Transport Centre
    { id: 'tauranga', country: 'nz', lat: -37.6863, lng: 176.1667, km: 25, names: ['陶朗加', '陶朗加', 'Tauranga', 'タウランガ', '타우랑가', 'Tauranga', 'Tauranga', 'Tauranga', 'เทารังกา', 'Tauranga', 'Tauranga', 'टौरंगा'] }, // 市中心
    { id: 'dunedin', country: 'nz', lat: -45.8753, lng: 170.5065, km: 25, names: ['但尼丁', '达尼丁', 'Dunedin', 'ダニーデン', '더니든', 'Dunedin', 'Dunedin', 'Dunedin', 'ดะนีดิน', 'Dunedin', 'Dunedin', 'ड्यूनेडिन'] }, // Dunedin Railway Station
    { id: 'queenstown', country: 'nz', lat: -45.0312, lng: 168.6626, km: 20, names: ['皇后鎮', '皇后镇', 'Queenstown', 'クイーンズタウン', '퀸스타운', 'Queenstown', 'Queenstown', 'Queenstown', 'ควีนส์ทาวน์', 'Queenstown', 'Queenstown', 'क्वीन्सटाउन'] }, // 市中心
    { id: 'delhi', country: 'in', lat: 28.643, lng: 77.2194, names: ['德里', '德里', 'Delhi', 'デリー', '델리', 'Delhi', 'Delhi', 'Delhi', 'เดลี', 'Déli', 'Delhi', 'दिल्ली'] }, // New Delhi Railway Station
    { id: 'mumbai', country: 'in', lat: 18.9398, lng: 72.8355, names: ['孟買', '孟买', 'Mumbai', 'ムンバイ', '뭄바이', 'Mumbai', 'Mumbai', 'Mumbai', 'มุมไบ', 'Mumbai', 'Bombay', 'मुंबई'] }, // Chhatrapati Shivaji Maharaj Terminus
    { id: 'bengaluru', country: 'in', lat: 12.9781, lng: 77.5697, names: ['班加羅爾', '班加罗尔', 'Bengaluru', 'ベンガルール', '벵갈루루', 'Bengaluru', 'Bengaluru', 'Bengaluru', 'เบงกาลูรู', 'Bangalore', 'Bangalore', 'बेंगलुरु'] }, // KSR Bengaluru City Junction
    { id: 'chennai', country: 'in', lat: 13.0827, lng: 80.2757, names: ['清奈', '金奈', 'Chennai', 'チェンナイ', '첸나이', 'Chennai', 'Chennai', 'Chennai', 'เจนไน', 'Chennai', 'Chennai', 'चेन्नई'] }, // Chennai Central
    { id: 'kolkata', country: 'in', lat: 22.5839, lng: 88.3425, names: ['加爾各答', '加尔各答', 'Kolkata', 'コルカタ', '콜카타', 'Kolkata', 'Kolkata', 'Kolkata', 'โกลกาตา', 'Calcutá', 'Calcuta', 'कोलकाता'] }, // Howrah Station
    { id: 'hyderabad', country: 'in', lat: 17.392, lng: 78.4676, names: ['海德拉巴', '海得拉巴', 'Hyderabad', 'ハイデラバード', '하이데라바드', 'Hyderabad', 'Hyderabad', 'Hyderabad', 'ไฮเดอราบาด', 'Hyderabad', 'Hyderabad', 'हैदराबाद'] }, // Hyderabad Deccan（Nampally）
    { id: 'pune', country: 'in', lat: 18.5285, lng: 73.8743, km: 30, names: ['浦那', '浦那', 'Pune', 'プネー', '푸네', 'Pune', 'Pune', 'Pune', 'ปูเน', 'Pune', 'Pune', 'पुणे'] }, // Pune Junction
    { id: 'ahmedabad', country: 'in', lat: 23.0258, lng: 72.6014, km: 30, names: ['亞美達巴德', '艾哈迈达巴德', 'Ahmedabad', 'アーメダバード', '아마다바드', 'Ahmedabad', 'Ahmedabad', 'Ahmedabad', 'อาห์มดาบาด', 'Ahmedabad', 'Ahmedabad', 'अहमदाबाद'] }, // Ahmedabad Junction（Kalupur）
    { id: 'jaipur', country: 'in', lat: 26.9196, lng: 75.788, km: 25, names: ['齋浦爾', '斋浦尔', 'Jaipur', 'ジャイプール', '자이푸르', 'Jaipur', 'Jaipur', 'Jaipur', 'ชัยปุระ', 'Jaipur', 'Jaipur', 'जयपुर'] }, // Jaipur Junction
    { id: 'goa', country: 'in', lat: 15.4989, lng: 73.8278, km: 30, names: ['果阿', '果阿', 'Goa', 'ゴア', '고아', 'Goa', 'Goa', 'Goa', 'กัว', 'Goa', 'Goa', 'गोवा'] }, // Panaji 市政府
    { id: 'saopaulo', country: 'br', lat: -23.5347, lng: -46.6353, names: ['聖保羅', '圣保罗', 'São Paulo', 'サンパウロ', '상파울루', 'São Paulo', 'São Paulo', 'São Paulo', 'เซาเปาลู', 'São Paulo', 'São Paulo', 'साओ पाउलो'] }, // Estação da Luz
    { id: 'rio', country: 'br', lat: -22.9037, lng: -43.1909, names: ['里約熱內盧', '里约热内卢', 'Rio de Janeiro', 'リオデジャネイロ', '리우데자네이루', 'Rio de Janeiro', 'Rio de Janeiro', 'Rio de Janeiro', 'รีโอเดจาเนโร', 'Rio de Janeiro', 'Río de Janeiro', 'रियो डी जेनेरो'] }, // Central do Brasil
    { id: 'brasilia', country: 'br', lat: -15.7939, lng: -47.8828, km: 30, names: ['巴西利亞', '巴西利亚', 'Brasília', 'ブラジリア', '브라질리아', 'Brasília', 'Brasília', 'Brasília', 'บราซีเลีย', 'Brasília', 'Brasilia', 'ब्रासीलिया'] }, // Rodoviária do Plano Piloto
    { id: 'salvador', country: 'br', lat: -12.9737, lng: -38.5129, km: 30, names: ['薩爾瓦多', '萨尔瓦多', 'Salvador', 'サルヴァドール', '사우바도르', 'Salvador', 'Salvador', 'Salvador', 'ซัลวาดอร์', 'Salvador', 'Salvador', 'साल्वाडोर'] }, // Praça Municipal（市政府）
    { id: 'belohorizonte', country: 'br', lat: -19.9165, lng: -43.9346, km: 30, names: ['貝洛奧里藏特', '贝洛奥里藏特', 'Belo Horizonte', 'ベロオリゾンテ', '벨루오리존치', 'Belo Horizonte', 'Belo Horizonte', 'Belo Horizonte', 'เบโลโอรีซอนตี', 'Belo Horizonte', 'Belo Horizonte', 'बेलो होरिज़ोंटे'] }, // Estação Central
    { id: 'fortaleza', country: 'br', lat: -3.7253, lng: -38.5289, km: 30, names: ['福塔雷薩', '福塔雷萨', 'Fortaleza', 'フォルタレザ', '포르탈레자', 'Fortaleza', 'Fortaleza', 'Fortaleza', 'ฟอร์ตาเลซา', 'Fortaleza', 'Fortaleza', 'फ़ोर्टालेज़ा'] }, // Estação João Felipe
    { id: 'curitiba', country: 'br', lat: -25.4372, lng: -49.2569, km: 25, names: ['庫里提巴', '库里蒂巴', 'Curitiba', 'クリチバ', '쿠리치바', 'Curitiba', 'Curitiba', 'Curitiba', 'กูรีชีบา', 'Curitiba', 'Curitiba', 'कूरितिबा'] }, // Rodoferroviária
    { id: 'recife', country: 'br', lat: -8.0679, lng: -34.8902, km: 25, names: ['累西腓', '累西腓', 'Recife', 'レシフェ', '헤시피', 'Recife', 'Recife', 'Recife', 'เรซีฟี', 'Recife', 'Recife', 'रेसिफ़े'] }, // Estação Central do Recife
    { id: 'portoalegre', country: 'br', lat: -30.0277, lng: -51.2287, km: 25, names: ['阿雷格里港', '阿雷格里港', 'Porto Alegre', 'ポルトアレグレ', '포르투알레그리', 'Porto Alegre', 'Porto Alegre', 'Porto Alegre', 'โปร์ตูอาเลกรี', 'Porto Alegre', 'Porto Alegre', 'पोर्टो एलेग्रे'] }, // Paço Municipal（市政府）
    { id: 'manaus', country: 'br', lat: -3.1316, lng: -60.0234, km: 25, names: ['瑪瑙斯', '马瑙斯', 'Manaus', 'マナウス', '마나우스', 'Manaus', 'Manaus', 'Manaus', 'มาเนาส์', 'Manaus', 'Manaos', 'मनौस'] }, // 市中心
    { id: 'buenosaires', country: 'ar', lat: -34.6085, lng: -58.372, names: ['布宜諾斯艾利斯', '布宜诺斯艾利斯', 'Buenos Aires', 'ブエノスアイレス', '부에노스아이레스', 'Buenos Aires', 'Buenos Aires', 'Buenos Aires', 'บัวโนสไอเรส', 'Buenos Aires', 'Buenos Aires', 'ब्यूनस आयर्स'] }, // Palacio Municipal（市政府）
    { id: 'cordoba', country: 'ar', lat: -31.4167, lng: -64.1835, km: 30, names: ['哥多華', '科尔多瓦', 'Córdoba', 'コルドバ', '코르도바', 'Córdoba', 'Córdoba', 'Córdoba', 'กอร์โดบา', 'Córdoba', 'Córdoba', 'कोर्डोबा'] }, // 市中心
    { id: 'rosario', country: 'ar', lat: -32.9477, lng: -60.6309, km: 25, names: ['羅薩里奧', '罗萨里奥', 'Rosario', 'ロサリオ', '로사리오', 'Rosario', 'Rosario', 'Rosario', 'โรซาริโอ', 'Rosário', 'Rosario', 'रोसारियो'] }, // Palacio de los Leones（市政府）
    { id: 'mendoza', country: 'ar', lat: -32.8895, lng: -68.8458, km: 25, names: ['門多薩', '门多萨', 'Mendoza', 'メンドーサ', '멘도사', 'Mendoza', 'Mendoza', 'Mendoza', 'เมนโดซา', 'Mendoza', 'Mendoza', 'मेंडोज़ा'] }, // 市中心
    { id: 'laplata', country: 'ar', lat: -34.9205, lng: -57.9536, km: 20, names: ['拉普拉塔', '拉普拉塔', 'La Plata', 'ラ・プラタ', '라플라타', 'La Plata', 'La Plata', 'La Plata', 'ลาปลาตา', 'La Plata', 'La Plata', 'ला प्लाटा'] }, // Palacio Municipal（市政府）
    { id: 'mardelplata', country: 'ar', lat: -38.0055, lng: -57.5426, km: 25, names: ['馬德普拉塔', '马德普拉塔', 'Mar del Plata', 'マル・デル・プラタ', '마르델플라타', 'Mar del Plata', 'Mar del Plata', 'Mar del Plata', 'มาร์เดลปลาตา', 'Mar del Plata', 'Mar del Plata', 'मार डेल प्लाटा'] }, // 市中心
    { id: 'tucuman', country: 'ar', lat: -26.8241, lng: -65.2226, km: 25, names: ['土庫曼', '图库曼', 'San Miguel de Tucumán', 'トゥクマン', '투쿠만', 'Tucumán', 'Tucumán', 'Tucumán', 'ตูกูมัน', 'Tucumán', 'San Miguel de Tucumán', 'टुकुमान'] }, // 市中心
    { id: 'salta', country: 'ar', lat: -24.7883, lng: -65.4106, km: 20, names: ['薩爾塔', '萨尔塔', 'Salta', 'サルタ', '살타', 'Salta', 'Salta', 'Salta', 'ซัลตา', 'Salta', 'Salta', 'साल्टा'] }, // 市中心
    { id: 'bariloche', country: 'ar', lat: -41.1335, lng: -71.3103, km: 25, names: ['巴里洛切', '巴里洛切', 'Bariloche', 'バリローチェ', '바릴로체', 'Bariloche', 'Bariloche', 'Bariloche', 'บาริโลเช', 'Bariloche', 'Bariloche', 'बारिलोचे'] }, // Centro Cívico
    { id: 'johannesburg', country: 'za', lat: -26.1959, lng: 28.0423, names: ['約翰尼斯堡', '约翰内斯堡', 'Johannesburg', 'ヨハネスブルグ', '요하네스버그', 'Johannesburg', 'Johannesburg', 'Johannesburg', 'โจฮันเนสเบิร์ก', 'Joanesburgo', 'Johannesburgo', 'जोहान्सबर्ग'] }, // Park Station
    { id: 'pretoria', country: 'za', lat: -25.759, lng: 28.1897, km: 30, names: ['普利托利亞', '比勒陀利亚', 'Pretoria', 'プレトリア', '프리토리아', 'Pretoria', 'Pretoria', 'Pretoria', 'พริทอเรีย', 'Pretória', 'Pretoria', 'प्रिटोरिया'] }, // Pretoria Station
    { id: 'capetown', country: 'za', lat: -33.9221, lng: 18.4231, names: ['開普敦', '开普敦', 'Cape Town', 'ケープタウン', '케이프타운', 'Cape Town', 'Cape Town', 'Cape Town', 'เคปทาวน์', 'Cidade do Cabo', 'Ciudad del Cabo', 'केप टाउन'] }, // Cape Town Station
    { id: 'durban', country: 'za', lat: -29.851, lng: 31.027, km: 30, names: ['德班', '德班', 'Durban', 'ダーバン', '더반', 'Durban', 'Durban', 'Durban', 'เดอร์บัน', 'Durban', 'Durban', 'डरबन'] }, // Durban Station
    { id: 'gqeberha', country: 'za', lat: -33.9608, lng: 25.6022, km: 25, names: ['格克貝拉', '格贝哈', 'Gqeberha', 'グケベラ', '그케베하', 'Gqeberha', 'Gqeberha', 'Gqeberha', 'เกเบอร์ฮา', 'Gqeberha', 'Gqeberha', 'गकेबरहा'] }, // 市中心（舊稱伊莉莎白港）
    { id: 'bloemfontein', country: 'za', lat: -29.121, lng: 26.214, km: 20, names: ['布隆泉', '布隆方丹', 'Bloemfontein', 'ブルームフォンテーン', '블룸폰테인', 'Bloemfontein', 'Bloemfontein', 'Bloemfontein', 'บลูมฟอนเทน', 'Bloemfontein', 'Bloemfontein', 'ब्लोमफ़ोन्टेन'] }, // 市中心
];
const CITY_BY_ID = Object.fromEntries(CITIES.map((c) => [c.id, c]));

// 時區：每國一個，印尼與澳洲依城市分（給「時差與天色」用：只用城市的時區，不需要對方的位置）
const COUNTRY_TZ = {
    tw: 'Asia/Taipei', jp: 'Asia/Tokyo', kr: 'Asia/Seoul', hk: 'Asia/Hong_Kong', mo: 'Asia/Macau', sg: 'Asia/Singapore',
    my: 'Asia/Kuala_Lumpur', id: 'Asia/Jakarta', vn: 'Asia/Ho_Chi_Minh', th: 'Asia/Bangkok', ph: 'Asia/Manila', au: 'Australia/Sydney',
    nz: 'Pacific/Auckland', in: 'Asia/Kolkata', br: 'America/Sao_Paulo', ar: 'America/Argentina/Buenos_Aires', za: 'Africa/Johannesburg',
};
const CITY_TZ = {
    bali: 'Asia/Makassar', makassar: 'Asia/Makassar',
    manaus: 'America/Manaus',
    brisbane: 'Australia/Brisbane', goldcoast: 'Australia/Brisbane', adelaide: 'Australia/Adelaide', perth: 'Australia/Perth',
};
const tzOf = (city) => CITY_TZ[city.id] || COUNTRY_TZ[city.country];

/** 這座城市此刻和 UTC 差幾分鐘（含夏令時間） */
function utcOffsetMinutes(cityId, now = Date.now()) {
    const city = CITY_BY_ID[cityId];
    if (!city) return null;
    const parts = Object.fromEntries(new Intl.DateTimeFormat('en-US', {
        timeZone: tzOf(city), hourCycle: 'h23', year: 'numeric', month: 'numeric', day: 'numeric', hour: 'numeric', minute: 'numeric',
    }).formatToParts(new Date(now)).map((x) => [x.type, x.value]));
    const local = Date.UTC(+parts.year, +parts.month - 1, +parts.day, +parts.hour, +parts.minute);
    return Math.round((local - Math.floor(now / 60000) * 60000) / 60000);
}
const LANGS = ['zh-Hant', 'zh-Hans', 'en', 'ja', 'ko', 'ms', 'id', 'vi', 'th', 'pt', 'es', 'hi'];

/** 城市名稱（使用者的語言；較早加入的城市沒有葡、西、印地文名稱時用英文；不認得的語言用繁中） */
function nameOf(id, lang) {
    const city = CITY_BY_ID[id];
    if (!city) return id;
    const i = LANGS.indexOf(lang);
    if (i < 0) return city.names[0];
    return city.names[i] || city.names[2];
}

/** 兩座城市是否互疊：目前固定是台灣 ↔ 其他國家 */
function paired(a, b) {
    return (a.country === TAIWAN) !== (b.country === TAIWAN);
}

// 香港、澳門北邊就是中國大陸：深圳（深圳河以北）、珠海（關閘以北）、橫琴。
// 用保守的方框排除，寧可少收邊界上的香港人，也不收到大陸的人。
function isMainlandBorderArea(lat, lng) {
    if (lng > 113.75 && lng < 114.65 && lat > 22.505) return true; // 深圳
    if (lng > 113.45 && lng < 113.70 && lat > 22.214) return true; // 珠海
    if (lng > 113.45 && lng < 113.556 && lat > 22.08 && lat < 22.17) return true; // 橫琴
    return false;
}

// 以城市中心為原點的平面公里座標（東、北）；城市範圍內誤差可忽略
function toLocalKm(city, lat, lng) {
    const east = (lng - city.lng) * METERS_PER_DEG_LAT * Math.cos(city.lat * Math.PI / 180) / 1000;
    const north = (lat - city.lat) * METERS_PER_DEG_LAT / 1000;
    return { east, north };
}

function fromLocalKm(city, east, north) {
    return {
        lat: city.lat + north * 1000 / METERS_PER_DEG_LAT,
        lng: city.lng + east * 1000 / (METERS_PER_DEG_LAT * Math.cos(city.lat * Math.PI / 180)),
    };
}

function distanceKm(a, b) {
    const dLat = (b.lat - a.lat) * METERS_PER_DEG_LAT;
    const dLng = (b.lng - a.lng) * METERS_PER_DEG_LAT * Math.cos(((a.lat + b.lat) / 2) * Math.PI / 180);
    return Math.hypot(dLat, dLng) / 1000;
}

function contains(city, lat, lng) {
    if (city.box) {
        const [south, north, west, east] = city.box;
        return lat >= south && lat <= north && lng >= west && lng <= east;
    }
    if (city.circles) return city.circles.some(([clat, clng, km]) => distanceKm({ lat: clat, lng: clng }, { lat, lng }) <= km);
    return distanceKm(city, { lat, lng }) <= (city.km ?? DEFAULT_KM);
}

/** 這個位置屬於哪座城市（範圍內、離中心車站最近的那座）；都不是就回傳 null */
function cityOf(lat, lng) {
    if (isMainlandBorderArea(lat, lng)) return null;
    let best = null, bestKm = Infinity;
    for (const city of CITIES) {
        if (!contains(city, lat, lng)) continue;
        const d = distanceKm(city, { lat, lng });
        if (d < bestKm) { best = city; bestKm = d; }
    }
    return best;
}

// 依 uid + 日期產生 [-1, 1) 的固定值：同一天同一人永遠相同，無法靠多次查詢平均掉
function stableUnit(uid, day, axis) {
    const h = crypto.createHash('sha256').update(`parallel|${uid}|${day}|${axis}`).digest();
    return (h.readUInt32BE(0) / 0x100000000) * 2 - 1;
}

/** 在原本的城市裡模糊化：吸附到 500 公尺網格中心，再加每人每天固定的偏移；回傳離中心車站的公里數 */
function fuzzInCity(city, lat, lng, uid, now) {
    const { east, north } = toLocalKm(city, lat, lng);
    const cell = CELL_METERS / 1000;
    const day = new Date(now).toISOString().slice(0, 10);
    return {
        east: (Math.floor(east / cell) + 0.5 + stableUnit(uid, day, 'e') * JITTER_FRACTION) * cell,
        north: (Math.floor(north / cell) + 0.5 + stableUnit(uid, day, 'n') * JITTER_FRACTION) * cell,
    };
}

/**
 * 把 from 城市裡的一個人疊到 to 城市：離中心車站的方向與公里數不變。
 * @returns {{lat:number, lng:number}} 對外顯示的位置（已模糊化）
 */
function project(from, to, lat, lng, uid, now) {
    const { east, north } = fuzzInCity(from, lat, lng, uid, now);
    return fromLocalKm(to, east, north);
}

/** 觀看者的雷達圈，對回 target 城市是哪一塊：只要搜尋這一塊就夠了（搜到後仍逐一投影、精確過濾） */
function searchArea(viewerCity, target, lat, lng, radiusKm) {
    const here = toLocalKm(viewerCity, lat, lng);
    return { ...fromLocalKm(target, here.east, here.north), radiusKm: radiusKm + FUZZ_MARGIN_KM };
}

// 所有城市的外接圓（大圓距離）：一次取回全部開啟平行宇宙的人
const EARTH_KM = 6371;
function greatCircleKm(a, b) {
    const r = Math.PI / 180;
    const h = Math.sin((b.lat - a.lat) * r / 2) ** 2 + Math.cos(a.lat * r) * Math.cos(b.lat * r) * Math.sin((b.lng - a.lng) * r / 2) ** 2;
    return 2 * EARTH_KM * Math.asin(Math.sqrt(h));
}
const COVER = (() => {
    const center = { lat: CITIES.reduce((t, c) => t + c.lat, 0) / CITIES.length, lng: CITIES.reduce((t, c) => t + c.lng, 0) / CITIES.length };
    const km = Math.max(...CITIES.map((c) => greatCircleKm(center, c))) + DEFAULT_KM + 50;
    return { ...center, km: Math.ceil(km) };
})();
const SNAPSHOT_LIMIT = 2000;

/** 取回所有開啟平行宇宙的人（沒開的人用；開啟的人通常不多，伺服器會短暫快取） */
function snapshotCommand() {
    return ['GEOSEARCH', GEO_KEY, 'FROMLONLAT', String(COVER.lng), String(COVER.lat), 'BYRADIUS', String(COVER.km), 'km', 'COUNT', String(SNAPSHOT_LIMIT), 'WITHCOORD'];
}

/**
 * 搜尋對方城市要用的指令（一城一個 GEOSEARCH，放進同一個 pipeline）。
 * key：開啟的人搜 city_users（所有人），沒開的人搜 parallel_users（只有開啟的人）。
 */
function searchCommands(viewerCity, lat, lng, radiusKm, key, live) {
    const others = CITIES.filter((c) => paired(viewerCity, c) && (!live || live.has(c.id)));
    return {
        others,
        commands: others.map((c) => {
            const area = searchArea(viewerCity, c, lat, lng, radiusKm);
            return ['GEOSEARCH', key, 'FROMLONLAT', String(area.lng), String(area.lat),
                'BYRADIUS', String(area.radiusKm), 'km', 'ASC', 'COUNT', String(PER_CITY_RESULTS), 'WITHCOORD'];
        }),
    };
}

/**
 * 平行座標：你現在的位置，對到每一座配對城市的哪一點（給你自己看）。
 * 用和別人看到你時同一套模糊化（500 公尺網格＋每天固定偏移），所以不會比平行宇宙本來透露的更多。
 * @returns {{home:{id:string,name:string}, east:number, north:number, list:{id:string,name:string,country:string,lat:number,lng:number}[]}|null}
 */
function mirrors(lat, lng, uid, now, lang) {
    const home = cityOf(lat, lng);
    if (!home) return null;
    const { east, north } = fuzzInCity(home, lat, lng, uid, now);
    const round = (x) => Math.round(x * 1e5) / 1e5;
    return {
        home: { id: home.id, name: nameOf(home.id, lang) },
        east: Math.round(east * 10) / 10,
        north: Math.round(north * 10) / 10,
        list: CITIES.filter((c) => paired(home, c)).map((c) => {
            const at = fromLocalKm(c, east, north);
            const base = { id: c.id, name: nameOf(c.id, lang), country: c.country };
            // 落在這座城市的範圍外（或中國大陸的邊界區）就不給座標，App 只顯示「範圍之外」
            if (!contains(c, at.lat, at.lng) || isMainlandBorderArea(at.lat, at.lng)) return { ...base, outside: true };
            return { ...base, lat: round(at.lat), lng: round(at.lng) };
        }),
    };
}

// 城市範圍的外接半徑（公里）：用來快速檢查這座城市現在有沒有人
function reachKm(city) {
    if (city.box) {
        const [south, north, west, east] = city.box;
        return Math.max(...[[south, west], [south, east], [north, west], [north, east]].map(([lat, lng]) => distanceKm(city, { lat, lng })));
    }
    if (city.circles) return Math.max(...city.circles.map(([lat, lng, km]) => distanceKm(city, { lat, lng }) + km));
    return city.km ?? DEFAULT_KM;
}

/**
 * 每座城市一個「有沒有人」的檢查（COUNT 1），回傳 [指令, 城市 id]。
 * 伺服器每分鐘跑一次，雷達只搜有人的城市，城市再多也不會讓每次搜尋的指令變多。
 * 範圍是外接圓，會多算鄰近城市的人（只會多搜，不會漏）。
 */
function liveCheckCommands() {
    return CITIES.map((c) => ['GEOSEARCH', ALL_KEY, 'FROMLONLAT', String(c.lng), String(c.lat), 'BYRADIUS', String(Math.ceil(reachKm(c))), 'km', 'COUNT', '1']);
}

/** liveCheckCommands 的結果 → 有人的城市 id */
function liveCities(results) {
    const live = new Set();
    CITIES.forEach((c, i) => { if (Array.isArray(results[i]) && results[i].length > 0) live.add(c.id); });
    return live;
}

module.exports = {
    utcOffsetMinutes, tzOf, mirrors, liveCheckCommands, liveCities, reachKm,
    GEO_KEY, ALL_KEY, CELL_METERS, MAX_RESULTS, CITIES, CITY_BY_ID, TAIWAN,
    LANGS, cityOf, nameOf, paired, isMainlandBorderArea, project, searchArea, distanceKm, searchCommands, snapshotCommand, toLocalKm, COVER,
};
