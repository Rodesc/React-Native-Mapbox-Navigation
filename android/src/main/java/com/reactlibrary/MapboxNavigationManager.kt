package com.reactlibrary

import android.content.pm.PackageManager
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.mapbox.geojson.Point
import com.mapbox.mapboxsdk.Mapbox
import javax.annotation.Nonnull

class MapboxNavigationManager(var mCallerContext: ReactApplicationContext) : SimpleViewManager<MapboxNavigationView>() {
    init {
        mCallerContext.runOnUiQueueThread {
            try {
                val app = mCallerContext.packageManager.getApplicationInfo(mCallerContext.packageName, PackageManager.GET_META_DATA)
                val bundle = app.metaData
                val accessToken = bundle.getString("MAPBOX_ACCESS_TOKEN")
                Mapbox.getInstance(mCallerContext, accessToken)
            } catch (e: PackageManager.NameNotFoundException) {
                e.printStackTrace()
            }
        }
    }

    override fun getName(): String {
        return "MapboxNavigation"
    }

    public override fun createViewInstance(@Nonnull reactContext: ThemedReactContext): MapboxNavigationView {
        return MapboxNavigationView(reactContext)
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
        )
    }

    @ReactProp(name = "origin")
    fun setOrigin(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setOrigin(null)
            return
        }
        view.setOrigin(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }

    @ReactProp(name = "waypoints")
    fun setWaypoints(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setWaypoints(null)
            return
        }
        view.setWaypoints(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }
    @ReactProp(name = "waypointsOne")
    fun setWaypointsOne(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setWaypointsOne(null)
            return
        }
        view.setWaypointsOne(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }
    @ReactProp(name = "waypointsTwo")
    fun setWaypointsTwo(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setWaypointsTwo(null)
            return
        }
        view.setWaypointsTwo(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }
    @ReactProp(name = "waypointsThree")
    fun setWaypointsThree(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setWaypointsThree(null)
            return
        }
        view.setWaypointsThree(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }
    @ReactProp(name = "waypointsFour")
    fun setWaypointsFour(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setWaypointsFour(null)
            return
        }
        view.setWaypointsFour(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }
    @ReactProp(name = "waypointsFive")
    fun setWaypointsFive(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setWaypointsFive(null)
            return
        }
        view.setWaypointsFive(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }
    @ReactProp(name = "waypointsSix")
    fun setWaypointsSix(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setWaypointsSix(null)
            return
        }
        view.setWaypointsSix(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }
    @ReactProp(name = "waypointsSeven")
    fun setWaypointsSeven(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setWaypointsSeven(null)
            return
        }
        view.setWaypointsSeven(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }
    @ReactProp(name = "waypointsEight")
    fun setWaypointsEight(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setWaypointsEight(null)
            return
        }
        view.setWaypointsEight(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }
    @ReactProp(name = "waypointsNine")
    fun setWaypointsNine(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setWaypointsNine(null)
            return
        }
        view.setWaypointsNine(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }

    @ReactProp(name = "destination")
    fun setDestination(view: MapboxNavigationView, sources: ReadableArray?) {
        if (sources == null) {
            view.setDestination(null)
            return
        }
        view.setDestination(Point.fromLngLat(sources.getDouble(0), sources.getDouble(1)))
    }

    @ReactProp(name = "shouldSimulateRoute")
    fun setShouldSimulateRoute(view: MapboxNavigationView, shouldSimulateRoute: Boolean) {
        view.setShouldSimulateRoute(shouldSimulateRoute)
    }

    @ReactProp(name = "showsEndOfRouteFeedback")
    fun setShowsEndOfRouteFeedback(view: MapboxNavigationView, showsEndOfRouteFeedback: Boolean) {
        view.setShowsEndOfRouteFeedback(showsEndOfRouteFeedback)
    }
}