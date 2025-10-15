package com.SpAiMobileToMobileTool.BoosterVpn


import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

/**
 * Custom Native Ad Medium Factory để tạo layout tùy chỉnh cho medium native ads
 * Layout: AD badge + Play button ở trên, Image lớn ở giữa, title + description ở dưới
 */
class CustomNativeAdMediumFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(nativeAd: NativeAd, customOptions: Map<String, Any>?): NativeAdView {
        val adView = NativeAdView(context)

        // Main container
        val mainContainer = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#172032"))
                cornerRadius = dpToPx(8).toFloat()
                setStroke(dpToPx(1), Color.argb(13, 255, 255, 255))
            }
            setPadding(dpToPx(12), dpToPx(12), dpToPx(12), dpToPx(12))
        }

        // Top container chỉ có Play button
        val topContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(0, 0, 0, dpToPx(12))
            }
        }

        // Play button - Full width, large size
        val playButton = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#00FFFF")) // Màu xanh mint như trong hình
                cornerRadius = dpToPx(8).toFloat() // Bo góc vuông vắn hơn
            }
            setTextColor(Color.BLACK) // Chữ đen như trong hình
            textSize = 16f // Tăng kích thước chữ
            setTypeface(null, Typeface.BOLD)
            text = "PLAY"
            isAllCaps = true
            setPadding(0, dpToPx(14), 0, dpToPx(14)) // Tăng padding dọc
            gravity = Gravity.CENTER
        }

        // Media placeholder (ImageView, sẽ thay bằng MediaView nếu có video)
        val mediaView = ImageView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                dpToPx(180)
            ).apply {
                setMargins(0, 0, 0, dpToPx(12))
            }
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#E0E0E0"))
                cornerRadius = dpToPx(8).toFloat()
            }
            scaleType = ImageView.ScaleType.CENTER_CROP
        }

        // Title
        val titleView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(0, 0, 0, dpToPx(4))
            }
            setTextColor(Color.WHITE)
            textSize = 16f
            setTypeface(null, Typeface.BOLD)
            maxLines = 2
            text = "Title ads"
        }

        // Description
        val descView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(0, 0, 0, dpToPx(8))
            }
            setTextColor(Color.GRAY)
            textSize = 12f
            maxLines = 2
            text = "Install video maker app for free!"
        }

        // Bottom container for AD badge and Title
        val bottomContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            gravity = Gravity.CENTER_VERTICAL
        }

        // AD badge
        val adBadge = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(0, 0, dpToPx(8), 0)
            }
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#4CAF50"))
                cornerRadius = dpToPx(4).toFloat()
            }
            setPadding(dpToPx(6), dpToPx(2), dpToPx(6), dpToPx(2))
            setTextColor(Color.WHITE)
            textSize = 10f
            setTypeface(null, Typeface.BOLD)
            text = "AD"
        }

        // Title for bottom container
        val bottomTitleView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                0,
                LinearLayout.LayoutParams.WRAP_CONTENT,
                1f
            )
            setTextColor(Color.WHITE)
            textSize = 16f
            setTypeface(null, Typeface.BOLD)
            maxLines = 1
            text = "Title ads"
        }

        // Add views to top container
        topContainer.addView(playButton)

        // Add views to bottom container
        bottomContainer.addView(adBadge)
        bottomContainer.addView(bottomTitleView)

        // Add to main container
        mainContainer.addView(topContainer)
        mainContainer.addView(mediaView)
        mainContainer.addView(descView)
        mainContainer.addView(bottomContainer)

        adView.addView(mainContainer)

        // --- Bind ad data ---
        if (nativeAd.mediaContent != null) {
            val nativeMediaView = MediaView(context).apply {
                layoutParams = mediaView.layoutParams
                setMediaContent(nativeAd.mediaContent)
            }
            mainContainer.removeView(mediaView)
            mainContainer.addView(nativeMediaView, 1) // Index 1 vì topContainer ở index 0
            adView.mediaView = nativeMediaView
        } else if (!nativeAd.images.isNullOrEmpty()) {
            mediaView.setImageDrawable(nativeAd.images[0].drawable)
            adView.imageView = mediaView
        }

        nativeAd.headline?.let { 
            titleView.text = it 
            bottomTitleView.text = it
        }
        nativeAd.body?.let { descView.text = it }
        // Sử dụng call to action cho play button, hoặc giữ "PLAY" mặc định
        nativeAd.callToAction?.let { 
            playButton.text = if (it.contains("install", ignoreCase = true) || 
                                  it.contains("download", ignoreCase = true) || 
                                  it.contains("get", ignoreCase = true)) {
                "PLAY"
            } else {
                it.uppercase()
            }
        }

        // Register views
        adView.headlineView = bottomTitleView
        adView.bodyView = descView
        adView.callToActionView = playButton

        adView.setNativeAd(nativeAd)

        return adView
    }

    private fun dpToPx(dp: Int): Int {
        val density = context.resources.displayMetrics.density
        return (dp * density).toInt()
    }
}