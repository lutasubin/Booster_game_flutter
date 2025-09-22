package com.example.booster_game

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.widget.*
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.AdChoicesView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class CustomNativeAdFullFactory(private val context: Context) :
    GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = NativeAdView(context)

        // Main container
        val mainContainer = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
            )
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#172032"))
                cornerRadius = 0f
                setStroke(dpToPx(1), Color.argb(13, 255, 255, 255))
            }
            setPadding(dpToPx(12), dpToPx(12), dpToPx(12), dpToPx(12))
        }

        // Content container (weight để đẩy CTA xuống đáy)
        val contentContainer = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                0,
                1f
            )
        }

        // AD Badge
        val adBadge = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { setMargins(0, 0, 0, dpToPx(8)) }
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

        // MediaView
        val mediaView = MediaView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                dpToPx(340)
            ).apply { setMargins(0, 0, 0, dpToPx(12)) }
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#121212"))
                cornerRadius = dpToPx(8).toFloat()
            }
        }

        // Headline
        val titleView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { setMargins(0, 0, 0, dpToPx(6)) }
            setTextColor(Color.WHITE)
            textSize = 18f
            setTypeface(null, Typeface.BOLD)
            maxLines = 2
        }

        // Body
        val descView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { setMargins(0, 0, 0, dpToPx(14)) }
            setTextColor(Color.parseColor("#B3B3B3"))
            textSize = 13f
            maxLines = 3
        }

        // CTA Button
        val ctaButton = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply { setMargins(dpToPx(8), dpToPx(8), dpToPx(8), dpToPx(8)) }
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#4CAF50"))
                cornerRadius = dpToPx(24).toFloat()
            }
            setTextColor(Color.WHITE)
            textSize = 14f
            setTypeface(null, Typeface.BOLD)
            isAllCaps = true
            setPadding(0, dpToPx(12), 0, dpToPx(12))
        }

        // AdChoicesView
        val adChoicesView = AdChoicesView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        }

        // Add views
        contentContainer.addView(adBadge)
        contentContainer.addView(mediaView)
        contentContainer.addView(titleView)
        contentContainer.addView(descView)

        mainContainer.addView(contentContainer)
        mainContainer.addView(ctaButton)
        mainContainer.addView(adChoicesView)

        adView.addView(mainContainer)

        // Bind data
        adView.mediaView = mediaView
        adView.headlineView = titleView
        adView.bodyView = descView
        adView.callToActionView = ctaButton
        adView.adChoicesView = adChoicesView

        nativeAd.headline?.let { titleView.text = it }
        nativeAd.body?.let { descView.text = it }
        nativeAd.callToAction?.let { ctaButton.text = it.uppercase() }

        adView.setNativeAd(nativeAd)

        return adView
    }

    private fun dpToPx(dp: Int): Int {
        val density = context.resources.displayMetrics.density
        return (dp * density).toInt()
    }
}
