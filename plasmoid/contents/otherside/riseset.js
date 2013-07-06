//Script from http://www.abecedarical.com/javascript/script_sun_rise_set2.html

var PI = Math.PI;
var DR = PI/180;
var K1 = 15*DR*1.0027379

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

var Sunrise = false;
var Sunset  = false;

var Sun_Rise_time = [0, 0];
var Sun_Set_time  = [0, 0];
var Sun_Rise_az = 0.0;
var Sun_Set_az  = 0.0;

var Sun_Sky = [0.0, 0.0];
var Sun_RAn = [0.0, 0.0, 0.0];
var Sun_Dec = [0.0, 0.0, 0.0];
var Sun_VHz = [0.0, 0.0, 0.0];


// calculate sunrise and sunset times
function sun_riseset( lat, lon, Now )
{
    var k;
    var zone = Math.round(Now.getTimezoneOffset()/60);
    var jd = julian_day(Now) - 2451545;           // Julian day relative to Jan 1.5, 2000

    /*
        //    if ((sgn(zone) == sgn(lon))&&(zone != 0))
        //        window.alert("WARNING: time zone and longitude are incompatible!");
        /////////// new stuff
            var x = lon;
            calc.zone.value = Math.round(-x/15);
            zone = Math.round(-x/15);
            zone = -4
        ///////////
    */

    lon = lon/360;
    var tz  = zone/24;
    var ct  = jd/36525 + 1;                    // centuries since 1900.0
    var t0 = lst(lon, jd, tz);                 // local sidereal time

    jd = jd + tz;                              // get sun position at start of day
    sun(jd, ct);
    var ra0  = Sun_Sky[0];
    var dec0 = Sun_Sky[1];

    jd = jd + 1;                               // get sun position at end of day
    sun(jd, ct);
    var ra1  = Sun_Sky[0];
    var dec1 = Sun_Sky[1];

    if (ra1 < ra0)                             // make continuous
        ra1 = ra1 + 2*PI;

    Sunrise = false;                           // initialize
    Sunset  = false;
    Sun_RAn[0]   = ra0;
    Sun_Dec[0]  = dec0;

    for (k = 0; k < 24; k++)                   // check each hour of this day
    {
        var ph = (k + 1)/24;

        Sun_RAn[2] = ra0  + (k + 1)*(ra1  - ra0)/24;
        Sun_Dec[2] = dec0 + (k + 1)*(dec1 - dec0)/24;
        Sun_VHz[2] = test_sun(k, zone, t0, lat);

        Sun_RAn[0] = Sun_RAn[2];                       // advance to next hour
        Sun_Dec[0] = Sun_Dec[2];
        Sun_VHz[0] = Sun_VHz[2];
    }

    // display results
//    calc.sunrise.value = zintstr(Rise_time[0], 2) + ":" + zintstr(Rise_time[1], 2)
//                       + ", az = " + frealstr(Rise_az, 5, 1) + "°";
//    calc.sunset.value  = zintstr( Set_time[0], 2) + ":" + zintstr( Set_time[1], 2)
//                       + ", az = " + frealstr(Set_az, 5, 1) + "°";

    console.log(Sun_Rise_time[0], ":", Sun_Rise_time[1])
    console.log(Sun_Set_time[0], ":", Sun_Set_time[1])

    if ((!Sunrise)&&(!Sunset)) {
    // neither sunrise nor sunset
        if (Sun_VHz[2] < 0) console.log("Sun down all day"); else console.log("Sun up all day");
    } else {
    // sunrise or sunset
        if (!Sunrise) console.log("No sunrise this date"); else if (!Sunset) console.log("No sunset this date");
    }
}

// test an hour for an event
function test_sun( k, zone, t0, lat )
{
    var ha = new Array(3);
    var a, b, c, d, e, s, z;
    var hr, min, time;
    var az, dz, hz, nz;

    ha[0] = t0 - Sun_RAn[0] + k*K1;
    ha[2] = t0 - Sun_RAn[2] + k*K1 + K1;

    ha[1]  = (ha[2]  + ha[0])/2;               // hour angle at half hour
    Sun_Dec[1] = (Sun_Dec[2] + Sun_Dec[0])/2 ;             // declination at half hour

    s = Math.sin(lat*DR);
    c = Math.cos(lat*DR);
    z = Math.cos(90.833*DR);                   // refraction + sun semidiameter at horizon

    if (k <= 0)
        Sun_VHz[0] = s*Math.sin(Sun_Dec[0]) + c*Math.cos(Sun_Dec[0])*Math.cos(ha[0]) - z;

    Sun_VHz[2] = s*Math.sin(Sun_Dec[2]) + c*Math.cos(Sun_Dec[2])*Math.cos(ha[2]) - z;

    if (sgn(Sun_VHz[0]) == sgn(Sun_VHz[2]))
        return Sun_VHz[2];                         // no event this hour

    Sun_VHz[1] = s*Math.sin(Sun_Dec[1]) + c*Math.cos(Sun_Dec[1])*Math.cos(ha[1]) - z;

    a =  2* Sun_VHz[0] - 4*Sun_VHz[1] + 2*Sun_VHz[2];
    b = -3* Sun_VHz[0] + 4*Sun_VHz[1] - Sun_VHz[2];
    d = b*b - 4*a*Sun_VHz[0];

    if (d < 0)
        return Sun_VHz[2];                         // no event this hour

    d = Math.sqrt(d);
    e = (-b + d)/(2 * a);

    if ((e > 1)||(e < 0))
        e = (-b - d)/(2*a);

    time = k + e + 1/120;                      // time of an event

    hr = Math.floor(time);
    min = Math.floor((time - hr)*60);

    hz = ha[0] + e*(ha[2] - ha[0]);            // azimuth of the sun at the event
    nz = -Math.cos(Sun_Dec[1])*Math.sin(hz);
    dz = c*Math.sin(Sun_Dec[1]) - s*Math.cos(Sun_Dec[1])*Math.cos(hz);
    az = Math.atan2(nz, dz)/DR;
    if (az < 0) az = az + 360;

    if ((Sun_VHz[0] < 0)&&(Sun_VHz[2] > 0))
    {
        Sun_Rise_time[0] = hr;
        Sun_Rise_time[1] = min;
        Sun_Rise_az = az;
        Sunrise = true;
    }

    if ((Sun_VHz[0] > 0)&&(Sun_VHz[2] < 0))
    {
        Sun_Set_time[0] = hr;
        Sun_Set_time[1] = min;
        Sun_Set_az = az;
        Sunset = true;
    }

    return Sun_VHz[2];
}

// sun's position using fundamental arguments
// (Van Flandern & Pulkkinen, 1979)
function sun( jd, ct )
{
    var g, lo, s, u, v, w;

    lo = 0.779072 + 0.00273790931*jd;
    lo = lo - Math.floor(lo);
    lo = lo*2*PI;

    g = 0.993126 + 0.0027377785*jd;
    g = g - Math.floor(g);
    g = g*2*PI;

    v = 0.39785*Math.sin(lo);
    v = v - 0.01*Math.sin(lo - g);
    v = v + 0.00333*Math.sin(lo + g);
    v = v - 0.00021*ct * Math.sin(lo);

    u = 1 - 0.03349*Math.cos(g);
    u = u - 0.00014*Math.cos(2*lo);
    u = u + 0.00008*Math.cos(lo);

    w = -0.0001 - 0.04129*Math.sin(2*lo);
    w = w + 0.03211*Math.sin(g );
    w = w + 0.00104*Math.sin(2*lo - g);
    w = w - 0.00035*Math.sin(2*lo + g);
    w = w - 0.00008*ct*Math.sin(g);

    s = w/Math.sqrt(u - v*v);                  // compute sun's right ascension
    Sun_Sky[0] = lo + Math.atan(s/Math.sqrt(1 - s*s));

    s = v/Math.sqrt(u);                        // ...and declination
    Sun_Sky[1] = Math.atan(s/Math.sqrt(1 - s*s));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

var Moonrise = false;
var Moonset  = false;

var Moon_Rise_time = [0, 0];
var Moon_Set_time  = [0, 0];
var Moon_Rise_az = 0.0;
var Moon_Set_az  = 0.0;

var Moon_Sky = [0.0, 0.0, 0.0];
var Moon_RAn = [0.0, 0.0, 0.0];
var Moon_Dec = [0.0, 0.0, 0.0];
var Moon_VHz = [0.0, 0.0, 0.0];

// calculate moonrise and moonset times
function moon_riseset( lat, lon, Now )
{
    var i, j, k;
    var zone = Math.round(Now.getTimezoneOffset()/60);
    var jd = julian_day(Now) - 2451545;           // Julian day relative to Jan 1.5, 2000



    var mp = new Array(3);                     // create a 3x3 array
    for (i = 0; i < 3; i++)
    {
        mp[i] = new Array(3);
        for (j = 0; j < 3; j++)
            mp[i][j] = 0.0;
    }

    lon = lon/360;
    var tz = zone/24;
    var t0 = lst(lon, jd, tz);                 // local sidereal time

    jd = jd + tz;                              // get moon position at start of day

    for (k = 0; k < 3; k++)
    {
        moon(jd);
        mp[k][0] = Moon_Sky[0];
        mp[k][1] = Moon_Sky[1];
        mp[k][2] = Moon_Sky[2];
        jd = jd + 0.5;
    }

    if (mp[1][0] <= mp[0][0])
        mp[1][0] = mp[1][0] + 2*PI;

    if (mp[2][0] <= mp[1][0])
        mp[2][0] = mp[2][0] + 2*PI;

    Moon_RAn[0] = mp[0][0];
    Moon_Dec[0] = mp[0][1];

    Moonrise = false;                          // initialize
    Moonset  = false;

    for (k = 0; k < 24; k++)                   // check each hour of this day
    {
        var ph = (k + 1)/24;

        Moon_RAn[2] = interpolate(mp[0][0], mp[1][0], mp[2][0], ph);
        Moon_Dec[2] = interpolate(mp[0][1], mp[1][1], mp[2][1], ph);

        Moon_VHz[2] = test_moon(k, zone, t0, lat, mp[1][2]);

        Moon_RAn[0] = Moon_RAn[2];                       // advance to next hour
        Moon_Dec[0] = Moon_Dec[2];
        Moon_VHz[0] = Moon_VHz[2];
    }


    console.log(Moon_Rise_time[0], ":", Moon_Rise_time[1])
    console.log(Moon_Set_time[0], ":", Moon_Set_time[1])
    /*
    calc.moonrise.value = zintstr(Rise_time[0], 2) + ":" + zintstr(Rise_time[1], 2)
                       + ", az = " + frealstr(Rise_az, 5, 1) + "°";
    calc.moonset.value  = zintstr( Set_time[0], 2) + ":" + zintstr( Set_time[1], 2)
                       + ", az = " + frealstr(Set_az, 5, 1) + "°";
    //  */
    if ((!Moonrise)&&(!Moonset)) {
    // neither moonrise nor moonset
        if (Moon_VHz[2] < 0) calc.moonrise.value = "Moon down all day"; else calc.moonrise.value = "Moon up all day";
    } else {
    // moonrise or moonset
        if (!Moonrise) calc.moonrise.value = "No moonrise this date"; else if (!Moonset) calc.moonset.value  = "No moonset this date";
    }
}

// test an hour for an event
function test_moon( k, zone, t0, lat, plx )
{
    var ha = [0.0, 0.0, 0.0];
    var a, b, c, d, e, s, z;
    var hr, min, time;
    var az, hz, nz, dz;

    if (Moon_RAn[2] < Moon_RAn[0])
        Moon_RAn[2] = Moon_RAn[2] + 2*PI;

    ha[0] = t0 - Moon_RAn[0] + k*K1;
    ha[2] = t0 - Moon_RAn[2] + k*K1 + K1;

    ha[1]  = (ha[2] + ha[0])/2;                // hour angle at half hour
    Moon_Dec[1] = (Moon_Dec[2] + Moon_Dec[0])/2;              // declination at half hour

    s = Math.sin(DR*lat);
    c = Math.cos(DR*lat);

    // refraction + sun semidiameter at horizon + parallax correction
    z = Math.cos(DR*(90.567 - 41.685/plx));

    if (k <= 0)                                // first call of function
        Moon_VHz[0] = s*Math.sin(Moon_Dec[0]) + c*Math.cos(Moon_Dec[0])*Math.cos(ha[0]) - z;

    Moon_VHz[2] = s*Math.sin(Moon_Dec[2]) + c*Math.cos(Moon_Dec[2])*Math.cos(ha[2]) - z;

    if (sgn(Moon_VHz[0]) == sgn(Moon_VHz[2]))
        return Moon_VHz[2];                         // no event this hour

    Moon_VHz[1] = s*Math.sin(Moon_Dec[1]) + c*Math.cos(Moon_Dec[1])*Math.cos(ha[1]) - z;

    a = 2*Moon_VHz[2] - 4*Moon_VHz[1] + 2*Moon_VHz[0];
    b = 4*Moon_VHz[1] - 3*Moon_VHz[0] - Moon_VHz[2];
    d = b*b - 4*a*Moon_VHz[0];

    if (d < 0)
        return Moon_VHz[2];                         // no event this hour

    d = Math.sqrt(d);
    e = (-b + d)/(2*a);

    if (( e > 1 )||( e < 0 ))
        e = (-b - d)/(2*a);

    time = k + e + 1/120;                      // time of an event + round up
    hr   = Math.floor(time);
    min  = Math.floor((time - hr)*60);

    hz = ha[0] + e*(ha[2] - ha[0]);            // azimuth of the moon at the event
    nz = -Math.cos(Moon_Dec[1])*Math.sin(hz);
    dz = c*Math.sin(Moon_Dec[1]) - s*Math.cos(Moon_Dec[1])*Math.cos(hz);
    az = Math.atan2(nz, dz)/DR;
    if (az < 0) az = az + 360;

    if ((Moon_VHz[0] < 0)&&(Moon_VHz[2] > 0))
    {
        Moon_Rise_time[0] = hr;
        Moon_Rise_time[1] = min;
        Moon_Rise_az = az;
        Moonrise = true;
    }

    if ((Moon_VHz[0] > 0)&&(Moon_VHz[2] < 0))
    {
        Moon_Set_time[0] = hr;
        Moon_Set_time[1] = min;
        Moon_Set_az = az;
        Moonset = true;
    }

    return Moon_VHz[2];
}

// moon's position using fundamental arguments
// (Van Flandern & Pulkkinen, 1979)
function moon( jd )
{
    var d, f, g, h, m, n, s, u, v, w;

    h = 0.606434 + 0.03660110129*jd;
    m = 0.374897 + 0.03629164709*jd;
    f = 0.259091 + 0.0367481952 *jd;
    d = 0.827362 + 0.03386319198*jd;
    n = 0.347343 - 0.00014709391*jd;
    g = 0.993126 + 0.0027377785 *jd;

    h = h - Math.floor(h);
    m = m - Math.floor(m);
    f = f - Math.floor(f);
    d = d - Math.floor(d);
    n = n - Math.floor(n);
    g = g - Math.floor(g);

    h = h*2*PI;
    m = m*2*PI;
    f = f*2*PI;
    d = d*2*PI;
    n = n*2*PI;
    g = g*2*PI;

    v = 0.39558*Math.sin(f + n);
    v = v + 0.082  *Math.sin(f);
    v = v + 0.03257*Math.sin(m - f - n);
    v = v + 0.01092*Math.sin(m + f + n);
    v = v + 0.00666*Math.sin(m - f);
    v = v - 0.00644*Math.sin(m + f - 2*d + n);
    v = v - 0.00331*Math.sin(f - 2*d + n);
    v = v - 0.00304*Math.sin(f - 2*d);
    v = v - 0.0024 *Math.sin(m - f - 2*d - n);
    v = v + 0.00226*Math.sin(m + f);
    v = v - 0.00108*Math.sin(m + f - 2*d);
    v = v - 0.00079*Math.sin(f - n);
    v = v + 0.00078*Math.sin(f + 2*d + n);

    u = 1 - 0.10828*Math.cos(m);
    u = u - 0.0188 *Math.cos(m - 2*d);
    u = u - 0.01479*Math.cos(2*d);
    u = u + 0.00181*Math.cos(2*m - 2*d);
    u = u - 0.00147*Math.cos(2*m);
    u = u - 0.00105*Math.cos(2*d - g);
    u = u - 0.00075*Math.cos(m - 2*d + g);

    w = 0.10478*Math.sin(m);
    w = w - 0.04105*Math.sin(2*f + 2*n);
    w = w - 0.0213 *Math.sin(m - 2*d);
    w = w - 0.01779*Math.sin(2*f + n);
    w = w + 0.01774*Math.sin(n);
    w = w + 0.00987*Math.sin(2*d);
    w = w - 0.00338*Math.sin(m - 2*f - 2*n);
    w = w - 0.00309*Math.sin(g);
    w = w - 0.0019 *Math.sin(2*f);
    w = w - 0.00144*Math.sin(m + n);
    w = w - 0.00144*Math.sin(m - 2*f - n);
    w = w - 0.00113*Math.sin(m + 2*f + 2*n);
    w = w - 0.00094*Math.sin(m - 2*d + g);
    w = w - 0.00092*Math.sin(2*m - 2*d);

    s = w/Math.sqrt(u - v*v);                  // compute moon's right ascension ...
    Moon_Sky[0] = h + Math.atan(s/Math.sqrt(1 - s*s));

    s = v/Math.sqrt(u);                        // declination ...
    Moon_Sky[1] = Math.atan(s/Math.sqrt(1 - s*s));

    Moon_Sky[2] = 60.40974*Math.sqrt( u );          // and parallax
}

// 3-point interpolation
function interpolate( f0, f1, f2, p )
{
    var a = f1 - f0;
    var b = f2 - f1 - a;
    var f = f0 + p*(2*a + b*(2*p - 1));

    return f;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// determine Julian day from calendar date
// (Jean Meeus, "Astronomical Algorithms", Willmann-Bell, 1991)
function julian_day(Now)
{
    var a, b, jd;
    var gregorian;

    var month = Now.getMonth() + 1;
    var day   = Now.getDate();
    var year  = Now.getFullYear();

    gregorian = (year < 1583) ? false : true;

    if ((month == 1)||(month == 2))
    {
        year  = year  - 1;
        month = month + 12;
    }

    a = Math.floor(year/100);
    if (gregorian) b = 2 - a + Math.floor(a/4);
    else           b = 0.0;

    jd = Math.floor(365.25*(year + 4716))
       + Math.floor(30.6001*(month + 1))
       + day + b - 1524.5;

    return jd;
}

// returns value for sign of argument
function sgn( x )
{
    var rv;
    if (x > 0.0)      rv =  1;
    else if (x < 0.0) rv = -1;
    else              rv =  0;
    return rv;
}

// Local Sidereal Time for zone
function lst( lon, jd, z )
{
    var s = 24110.5 + 8640184.812999999*jd/36525 + 86636.6*z + 86400*lon;
    s = s/86400;
    s = s - Math.floor(s);
    return s*360*DR;
}
