package com.softchip.moodwhisper

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 啟動 presence 監聽服務：App 被滑掉時由它送出「已離開」訊號
        try {
            startService(Intent(this, PresenceService::class.java))
        } catch (e: IllegalStateException) {
            // 系統不允許在背景啟動服務時忽略，退回由伺服器 1 小時的保底機制處理
        }
    }
}
