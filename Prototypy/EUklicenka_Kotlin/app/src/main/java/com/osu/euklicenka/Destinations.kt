package com.osu.euklicenka


import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.widget.ListView
import androidx.appcompat.app.AppCompatActivity

class Destinations : AppCompatActivity() {

    lateinit var listView : ListView


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_destinations)
        listView = findViewById(R.id.listView)
        var list = mutableListOf<Model>()





        list.add(Model("Finanční úřad pro Prahu 1",   "Štěpánská 619/28, 112 33 Praha 1",   R.drawable.toilet  ))
        list.add(Model("Magistrát hl. m. Prahy",   "Nová radnice, Mariánské náměstí 2, 110 00",   R.drawable.toilet  ))
        list.add(Model("Magistrát hl.m. Prahy", "Staroměstská radnice s orllojem, Staroměstské náměstí", R.drawable.toilet  ))
        list.add(Model("Magistrát hl.m. Prahy",  "Škodův palác, Jungmannova 35/29, 110 00",  R.drawable.toilet  ))
        list.add(Model("Ministerstvo dopravy ČR",  "nábř. L.Svobody 1222/12, 110 15 Praha 1",  R.drawable.wheelchair  ))

        listView.adapter = MyListAdapter(this,R.layout.row,list)

        listView.setOnItemClickListener{parent, view, position, id ->

            if (position==0){
                var intent: Intent
                try {
                    this.packageManager
                        .getPackageInfo("com.google.android.apps.maps", 0)
                    intent = Intent(Intent.ACTION_VIEW, Uri.parse("geo:50.0791492, 14.4257494"))
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                } catch (e: Exception) {
                    intent = Intent(Intent.ACTION_VIEW, Uri.parse("geo:50.0791492, 14.4257494"))
                }
                this.startActivity(intent)
            }
            if (position==1){
                var intent: Intent
                try {
                    this.packageManager
                        .getPackageInfo("com.google.android.apps.maps", 0)
                    intent = Intent(Intent.ACTION_VIEW, Uri.parse("geo:50.0871086, 14.4178294"))
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                } catch (e: Exception) {
                    intent = Intent(Intent.ACTION_VIEW, Uri.parse("geo:50.0871086, 14.4178294"))
                }
                this.startActivity(intent)
            }
            if (position==2){
                var intent: Intent
                try {
                    this.packageManager
                        .getPackageInfo("com.google.android.apps.maps", 0)
                    intent = Intent(Intent.ACTION_VIEW, Uri.parse("geo:50.0868569, 14.4201967"))
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                } catch (e: Exception) {
                    intent = Intent(Intent.ACTION_VIEW, Uri.parse("geo:50.0868569, 14.4201967"))
                }
                this.startActivity(intent)
            }
            if (position==3){
                var intent: Intent
                try {
                    this.packageManager
                        .getPackageInfo("com.google.android.apps.maps", 0)
                    intent = Intent(Intent.ACTION_VIEW, Uri.parse("geo:50.0819675, 14.4221572"))
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                } catch (e: Exception) {
                    intent = Intent(Intent.ACTION_VIEW, Uri.parse("geo:50.0819675, 14.4221572"))
                }
                this.startActivity(intent)
            }
            if (position==4){
                var intent: Intent
                try {
                    this.packageManager
                        .getPackageInfo("com.google.android.apps.maps", 0)
                    intent = Intent(Intent.ACTION_VIEW, Uri.parse("geo:50.0933519, 14.4343606"))
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                } catch (e: Exception) {
                    intent = Intent(Intent.ACTION_VIEW, Uri.parse("geo:50.0933519, 14.4343606"))
                }
                this.startActivity(intent)
            }
        }

    }

    override fun onBackPressed() {

        var intent = Intent(this, MainActivity::class.java )
        startActivity(intent)
        finish()
    }

}
