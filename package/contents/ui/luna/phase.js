//Script from http://mysite.verizon.net/res148h4j/javascript/script_moon_phase.html

.pragma library

var f0 = parseFloat( "0.0" );
var n0 = parseInt( "0" );


var AGE = f0;   // Moon's age
var DIS = f0;   // Moon's distance in earth radii
var LAT = f0;   // Moon's ecliptic latitude
var LON = f0;   // Moon's ecliptic longitude
var Phase = " ";
var Zodiac = " ";
var A = 0

// compute moon position and phase
function touch( YMD )
{
    var YY = n0;
    var MM = n0;
    var K1 = n0;
    var K2 = n0;
    var K3 = n0;
    var JD = n0;
    var IP = f0;
    var DP = f0;
    var NP = f0;
    var RP = f0;

    if(!YMD) YMD = new Date();

    var Y = YMD.getFullYear();
    var M = YMD.getMonth()+1;
    var D = YMD.getDate();

    // calculate the Julian date at 12h UT
    YY = Y - Math.floor( ( 12 - M ) / 10 );
    MM = M + 9;
    if( MM >= 12 ) MM = MM - 12;

    K1 = Math.floor( 365.25 * ( YY + 4712 ) );
    K2 = Math.floor( 30.6 * MM + 0.5 );
    K3 = Math.floor( Math.floor( ( YY / 100 ) + 49 ) * 0.75 ) - 38;

    JD = K1 + K2 + D + 59;                  // for dates in Julian calendar
    if( JD > 2299160 ) JD = JD - K3;        // for Gregorian calendar

    // calculate moon's age in days
    IP = normalize( ( JD - 2451550.1 ) / 29.530588853 );
    AGE = IP*29.53;

    if(      AGE <  1.84566 ) Phase = "NEW";
    else if( AGE <  5.53699 ) Phase = "Evening crescent";
    else if( AGE <  9.22831 ) Phase = "First quarter";
    else if( AGE < 12.91963 ) Phase = "Waxing gibbous";
    else if( AGE < 16.61096 ) Phase = "FULL";
    else if( AGE < 20.30228 ) Phase = "Waning gibbous";
    else if( AGE < 23.99361 ) Phase = "Last quarter";
    else if( AGE < 27.68493 ) Phase = "Morning crescent";
    else                      Phase = "NEW";

    IP = IP*2*Math.PI;                      // Convert phase to radians

    // calculate moon's distance
    DP = 2*Math.PI*normalize( ( JD - 2451562.2 ) / 27.55454988 );
    DIS = 60.4 - 3.3*Math.cos( DP ) - 0.6*Math.cos( 2*IP - DP ) - 0.5*Math.cos( 2*IP );

    // calculate moon's ecliptic latitude
    NP = 2*Math.PI*normalize( ( JD - 2451565.2 ) / 27.212220817 );
    LAT = 5.1*Math.sin( NP );

    // calculate moon's ecliptic longitude
    RP = normalize( ( JD - 2451555.8 ) / 27.321582241 );
    LON = 360*RP + 6.3*Math.sin( DP ) + 1.3*Math.sin( 2*IP - DP ) + 0.7*Math.sin( 2*IP );

    if(      LON <  33.18 ) Zodiac = "Pisces";
    else if( LON <  51.16 ) Zodiac = "Aries";
    else if( LON <  93.44 ) Zodiac = "Taurus";
    else if( LON < 119.48 ) Zodiac = "Gemini";
    else if( LON < 135.30 ) Zodiac = "Cancer";
    else if( LON < 173.34 ) Zodiac = "Leo";
    else if( LON < 224.17 ) Zodiac = "Virgo";
    else if( LON < 242.57 ) Zodiac = "Libra";
    else if( LON < 271.26 ) Zodiac = "Scorpio";
    else if( LON < 302.49 ) Zodiac = "Sagittarius";
    else if( LON < 311.72 ) Zodiac = "Capricorn";
    else if( LON < 348.58 ) Zodiac = "Aquarius";
    else                    Zodiac = "Pisces";

    // so longitude is not greater than 360!
    if ( LON > 360 ) LON = LON - 360;
}


// normalize values to range 0...1
function normalize( v )
{
    v = v - Math.floor( v  );
    if( v < 0 )
        v = v + 1;

    return v;
}

// round to 2 decimal places
function round2( x )
{
    return ( Math.round( 100*x )/100.0 );
}
