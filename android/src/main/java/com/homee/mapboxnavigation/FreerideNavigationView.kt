package com.homee.mapboxnavigation

import android.annotation.SuppressLint
import android.content.res.Configuration
import android.content.res.Resources
import android.location.Location
import android.location.LocationManager
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import android.widget.Toast
import androidx.core.content.ContextCompat
import com.facebook.react.bridge.Arguments
import com.facebook.react.uimanager.ThemedReactContext
import com.mapbox.api.directions.v5.models.DirectionsRoute
import com.mapbox.api.directions.v5.models.RouteOptions
import com.mapbox.bindgen.Expected
import com.mapbox.geojson.Point
import com.mapbox.maps.plugin.LocationPuck2D
import com.mapbox.maps.plugin.animation.camera
import com.mapbox.maps.plugin.locationcomponent.location
import com.mapbox.navigation.base.options.NavigationOptions
import com.mapbox.navigation.core.MapboxNavigation
import com.mapbox.navigation.core.MapboxNavigationProvider
import com.mapbox.navigation.core.replay.MapboxReplayer
import com.mapbox.navigation.core.replay.ReplayLocationEngine
import com.mapbox.navigation.core.replay.route.ReplayProgressObserver
import com.mapbox.navigation.core.trip.session.LocationMatcherResult
import com.mapbox.navigation.core.trip.session.LocationObserver
import com.homee.mapboxnavigation.databinding.NavigationViewBinding
import com.mapbox.navigation.ui.maps.camera.NavigationCamera
import com.mapbox.navigation.ui.maps.camera.data.MapboxNavigationViewportDataSource
import com.mapbox.navigation.ui.maps.camera.lifecycle.NavigationBasicGesturesHandler
import com.mapbox.navigation.ui.maps.camera.state.NavigationCameraState
import com.mapbox.navigation.ui.maps.camera.transition.NavigationCameraTransitionOptions
import com.mapbox.navigation.ui.maps.location.NavigationLocationProvider
import com.mapbox.maps.*
import com.mapbox.maps.plugin.animation.MapAnimationOptions
import java.util.Locale
import com.facebook.react.uimanager.events.RCTEventEmitter

class FreerideNavigationView(private val context: ThemedReactContext, private val accessToken: String?) :
    FrameLayout(context.baseContext) {

    private companion object {
        private const val BUTTON_ANIMATION_DURATION = 1500L
    }



    private var binding: NavigationViewBinding =
        NavigationViewBinding.inflate(LayoutInflater.from(context), this, true)
    private lateinit var mapboxMap: MapboxMap
    private lateinit var freerideNavigation: MapboxNavigation
    private lateinit var navigationCamera: NavigationCamera
    private lateinit var viewportDataSource: MapboxNavigationViewportDataSource

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        onCreate()
    }

    override fun requestLayout() {
        super.requestLayout()
    }

    @SuppressLint("MissingPermission")
    fun onCreate() {

        mapboxMap = binding.mapView.getMapboxMap()

        // initialize the location puck
        binding.mapView.location.apply {
            this.locationPuck = LocationPuck2D(
                bearingImage = ContextCompat.getDrawable(
                    context,
                    R.drawable.mapbox_navigation_puck_icon
                )
            )
            setLocationProvider(navigationLocationProvider)
            enabled = true
        }
        Log.e("TAG","OnCreateeeeeeeeeee")
        init()



    }


    private val navigationLocationProvider = NavigationLocationProvider()
    private val locationObserver = object : LocationObserver {

        override fun onNewRawLocation(rawLocation: Location) {
        }

        override fun onNewLocationMatcherResult(locationMatcherResult: LocationMatcherResult) {
            val enhancedLocation = locationMatcherResult.enhancedLocation
            navigationLocationProvider.changePosition(
                enhancedLocation,
                locationMatcherResult.keyPoints,
            )
            viewportDataSource.onLocationChanged(enhancedLocation)
            viewportDataSource.evaluate()
            updateCamera(enhancedLocation)
        }
    }

    private fun init() {
        initStyle()
        initNavigation()
    }

    @SuppressLint("MissingPermission")
    private fun initNavigation() {
        viewportDataSource = MapboxNavigationViewportDataSource(mapboxMap)
        navigationCamera = NavigationCamera(
            mapboxMap,
            binding.mapView.camera,
            viewportDataSource
        )

        freerideNavigation = if (MapboxNavigationProvider.isCreated()) {
            MapboxNavigationProvider.retrieve()
        } else {
            MapboxNavigationProvider.create(
                NavigationOptions.Builder(context)
                    .accessToken(accessToken)
                    .build()
            )
        }
        freerideNavigation.startTripSession()
        freerideNavigation.registerLocationObserver(locationObserver)
    }
    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        freerideNavigation.unregisterLocationObserver(locationObserver)
        freerideNavigation.stopTripSession()
    }

    private fun onDestroy() {
        MapboxNavigationProvider.destroy()
    }

    private fun initStyle() {
        mapboxMap.loadStyleUri(Style.MAPBOX_STREETS)
    }

    private fun updateCamera(location: Location) {
        val mapAnimationOptions = MapAnimationOptions.Builder().duration(1500L)
            .build()
        //        Toast.makeText(this , "${location.latitude}  ${location.longitude}" , Toast.LENGTH_SHORT).show()
        val event = Arguments.createMap()
        event.putDouble("longitude", location.longitude)
        event.putDouble("latitude", location.latitude)
        context
            .getJSModule(RCTEventEmitter::class.java)
            .receiveEvent(id, "onLocationChange", event)

        navigationCamera.requestNavigationCameraToFollowing(
            stateTransitionOptions = NavigationCameraTransitionOptions.Builder()
                .maxDuration(0) // instant transition
                .build()
        )

        binding.mapView.camera.easeTo(
            CameraOptions.Builder()
                .center(Point.fromLngLat(location.longitude, location.latitude))
                .zoom(17.0)
                .padding(EdgeInsets(40.0, 1.0, 1.0, 1.0))
                .build(),
            mapAnimationOptions
        )
    }
    fun onDropViewInstance() {
        this.onDestroy()
//        sendErrorToReact("Session End")
    }
    private fun sendErrorToReact(error: String?) {
        val event = Arguments.createMap()
        event.putString("error", error)
        context
            .getJSModule(RCTEventEmitter::class.java)
            .receiveEvent(id, "onError", event)
    }


}