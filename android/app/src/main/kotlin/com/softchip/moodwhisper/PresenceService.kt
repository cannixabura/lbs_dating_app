package com.softchip.moodwhisper

import android.app.Service
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ServerValue

/**
 * 只負責一件事：使用者從「最近使用」滑掉 App 時，把 presence 標記為 exited，
 * 讓別人的雷達立刻把這個人變成歷史殘影。
 * Flutter 端在這個時間點已無法執行，所以必須由原生端寫入。
 */
class PresenceService : Service() {

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int = START_NOT_STICKY

    override fun onTaskRemoved(rootIntent: Intent?) {
        val uid = FirebaseAuth.getInstance().currentUser?.uid
        if (uid == null) {
            stopSelf()
            return
        }
        val handler = Handler(Looper.getMainLooper())
        val stop = Runnable { stopSelf() }
        // 最多等 3 秒讓寫入送出，之後無論成功與否都結束，讓系統回收行程
        handler.postDelayed(stop, 3000)
        FirebaseDatabase.getInstance()
            .getReference("presence/$uid")
            .setValue(mapOf("state" to "exited", "at" to ServerValue.TIMESTAMP))
            .addOnCompleteListener {
                handler.removeCallbacks(stop)
                stopSelf()
            }
    }
}
