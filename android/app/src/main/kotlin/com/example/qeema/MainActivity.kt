package com.example.qeema

import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private var recentsPreviewHidden = true // Fail closed until Dart reports otherwise
    private var isBackgrounded = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        savedInstanceState?.let {
            recentsPreviewHidden = it.getBoolean("recentsPreviewHidden", true)
        }
        applyPolicyToWindow()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putBoolean("recentsPreviewHidden", recentsPreviewHidden)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "qeema/window_security",
        ).setMethodCallHandler { call, result ->
            if (call.method == "setRecentsPreviewHidden") {
                val hidden = call.argument<Boolean>("hidden")
                if (hidden == null) {
                    result.error("INVALID_ARGUMENT", "The 'hidden' argument must be a boolean.", null)
                } else {
                    recentsPreviewHidden = hidden
                    runOnUiThread {
                        applyPolicyToWindow()
                    }
                    result.success(null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onPause() {
        super.onPause()
        isBackgrounded = true
        applyPolicyToWindow()
    }

    override fun onResume() {
        super.onResume()
        isBackgrounded = false
        applyPolicyToWindow()
    }

    private fun applyPolicyToWindow() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            setRecentsScreenshotEnabled(!recentsPreviewHidden)
        } else {
            // Apply FLAG_SECURE only when backgrounding so active screenshots are allowed
            if (recentsPreviewHidden && isBackgrounded) {
                window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
            } else {
                window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            }
        }
    }
}
