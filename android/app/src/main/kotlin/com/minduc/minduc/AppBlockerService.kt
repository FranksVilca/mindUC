package com.minduc.minduc

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.Settings
import android.util.Log
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView

class AppBlockerService : Service() {

    companion object {
        const val ACTION_START = "com.minduc.minduc.action.START_BLOCKER"
        const val ACTION_STOP = "com.minduc.minduc.action.STOP_BLOCKER"
        const val ACTION_UPDATE_PACKAGES = "com.minduc.minduc.action.UPDATE_PACKAGES"
        private const val CHANNEL_ID = "minduc_focus_mode_channel"
        private const val NOTIFICATION_ID = 90210
        private const val TAG = "MindUCBlockerService"
    }

    private val blockedPackages = mutableSetOf<String>()
    private val normalizedBlockedPackages = mutableSetOf<String>()
    private val handler = Handler(Looper.getMainLooper())
    private var isMonitoring = false
    private var windowManager: WindowManager? = null
    private var usageStatsManager: UsageStatsManager? = null
    private var overlayView: View? = null
    private var isOverlayShown = false
    private var blockedAppNameView: TextView? = null

    private val monitorRunnable = object : Runnable {
        override fun run() {
            if (!isMonitoring) return
            checkCurrentApp()
            handler.postDelayed(this, 600)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(Context.WINDOW_SERVICE) as? WindowManager
        usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
        createNotificationChannel()
    }

    private fun updateBlockedPackages(packages: List<String>) {
        blockedPackages.clear()
        blockedPackages.addAll(packages)
        normalizedBlockedPackages.clear()
        for (pkg in packages) {
            normalizedBlockedPackages.add(pkg.lowercase())
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action ?: ACTION_START
        when (action) {
            ACTION_START -> {
                val packages = intent?.getStringArrayListExtra("packages")
                if (packages != null) {
                    updateBlockedPackages(packages)
                }
                startForeground(NOTIFICATION_ID, buildForegroundNotification())
                startMonitoring()
            }
            ACTION_UPDATE_PACKAGES -> {
                val packages = intent?.getStringArrayListExtra("packages")
                if (packages != null) {
                    updateBlockedPackages(packages)
                }
            }
            ACTION_STOP -> {
                stopMonitoring()
                hideOverlay()
                stopForeground(true)
                stopSelf()
            }
        }
        return START_STICKY
    }

    override fun onDestroy() {
        stopMonitoring()
        hideOverlay()
        super.onDestroy()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "mindUC Enfoque Profundo",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Notificación persistente para proteger tus sesiones de concentración"
                setShowBadge(false)
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }

    private fun buildForegroundNotification(): Notification {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            this.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            launchIntent ?: Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }

        return builder
            .setContentTitle("Modo Enfoque Profundo activo 🌿")
            .setContentText("mindUC está protegiendo tu concentración")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .build()
    }

    private fun startMonitoring() {
        if (isMonitoring) return
        isMonitoring = true
        handler.removeCallbacks(monitorRunnable)
        handler.post(monitorRunnable)
        Log.i(TAG, "Monitoreo iniciado con ${blockedPackages.size} paquetes configurados.")
    }

    private fun stopMonitoring() {
        isMonitoring = false
        handler.removeCallbacks(monitorRunnable)
        Log.i(TAG, "Monitoreo detenido.")
    }

    private fun isPackageBlocked(pkg: String): Boolean {
        if (pkg == packageName) return false
        val lowerPkg = pkg.lowercase()
        if (normalizedBlockedPackages.contains(lowerPkg) || blockedPackages.contains(pkg)) return true

        for (lowerItem in normalizedBlockedPackages) {
            if (lowerItem == lowerPkg) return true
            if (lowerItem.contains("instagram") && lowerPkg.contains("instagram")) return true
            if (lowerItem.contains("tiktok") && (lowerPkg.contains("tiktok") || lowerPkg.contains("musically"))) return true
            if (lowerItem.contains("whatsapp") && lowerPkg.contains("whatsapp")) return true
            if (lowerItem.contains("facebook") && (lowerPkg.contains("facebook") || lowerPkg.contains("katana"))) return true
            if (lowerItem.contains("youtube") && lowerPkg.contains("youtube")) return true
            if (lowerItem.contains("aliexpress") && lowerPkg.contains("aliexpress")) return true
            if (lowerItem.contains("temu") && lowerPkg.contains("temu")) return true
            if (lowerItem.contains("twitter") && (lowerPkg.contains("twitter") || lowerPkg.contains("x.android"))) return true
            if (lowerItem.contains("discord") && lowerPkg.contains("discord")) return true
            if (lowerItem.contains("telegram") && lowerPkg.contains("telegram")) return true
            if (lowerItem.contains("netflix") && lowerPkg.contains("netflix")) return true
            if (lowerItem.contains("spotify") && lowerPkg.contains("spotify")) return true
        }
        return false
    }

    private fun checkCurrentApp() {
        if (!isMonitoring || blockedPackages.isEmpty()) return
        try {
            val statsMgr = usageStatsManager ?: (getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager)?.also {
                usageStatsManager = it
            } ?: return
            val time = System.currentTimeMillis()
            val usageEvents = statsMgr.queryEvents(time - 3500, time)
            val event = UsageEvents.Event()
            var currentPkg: String? = null

            while (usageEvents.hasNextEvent()) {
                usageEvents.getNextEvent(event)
                if (event.eventType == UsageEvents.Event.ACTIVITY_RESUMED) {
                    currentPkg = event.packageName
                }
            }

            if (currentPkg == null) {
                val stats = statsMgr.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, time - 10000, time)
                if (!stats.isNullOrEmpty()) {
                    val topApp = stats.maxByOrNull { it.lastTimeUsed }
                    if (topApp != null && (time - topApp.lastTimeUsed) < 3000) {
                        currentPkg = topApp.packageName
                    }
                }
            }

            if (currentPkg != null && currentPkg != packageName) {
                if (isPackageBlocked(currentPkg)) {
                    showOverlay(currentPkg)
                } else if (isOverlayShown) {
                    hideOverlay()
                }
            } else if (currentPkg == packageName && isOverlayShown) {
                hideOverlay()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error consultando app en primer plano: ${e.message}")
        }
    }

    private fun showOverlay(pkgName: String) {
        if (isOverlayShown) {
            blockedAppNameView?.text = "Aplicación restringida: ${getFriendlyAppName(pkgName)}"
            return
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
            // Fallback si no tiene permiso de overlay: redirigir a Home
            sendUserToHome()
            return
        }

        try {
            if (overlayView == null) {
                overlayView = createOverlayView()
            }
            blockedAppNameView?.text = "Aplicación restringida: ${getFriendlyAppName(pkgName)}"

            val layoutType = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                @Suppress("DEPRECATION")
                WindowManager.LayoutParams.TYPE_PHONE
            }

            val params = WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT,
                layoutType,
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                        WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                        WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
                PixelFormat.TRANSLUCENT
            ).apply {
                gravity = Gravity.CENTER
            }

            windowManager?.addView(overlayView, params)
            isOverlayShown = true
            Log.i(TAG, "Overlay de bloqueo desplegado para paquete: $pkgName")
        } catch (e: Exception) {
            Log.e(TAG, "Fallo al mostrar overlay de bloqueo: ${e.message}")
            sendUserToHome()
        }
    }

    private fun hideOverlay() {
        if (!isOverlayShown || overlayView == null) return
        try {
            windowManager?.removeView(overlayView)
            isOverlayShown = false
            Log.i(TAG, "Overlay de bloqueo ocultado.")
        } catch (e: Exception) {
            Log.e(TAG, "Fallo al ocultar overlay de bloqueo: ${e.message}")
        }
    }

    private fun sendUserToHome() {
        try {
            val homeIntent = Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_HOME)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            startActivity(homeIntent)
        } catch (e: Exception) {
            Log.e(TAG, "Error enviando a Home: ${e.message}")
        }
    }

    private fun getFriendlyAppName(pkg: String): String {
        return try {
            val appInfo = packageManager.getApplicationInfo(pkg, 0)
            packageManager.getApplicationLabel(appInfo).toString()
        } catch (_: Exception) {
            val simple = pkg.substringAfterLast('.')
            simple.replaceFirstChar { it.uppercase() }
        }
    }

    private fun createOverlayView(): View {
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setBackgroundColor(Color.parseColor("#F5112117")) // Verde bosque profundo de mindUC semi-transparente
            isClickable = true
            isFocusable = true
            setPadding(dpToPx(24), dpToPx(32), dpToPx(24), dpToPx(32))
        }

        val card = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            val cardBg = GradientDrawable().apply {
                setColor(Color.parseColor("#FF193022"))
                cornerRadius = dpToPx(24).toFloat()
                setStroke(dpToPx(1), Color.parseColor("#FF2D533C"))
            }
            background = cardBg
            setPadding(dpToPx(24), dpToPx(28), dpToPx(24), dpToPx(28))
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        }

        // Ícono / Emblema
        val emblem = TextView(this).apply {
            text = "🌿"
            textSize = 42f
            gravity = Gravity.CENTER
        }
        card.addView(emblem)

        // Título
        val title = TextView(this).apply {
            text = "Modo Enfoque Profundo"
            textSize = 21f
            setTextColor(Color.WHITE)
            setTypeface(null, Typeface.BOLD)
            gravity = Gravity.CENTER
            setPadding(0, dpToPx(12), 0, dpToPx(6))
        }
        card.addView(title)

        // Subtítulo
        val subtitle = TextView(this).apply {
            text = "Esta aplicación está bloqueada temporalmente para proteger tu concentración y bienestar digital."
            textSize = 14f
            setTextColor(Color.parseColor("#FFC2D8C9"))
            gravity = Gravity.CENTER
            setPadding(0, 0, 0, dpToPx(12))
        }
        card.addView(subtitle)

        // Nombre de la app bloqueada
        blockedAppNameView = TextView(this).apply {
            text = "Aplicación restringida"
            textSize = 13f
            setTextColor(Color.parseColor("#FF8FC4A3"))
            setTypeface(null, Typeface.BOLD)
            gravity = Gravity.CENTER
            val badgeBg = GradientDrawable().apply {
                setColor(Color.parseColor("#222E533C"))
                cornerRadius = dpToPx(12).toFloat()
            }
            background = badgeBg
            setPadding(dpToPx(12), dpToPx(6), dpToPx(12), dpToPx(6))
        }
        card.addView(blockedAppNameView)

        // Espaciador
        val space = View(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                dpToPx(24)
            )
        }
        card.addView(space)

        // Botón principal: Abrir mindUC
        val btnMindUC = Button(this).apply {
            text = "Abrir mindUC 🌿"
            setTextColor(Color.WHITE)
            textSize = 15f
            setTypeface(null, Typeface.BOLD)
            val btnBg = GradientDrawable().apply {
                setColor(Color.parseColor("#FF438B65"))
                cornerRadius = dpToPx(14).toFloat()
            }
            background = btnBg
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                dpToPx(48)
            )
            setOnClickListener {
                hideOverlay()
                val launchIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                if (launchIntent != null) {
                    startActivity(launchIntent)
                }
            }
        }
        card.addView(btnMindUC)

        // Espaciador entre botones
        val spaceBtn = View(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                dpToPx(10)
            )
        }
        card.addView(spaceBtn)

        // Botón secundario: Volver al inicio
        val btnHome = Button(this).apply {
            text = "Volver al inicio"
            setTextColor(Color.parseColor("#FFE0EDE4"))
            textSize = 14f
            val btnHomeBg = GradientDrawable().apply {
                setColor(Color.parseColor("#FF22392B"))
                cornerRadius = dpToPx(14).toFloat()
                setStroke(dpToPx(1), Color.parseColor("#FF355742"))
            }
            background = btnHomeBg
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                dpToPx(44)
            )
            setOnClickListener {
                hideOverlay()
                sendUserToHome()
            }
        }
        card.addView(btnHome)

        root.addView(card)
        return root
    }

    private fun dpToPx(dp: Int): Int {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            dp.toFloat(),
            resources.displayMetrics
        ).toInt()
    }
}
