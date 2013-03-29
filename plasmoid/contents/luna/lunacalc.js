/***************************************************************************
 *   Copyright 1998,2000  Stephan Kulow <coolo@kde.org>                    *
 *   Copyright 2008 by Davide Bettio <davide.bettio@kdemail.net>           *
 *   Copyright 2009, 2011, 2012 by Glad Deschrijver                        *
 *      <glad.deschrijver@gmail.com>                                       *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.  *
 ***************************************************************************/

function getLunation(time)
{
    var next_new // = new Date(0);

	// obtain reasonable start value for lunation so that the while loop below has a minimal amount of iterations (for faster startup of the plasmoid)
	var reference = 947178885000; // number of milliseconds between 1970-01-01 00:00:00 and 2000-01-06 18:14:45 (first new moon of 2000, see lunation in phases.js)
	var lunationDuration = 2551442877; // number of milliseconds in 29.530588853 days (average lunation duration, same number as in phases.js)
//	var lunationDuration = 2583360000; // number of milliseconds in 29.9 days (maximum lunation duration, see wikipedia on synodic month); use this if the bug ever appears that the lunar phases displayed at startup are too much in the future
	var lunation = Math.floor((time.getTime() - reference) / lunationDuration);

	do {
		var JDE = Phases.moonphasebylunation(lunation, 0);
		next_new = Phases.JDtoDate(JDE);
		lunation++;
	} while (next_new < time);

	lunation -= 2;
	return lunation;
}

function getPhasesByLunation(lunation)
{
	var phases = new Array();
	phases[0] = Phases.JDtoDate(Phases.moonphasebylunation(lunation, 0)); // new moon
	phases[1] = Phases.JDtoDate(Phases.moonphasebylunation(lunation, 1)); // first quarter
	phases[2] = Phases.JDtoDate(Phases.moonphasebylunation(lunation, 2)); // full moon
	phases[3] = Phases.JDtoDate(Phases.moonphasebylunation(lunation, 3)); // last quarter
	phases[4] = Phases.JDtoDate(Phases.moonphasebylunation(lunation+1, 0)); // next new moon
	return phases;
}

function getTodayPhases(today)
{
    if(!today) today = new Date();
    var lunation = getLunation(today);
    var phases = getPhasesByLunation(lunation);
    return getCurrentPhase(phases, today);
}

function getCurrentPhase(phases, today)
{
	var oneDay = 1000 * 60 * 60 * 24;
    if(!today) today = new Date().getTime();

	// set time for all phases to 00:00:00 in order to obtain the correct phase for today (these changes should be local)
	for (var i = 0; i < 5; i++) {
		phases[i].setHours(0);
		phases[i].setMinutes(0);
		phases[i].setSeconds(0);
	}

	// days from last new
	var phaseNumber = Math.floor((today - phases[0].getTime()) / oneDay);

	var daysFromFullMoon = Math.floor((today - phases[2].getTime()) / oneDay);
	if (daysFromFullMoon == 0)
		phaseNumber = 14;
	else if (phaseNumber <= 15 && phaseNumber >= 13)
		phaseNumber = 14 + daysFromFullMoon;

	var daysFromFirstQuarter = Math.floor((today - phases[1].getTime()) / oneDay);
	if (daysFromFirstQuarter == 0)
		phaseNumber = 7;
	else if (phaseNumber <= 8 && phaseNumber >= 6)
		phaseNumber = 7 + daysFromFirstQuarter;

	var daysFromLastNew = Math.floor((today - phases[0].getTime()) / oneDay);
	if (daysFromLastNew == 0)
		phaseNumber = 0;
	else if (daysFromLastNew <= 1 || daysFromLastNew >= 28) {
		phaseNumber = (29 + daysFromLastNew) % 29;
        var daysToNextNew = -Math.floor((today - phases[4].getTime()) / oneDay);
		if (daysToNextNew == 0)
			phaseNumber = 0;
		else if (daysToNextNew < 3)
			phaseNumber = 29 - daysToNextNew;
	}

	var daysFromThirdQuarter = Math.floor((today - phases[3].getTime()) / oneDay);
	if (daysFromThirdQuarter == 0)
		phaseNumber = 21;
	else if (phaseNumber <= 22 && phaseNumber >= 20)
		phaseNumber = 21 + daysFromThirdQuarter;

	return phaseNumber;
}
