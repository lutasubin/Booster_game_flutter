package com.example.booster_game


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
 * Layout: Image lớn ở trên, title + description ở dưới, button install full width
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

        // AD badge
        val adBadge = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(0, 0, 0, dpToPx(8))
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
                setMargins(0, 0, 0, dpToPx(12))
            }
            setTextColor(Color.GRAY)
            textSize = 12f
            maxLines = 2
            text = "Install video maker app for free!"
        }

        // Install button
        val installButton = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#4CAF50"))
                cornerRadius = dpToPx(8).toFloat()
            }
            setTextColor(Color.WHITE)
            textSize = 14f
            setTypeface(null, Typeface.BOLD)
            text = "INSTALL"
            isAllCaps = true
            setPadding(0, dpToPx(12), 0, dpToPx(12))
            gravity = Gravity.CENTER
        }

        // Add to container
        mainContainer.addView(adBadge)
        mainContainer.addView(mediaView)
        mainContainer.addView(titleView)
        mainContainer.addView(descView)
        mainContainer.addView(installButton)

        adView.addView(mainContainer)

        // --- Bind ad data ---
        if (nativeAd.mediaContent != null) {
            val nativeMediaView = MediaView(context).apply {
                layoutParams = mediaView.layoutParams
                setMediaContent(nativeAd.mediaContent)
            }
            mainContainer.removeView(mediaView)
            mainContainer.addView(nativeMediaView, 1)
            adView.mediaView = nativeMediaView
        } else if (!nativeAd.images.isNullOrEmpty()) {
            mediaView.setImageDrawable(nativeAd.images[0].drawable)
            adView.imageView = mediaView
        }

        nativeAd.headline?.let { titleView.text = it }
        nativeAd.body?.let { descView.text = it }
        nativeAd.callToAction?.let { installButton.text = it.uppercase() }

        // Register views
        adView.headlineView = titleView
        adView.bodyView = descView
        adView.callToActionView = installButton

        adView.setNativeAd(nativeAd)

        return adView
    }

    private fun dpToPx(dp: Int): Int {
        val density = context.resources.displayMetrics.density
        return (dp * density).toInt()
    }
}
