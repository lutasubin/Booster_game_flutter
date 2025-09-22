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
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class CustomNativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

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
            setPadding(dpToPx(8), dpToPx(8), dpToPx(8), dpToPx(8))
        }

        // Header container
        val headerContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        }

        // Icon view
        val iconView = ImageView(context).apply {
            layoutParams = LinearLayout.LayoutParams(dpToPx(40), dpToPx(40))
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#E0E0E0"))
                cornerRadius = dpToPx(8).toFloat()
            }
            scaleType = ImageView.ScaleType.CENTER
        }

        // Text container
        val textContainer = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f).apply {
                marginStart = dpToPx(8)
            }
        }

        // Title
        val titleView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            setTextColor(Color.WHITE)
            textSize = 14f
            setTypeface(null, Typeface.BOLD)
            isSingleLine = true
            text = "Title ads"
        }

        // Description container
        val descContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(0, dpToPx(2), 0, 0)
            }
        }

        // AD badge
        val adBadge = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
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

        // Description text
        val descView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f).apply {
                marginStart = dpToPx(8)
            }
            setTextColor(Color.GRAY)
            textSize = 12f
            isSingleLine = true
            text = "Install video maker app for free!"
        }

        // Add to descContainer
        descContainer.addView(adBadge)
        descContainer.addView(descView)

        // Add to textContainer
        textContainer.addView(titleView)
        textContainer.addView(descContainer)

        // Add to headerContainer
        headerContainer.addView(iconView)
        headerContainer.addView(textContainer)

        // Button container
        val buttonContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(0, dpToPx(6), 0, 0)
            }
        }

        // Install button
        val installButton = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(dpToPx(120), LinearLayout.LayoutParams.WRAP_CONTENT)
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#4CAF50"))
                cornerRadius = dpToPx(6).toFloat()
            }
            setTextColor(Color.WHITE)
            textSize = 12f
            setTypeface(null, Typeface.BOLD)
            text = "INSTALL"
            isAllCaps = true
            setPadding(0, dpToPx(8), 0, dpToPx(8))
        }

        buttonContainer.addView(installButton)

        // Add everything to main container
        mainContainer.addView(headerContainer)
        mainContainer.addView(buttonContainer)

        // Add main container to adView
        adView.addView(mainContainer)

        // Bind ad data
        nativeAd.icon?.let { iconView.setImageDrawable(it.drawable) }
        nativeAd.headline?.let { titleView.text = it }
        nativeAd.body?.let { descView.text = it }
        nativeAd.callToAction?.let { installButton.text = it.uppercase() }

        // Register views
        adView.setIconView(iconView)
        adView.setHeadlineView(titleView)
        adView.setBodyView(descView)
        adView.setCallToActionView(installButton)

        adView.setNativeAd(nativeAd)

        return adView
    }

    private fun dpToPx(dp: Int): Int {
        val density = context.resources.displayMetrics.density
        return (dp * density).toInt()
    }
}
