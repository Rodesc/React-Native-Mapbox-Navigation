package com.homee.mapboxnavigation

import android.content.pm.PackageManager
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mapbox.geojson.Point
import com.mapbox.maps.ResourceOptionsManager
import com.mapbox.maps.TileStoreUsageMode
import javax.annotation.Nonnull


class MapboxNavigationManager(var mCallerContext: ReactApplicationContext) : SimpleViewManager<MapboxNavigationView>() {
    private var accessToken: String? = null

    init {
        mCallerContext.runOnUiQueueThread {
            try {
                val app = mCallerContext.packageManager.getApplicationInfo(mCallerContext.packageName, PackageManager.GET_META_DATA)
                val bundle = app.metaData
                val accessToken = bundle.getString("MAPBOX_ACCESS_TOKEN")
                this.accessToken = accessToken
                ResourceOptionsManager.getDefault(mCallerContext, accessToken).update {
                    tileStoreUsageMode(TileStoreUsageMode.READ_ONLY)
                }
            } catch (e: PackageManager.NameNotFoundException) {
                e.printStackTrace()
            }
        }
    }

    override fun getName(): String {
        return "MapboxNavigation"
    }

    public override fun createViewInstance(@Nonnull reactContext: ThemedReactContext): MapboxNavigationView {
        return MapboxNavigationView(reactContext, this.accessToken)
    }

    override fun onDropViewInstance(view: MapboxNavigationView) {
        view.onDropViewInstance()
        super.onDropViewInstance(view)
    }

    override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Map<String, String>>? {
        return MapBuilder.of<String, Map<String, String>>(
                "onLocationChange", MapBuilder.of("registrationName", "onLocationChange"),
                "onError", MapBuilder.of("registrationName", "onError"),
                "onCancelNavigation", MapBuilder.of("registrationName", "onCancelNavigation"),
                "onArrive", MapBuilder.of("registrationName", "onArrive"),
                "onRouteProgressChange", MapBuilder.of("registrationName", "onRouteProgressChange"),
                 "onSkip", MapBuilder.of("registrationName", "onSkip"),
        )
    }

    @ReactProp(name = "language")
    fun setDestination(view: MapboxNavigationView, sources: String) {
        if (sources == null) {
            view.setLanguage("en")
            return
        }
        view.setLanguage(sources)
    }

    @ReactProp(name = "origin")
    fun setOrigin(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setOrigin(null)
            return
        }
        view.setOrigin(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }

    @ReactProp(name = "destination")
    fun setDestination(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setDestination(null)
            return
        }
        view.setDestination(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }

    @ReactProp(name = "waypoints")
    fun setWaypoints(view: MapboxNavigationView, sources: ReadableArray) {
        var listbhai = mutableListOf<Point?>()
        var len = sources.size()
        var i = 1
        for (item in sources.toArrayList()){
            if(i%2 == 0){
                listbhai.add(Point.fromLngLat(sources.getDouble(i-1), sources.getDouble(i-2)))
            }
            i++
        }
        view.setWaypoints(listbhai)
    }

    @ReactProp(name = "shouldSimulateRoute")
    fun setShouldSimulateRoute(view: MapboxNavigationView, shouldSimulateRoute: Boolean) {
        view.setShouldSimulateRoute(shouldSimulateRoute)
    }

    @ReactProp(name = "showsEndOfRouteFeedback")
    fun setShowsEndOfRouteFeedback(view: MapboxNavigationView, showsEndOfRouteFeedback: Boolean) {
        view.setShowsEndOfRouteFeedback(showsEndOfRouteFeedback)
    }

    @ReactProp(name = "mute")
    fun setMute(view: MapboxNavigationView, mute: Boolean) {
        view.setMute(mute)
    }
}
