//Script from http://mysite.verizon.net/res148h4j/javascript/script_planet_orbits.html

.pragma library

var DEGS = 180/Math.PI;                  // convert radians to degrees
var RADS = Math.PI/180;                  // convert degrees to radians
var EPS  = 1.0e-12;                      // machine error constant

var pname = ["Mercury", "Venus  ", "Earth  ",
             "Mars   ", "Jupiter", "Saturn ",
             "Uranus ", "Neptune", "Pluto  "];

function angle(date)
{
    var c = get_coord(2, day_number(date))
    return tri_angle(c.x, c.y)
}

function tri_angle(x,y){
    if(x == 0) return (y>0) ? 180 : 0;
    var a = Math.atan(y/x)*180/Math.PI;
    a = (x > 0) ? a+90 : a+270;

    return Math.round(a);
}

// convert angle (deg, min, sec) to degrees as real
function dms2real( deg, min, sec )
{
    var rv;
    if (deg < 0) rv = deg - min/60 - sec/3600;
    else         rv = deg + min/60 + sec/3600;
    return rv;
}
// day number to/from J2000 (Jan 1.5, 2000)
function day_number(now)
{
    if(!now) now = new Date();
    var y    = now.getUTCFullYear();
    var m    = now.getUTCMonth() + 1;
    var d    = now.getUTCDate();
    var hour = now.getUTCHours();
    var mins = now.getUTCMinutes();

    var h = hour + mins/60;
    var rv = 367*y
           - Math.floor(7*(y + Math.floor((m + 9)/12))/4)
           + Math.floor(275*m/9) + d - 730531.5 + h/24;
    return rv;
}

// compute RA, DEC, and distance of planet-p for day number-d
// result returned in structure obj in degrees and astronomical units
function get_coord( i, d )
{
    // orbital element structure
    var p = {
        a : parseFloat("0"),    // semi-major axis [AU]
        e : parseFloat("0"),    // eccentricity of orbit
        i : parseFloat("0"),    // inclination of orbit [deg]
        O : parseFloat("0"),    // longitude of the ascending node [deg]
        w : parseFloat("0"),    // longitude of perihelion [deg]
        L : parseFloat("0")     // mean longitude [deg]
    }
    mean_elements(p, i, d);

    // position of planet in its orbit
    var mp = mod2pi(p.L - p.w);
    var vp = true_anomaly(mp, p.e);
    var rp = p.a*(1 - p.e*p.e)/(1 + p.e*Math.cos(vp));

    // heliocentric rectangular coordinates of planet
    var xh = rp*(Math.cos(p.O)*Math.cos(vp + p.w - p.O) - Math.sin(p.O)*Math.sin(vp + p.w - p.O)*Math.cos(p.i));
    var yh = rp*(Math.sin(p.O)*Math.cos(vp + p.w - p.O) + Math.cos(p.O)*Math.sin(vp + p.w - p.O)*Math.cos(p.i));
    // var zh = rp*(Math.sin(vp + p.w - p.O)*Math.sin(p.i));

    // return { mp:mp, vp:vp, rp:rp,  xh:xh, yh:yh, zh:zh }
    return { x:xh, y:yh }
}

// Compute the elements of the orbit for planet-i at day number-d
// result is returned in structure p
function mean_elements( p, i, d )
{
    var cy = d/36525;                    // centuries since J2000

    switch (i)
    {
    case 0: // Mercury
        p.a = 0.38709893 + 0.00000066*cy;
        p.e = 0.20563069 + 0.00002527*cy;
        p.i = ( 7.00487  -  23.51*cy/3600)*RADS;
        p.O = (48.33167  - 446.30*cy/3600)*RADS;
        p.w = (77.45645  + 573.57*cy/3600)*RADS;
        p.L = mod2pi((252.25084 + 538101628.29*cy/3600)*RADS);
        break;
    case 1: // Venus
        p.a = 0.72333199 + 0.00000092*cy;
        p.e = 0.00677323 - 0.00004938*cy;
        p.i = (  3.39471 -   2.86*cy/3600)*RADS;
        p.O = ( 76.68069 - 996.89*cy/3600)*RADS;
        p.w = (131.53298 - 108.80*cy/3600)*RADS;
        p.L = mod2pi((181.97973 + 210664136.06*cy/3600)*RADS);
        break;
    case 2: // Earth/Sun
        p.a = 1.00000011 - 0.00000005*cy;
        p.e = 0.01671022 - 0.00003804*cy;
        p.i = (  0.00005 -    46.94*cy/3600)*RADS;
        p.O = (-11.26064 - 18228.25*cy/3600)*RADS;
        p.w = (102.94719 +  1198.28*cy/3600)*RADS;
        p.L = mod2pi((100.46435 + 129597740.63*cy/3600)*RADS);
        break;
    case 3: // Mars
        p.a = 1.52366231 - 0.00007221*cy;
        p.e = 0.09341233 + 0.00011902*cy;
        p.i = (  1.85061 -   25.47*cy/3600)*RADS;
        p.O = ( 49.57854 - 1020.19*cy/3600)*RADS;
        p.w = (336.04084 + 1560.78*cy/3600)*RADS;
        p.L = mod2pi((355.45332 + 68905103.78*cy/3600)*RADS);
        break;
    case 4: // Jupiter
        p.a = 5.20336301 + 0.00060737*cy;
        p.e = 0.04839266 - 0.00012880*cy;
        p.i = (  1.30530 -    4.15*cy/3600)*RADS;
        p.O = (100.55615 + 1217.17*cy/3600)*RADS;
        p.w = ( 14.75385 +  839.93*cy/3600)*RADS;
        p.L = mod2pi((34.40438 + 10925078.35*cy/3600)*RADS);
        break;
    case 5: // Saturn
        p.a = 9.53707032 - 0.00301530*cy;
        p.e = 0.05415060 - 0.00036762*cy;
        p.i = (  2.48446 +    6.11*cy/3600)*RADS;
        p.O = (113.71504 - 1591.05*cy/3600)*RADS;
        p.w = ( 92.43194 - 1948.89*cy/3600)*RADS;
        p.L = mod2pi((49.94432 + 4401052.95*cy/3600)*RADS);
        break;
    case 6: // Uranus
        p.a = 19.19126393 + 0.00152025*cy;
        p.e =  0.04716771 - 0.00019150*cy;
        p.i = (  0.76986  -    2.09*cy/3600)*RADS;
        p.O = ( 74.22988  - 1681.40*cy/3600)*RADS;
        p.w = (170.96424  + 1312.56*cy/3600)*RADS;
        p.L = mod2pi((313.23218 + 1542547.79*cy/3600)*RADS);
        break;
    case 7: // Neptune
        p.a = 30.06896348 - 0.00125196*cy;
        p.e =  0.00858587 + 0.00002510*cy;
        p.i = (  1.76917  -   3.64*cy/3600)*RADS;
        p.O = (131.72169  - 151.25*cy/3600)*RADS;
        p.w = ( 44.97135  - 844.43*cy/3600)*RADS;
        p.L = mod2pi((304.88003 + 786449.21*cy/3600)*RADS);
        break;
    case 8: // Pluto
        p.a = 39.48168677 - 0.00076912*cy;
        p.e =  0.24880766 + 0.00006465*cy;
        p.i = ( 17.14175  +  11.07*cy/3600)*RADS;
        p.O = (110.30347  -  37.33*cy/3600)*RADS;
        p.w = (224.06676  - 132.25*cy/3600)*RADS;
        p.L = mod2pi((238.92881 + 522747.90*cy/3600)*RADS);
        break;
    default:
        window.alert("function mean_elements() failed!");
    }
}

// return an angle in the range 0 to 2pi radians
function mod2pi( x )
{
    var b = x/(2*Math.PI);
    var a = (2*Math.PI)*(b - abs_floor(b));
    if (a < 0) a = (2*Math.PI) + a;
    return a;
}
// return the integer part of a number
function abs_floor( x )
{
    var r;
    if (x >= 0.0) r = Math.floor(x);
    else          r = Math.ceil(x);
    return r;
}

// compute the true anomaly from mean anomaly using iteration
//  M - mean anomaly in radians
//  e - orbit eccentricity
function true_anomaly( M, e )
{
    var V, E1;

    // initial approximation of eccentric anomaly
    var E = M + e*Math.sin(M)*(1.0 + e*Math.cos(M));

    do                                   // iterate to improve accuracy
    {
        E1 = E;
        E = E1 - (E1 - e*Math.sin(E1) - M)/(1 - e*Math.cos(E1));
    }
    while (Math.abs( E - E1 ) > EPS);

    // convert eccentric anomaly to true anomaly
    V = 2*Math.atan(Math.sqrt((1 + e)/(1 - e))*Math.tan(0.5*E));

    if (V < 0) V = V + (2*Math.PI);      // modulo 2pi

    return V;
}





/*
var p, zxc;
for (p = 0; p < 9; p++)
{
    zxc = get_coord(p, dn)
    // console.log(pname[p], zxc.mp, zxc.vp, zxc.rp,  zxc.xh, zxc.yh, zxc.zh )
    // console.log(zxc.a, zxc.e, zxc.i, zxc.O, zxc.w, zxc.L )
    console.log(pname[p], zxc.x+"\t"+zxc.y )
}
// */
