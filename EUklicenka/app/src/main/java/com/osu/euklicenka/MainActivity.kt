package com.osu.euklicenka

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.osu.euklicenka.databinding.ActivityMainBinding


class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)



        var button1:Button=findViewById(R.id.button1)

        var button2:Button=findViewById(R.id.button2)




        button1.setOnClickListener { v: View? ->
            var intent = Intent(this, Destinations::class.java )
            startActivity(intent)
            finish()
        }

        button2.setOnClickListener { v: View? ->
            var intent = Intent(this, MapsActivity::class.java )
            startActivity(intent)
            finish()
        }



    }
}