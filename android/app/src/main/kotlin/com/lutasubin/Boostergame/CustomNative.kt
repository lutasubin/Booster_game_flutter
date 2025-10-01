package com.lutasubin.boostergame

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
            setPadding(dpToPx(12), dpToPx(12), dpToPx(12), dpToPx(12))
        }

        // Play button container (moved to top)
        val buttonContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(0, 0, 0, dpToPx(12))
            }
        }

        // Play button (larger and more prominent)
        val playButton = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 
                dpToPx(36)
            ).apply {
                setMargins(dpToPx(8), 0, dpToPx(8), 0)
            }
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#00FF88"))  // Bright green like in image
                cornerRadius = dpToPx(8).toFloat()
            }
            setTextColor(Color.parseColor("#000000"))  // Black text for contrast
            textSize = 14f
            setTypeface(null, Typeface.BOLD)
            text = "PLAY"
            isAllCaps = true
            setPadding(0, 0, 0, 0)
        }

        buttonContainer.addView(playButton)

        // Content container (icon and description)
        val contentContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        }

        // Icon view
        val iconView = ImageView(context).apply {
            layoutParams = LinearLayout.LayoutParams(dpToPx(48), dpToPx(48))
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
                marginStart = dpToPx(12)
            }
        }

        // Description container
        val descContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
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

        // Title (moved to bottom of text container)
        val titleView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(0, dpToPx(6), 0, 0)
            }
            setTextColor(Color.WHITE)
            textSize = 16f  // Made larger
            setTypeface(null, Typeface.BOLD)
            isSingleLine = true
            text = "Game Title"
        }

        // Add to textContainer (description first, then title)
        textContainer.addView(descContainer)
        textContainer.addView(titleView)

        // Add to contentContainer
        contentContainer.addView(iconView)
        contentContainer.addView(textContainer)

        // Add everything to main container (button first, then content)
        mainContainer.addView(buttonContainer)
        mainContainer.addView(contentContainer)

        // Add main container to adView
        adView.addView(mainContainer)

        // Bind ad data
        nativeAd.icon?.let { iconView.setImageDrawable(it.drawable) }
        nativeAd.headline?.let { titleView.text = it }
        nativeAd.body?.let { descView.text = it }
        nativeAd.callToAction?.let { playButton.text = it.uppercase() }

        // Register views
        adView.setIconView(iconView)
        adView.setHeadlineView(titleView)
        adView.setBodyView(descView)
        adView.setCallToActionView(playButton)

        adView.setNativeAd(nativeAd)

        return adView
    }

    private fun dpToPx(dp: Int): Int {
        val density = context.resources.displayMetrics.density
        return (dp * density).toInt()
    }
}