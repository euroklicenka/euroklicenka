package com.osu.euklicenka

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.location.Location
import android.os.Bundle

import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.drawable.DrawableCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.*
import com.google.maps.android.clustering.ClusterManager
import com.osu.euklicenka.databinding.ActivityMapsBinding
import com.osu.euklicenka.model.MyItem


class MapsActivity : AppCompatActivity(), OnMapReadyCallback, GoogleMap.OnMapLongClickListener {


    lateinit var mMap: GoogleMap
     lateinit var binding: ActivityMapsBinding


      lateinit var clusterManager:ClusterManager<MyItem>



    var currentLocation : Location? = null
    var fusedLocationProviderClient: FusedLocationProviderClient? = null
    val REQUEST_CODE = 101



     private val locationList = listOf(
        LatLng(49.8425189,18.3454922),
        LatLng(49.8268014, 18.1610736),
        LatLng(49.8280869, 18.1571044),
        LatLng(49.8281136, 18.1614456),
        LatLng(49.8282469, 18.1612033),
        LatLng(49.8285636, 18.1588097),
        LatLng(49.7989167, 18.2297433),
        LatLng(49.8362983, 18.2484900),
        LatLng(49.8203500, 18.1895689),
        LatLng(49.8288722, 18.2806158),
    )
    private val titleList = listOf(
        "Důl Michal v Ostravě",
        " Fakultní nemocnice Ostrava",
        "Fakultní nemocnice Ostrava",
        "Fakultní nemocnice Ostrava",
        "Fakultní nemocnice Ostrava",
        "Fakultní nemocnice Ostrava",
       " Hobby market OBI Ostrava Zábře",
       "Hypermarket Kaufland",
       "Hypermarket Kaufland",
       "Hypermarket Kaufland",
    )
    private val snippetList = listOf(
        "Čs. armády 413/95, 715 00 Ostrava",
        "17. listopadu 1790, 708 52 Ostrava - Poruba",
        "17. listopadu 1790, 708 52 Ostrava – Poruba (Poliklinika 2. patro – u kožních ambulancí a lékárny)",
        "17. listopadu 1790, 708 52 Ostrava – Poruba (Poliklinika 1. patro – u očních sálků)",
        "17. listopadu 1790, 708 52 Ostrava – Poruba (Poliklinika 4. patro – u urologické kliniky)",
        "17. listopadu 1790, 708 52 Ostrava – Poruba (Poliklinika 3. patro – u kliniky úrazové chirurgie)",
       "Výškovická 3123/46, 700 30  Ostrava",
        "Grmelova 2032/2, 709 00 Ostrava - Mariánské Hory",
        "Polská 6191/21, 708 00 Ostrava - Poruba",
        "Vítkovická 3278/3, 702 00 Ostrava Vítkovice",
    )


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMapsBinding.inflate(layoutInflater)
        setContentView(binding.root)

        fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(this)

        fetchLocation()


        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        val mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment

        mapFragment.getMapAsync {

            mMap = it

            val location1 = LatLng(49.9457894, 17.9294319)
            mMap.addMarker(
                MarkerOptions().position(location1)
                    .title("Hypermarket Kaufland, Hlučínská 1698/5, 747 05 Opava - Kateřinky").icon(
                    fromVectorToBitmap(
                        R.drawable.ic_baseline_accessible_24,
                        Color.parseColor("#000000")
                    )
                )
            )
            mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(location1, 10f))
            mMap.moveCamera(CameraUpdateFactory.newLatLng(location1))


            val location2 = LatLng(49.9304658, 17.8747519)
            mMap.addMarker(
                MarkerOptions().position(location2)
                    .title("Hypermarket Kaufland, Olomoucká 2995, 746 01 Opava - Předměstí").icon(
                    fromVectorToBitmap(
                        R.drawable.ic_baseline_accessible_24,
                        Color.parseColor("#000000")
                    )
                )
            )
            mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(location2, 10f))
            mMap.moveCamera(CameraUpdateFactory.newLatLng(location2))


            val location3 = LatLng(49.9313508, 17.9145411)
            mMap.addMarker(
                MarkerOptions().position(location3)
                    .title(" Železniční stanice Opava - východ, Jánská 691/1, 746 01 Opava").icon(
                    fromVectorToBitmap(
                        R.drawable.ic_baseline_accessible_24,
                        Color.parseColor("#000000")
                    )
                )
            )
            mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(location3, 10f))
            mMap.moveCamera(CameraUpdateFactory.newLatLng(location3))
            mMap.setInfoWindowAdapter(CustomInfoAdapter(this))


        }
    }




    private fun fetchLocation() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_COARSE_LOCATION)
            != PackageManager.PERMISSION_GRANTED)
        {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), REQUEST_CODE)
            return
        }

        val task = fusedLocationProviderClient!!.lastLocation
        task.addOnSuccessListener { location ->
            if (location != null){
                currentLocation = location
                val supportMapFragment = (supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment?)
                supportMapFragment!!.getMapAsync(this@MapsActivity)
            }
        }
    }





     private fun fromVectorToBitmap(id: Int, color: Int): BitmapDescriptor {
         val vectorDrawable: Drawable? = ResourcesCompat.getDrawable(resources, id, null)
         if (vectorDrawable == null) {
             return BitmapDescriptorFactory.defaultMarker()
         }
         val bitmap = Bitmap.createBitmap(
             vectorDrawable.intrinsicWidth,
             vectorDrawable.intrinsicHeight,
             Bitmap.Config.ARGB_8888
         )
         val canvas = Canvas(bitmap)
         vectorDrawable.setBounds(0, 0, canvas.width, canvas.height)
         DrawableCompat.setTint(vectorDrawable, color)
         vectorDrawable.draw(canvas)
         return BitmapDescriptorFactory.fromBitmap(bitmap)
     }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        when(requestCode){
            REQUEST_CODE -> {
                if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED){
                    fetchLocation()
                }
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }




    override fun onBackPressed() {

        val intent = Intent(this, MainActivity::class.java )
        startActivity(intent)
        finish()
    }

    override fun onMapReady(googleMap: GoogleMap) {
        val latLng = LatLng(currentLocation!!.latitude, currentLocation!!.longitude)
        val markerOptions = MarkerOptions().position(latLng).title("Tady jsem!")
        googleMap.animateCamera(CameraUpdateFactory.newLatLng(latLng))
        googleMap.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng,15f))

        mMap.setOnMapLongClickListener(this)
        googleMap.addMarker(markerOptions)




        clusterManager = ClusterManager(this,mMap)
        mMap.setOnCameraIdleListener(clusterManager)
        mMap.setOnMarkerClickListener(clusterManager)
        addMarkers()

    }




   private fun addMarkers() {
        locationList.zip(titleList).zip(snippetList).forEach { pair ->
            val myItem =
                MyItem(pair.first.first, " ${pair.first.second}", pair.second)
            clusterManager.addItem(myItem)
   }




    }

     override fun onMapLongClick(p0: LatLng) {
     }





 }





