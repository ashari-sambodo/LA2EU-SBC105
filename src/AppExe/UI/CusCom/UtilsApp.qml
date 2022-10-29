/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

QtObject {
    function strfSecsToMMSS(seconds){
        let min = Math.floor(seconds / 60)
        if(min < 10) min = "0" + min
        let sec = seconds % 60
        if(sec < 10) sec = "0" + sec
        return min+":"+sec
    }

    function strfSecsToHHMMSS(seconds){
        let hour = Math.floor(seconds / 3600)
        if(hour < 10) hour = "0" + hour
        let min = Math.floor((seconds / 60) % 60)
        if(min < 10) min = "0" + min
        let sec = seconds % 60
        if(sec < 10) sec = "0" + sec
        return hour + ":"+ min + ":" + sec
    }

    function strfSecsToAdaptiveHHMMSS(seconds){
        let result = ""
        if(seconds >= 3600){
            let hour = Math.floor(seconds / 3600)
            if(hour < 10) hour = "0" + hour
            result = hour + ":"
        }
        if (seconds >= 60){
            let min = Math.floor((seconds / 60) % 60)
            if(min < 10) min = "0" + min
            result = result + min  + ":"
        }
        let sec = seconds % 60
        if(sec < 10) sec = "0" + sec
        return result + sec
    }

    function strfMinToHumanReadableShort(minute){
        let hourStr = ""
        if(Math.floor(minute / 60)){
            let hour = Math.floor(minute / 60)
            hourStr = hour + " hours"
        }

        let minuteStr = ""
        if (Math.floor(minute % 60)){
            let min = Math.floor(minute % 60)
            minuteStr = min + " min"
        }

        let result = [hourStr, minuteStr].filter(Boolean).join(" ")
        if (result.length === 0) result = "0 min"

        return result
    }

    function strfSecsToHumanReadableShort(seconds){
        let hourStr = ""
        if(Math.floor(seconds / 3600)){
            let hour = Math.floor(seconds / 3600)
            hourStr = hour + " hours"
        }

        let minuteStr = ""
        if (Math.floor((seconds / 60) % 60)){
            let min = Math.floor((seconds / 60) % 60)
            minuteStr = min + " min"
        }

        let secStr = ""
        let sec = seconds % 60
        if(sec) {
            secStr = sec + " sec"
        }

        let result = [hourStr, minuteStr, secStr].filter(Boolean).join(" ")
        if (result.length === 0) result = "0 sec"

        return result
    }

    function strfSecsToHumanReadable(seconds){
        let hourStr = ""
        if(seconds >= 3600){
            let hour = Math.floor(seconds / 3600)
            if(hour > 1) {
                hourStr = hour + " hours"
            }
            else if (hour === 1) {
                hourStr = hour + " hour"
            }
        }

        let minuteStr = ""
        if (seconds >= 60){
            let min = Math.floor((seconds / 60) % 60)
            if(min > 1) {
                minuteStr = min + " minutes"
            }
            else if (min === 1) {
                minuteStr = min + " minute"
            }
        }

        let secStr = ""
        let sec = seconds % 60
        if(sec) {
            if(sec > 1) {
                secStr = sec + " seconds"
            }
            else if (sec === 1) {
                secStr = sec + " second"
            }
        }

        let result = [hourStr, minuteStr, secStr].filter(Boolean).join(" ")
        if (result.length === 0) result = "0 second"

        return result
    }

    function formatClockHourMinuteToMinutes(hour, minutes, period, periodMode){
        if (periodMode === 12) {
            //            hour = hour + 1
            if (period === "PM") {
                /// PM
                if(hour !== 12) {
                    hour = hour + 12
                }
            } else {
                /// AM
                if (hour === 12){
                    hour = hour - 12
                }
            }
        }
        return (hour * 60) + minutes
    }

    function formatMinutesToClockHourMinuteFormat(minutes, periodMode){
        //        console.log(minutes)
        let hour = Math.floor(minutes / 60)
        //        console.log(hour)
        let minute = Math.floor(minutes % 60)
        //        console.log(minute)
        var ampm = ""

        if(periodMode === 12){
            if(hour >= 12){
                ampm = " PM"
                if(hour > 12) hour = (hour - 12)
            }
            else {
                if (hour === 0) {
                    hour = 12
                }
                ampm = " AM"
            }
        }
        ////console.debug("ampm:", ampm)
        if (hour < 10) hour = "0" + hour
        if (minute < 10) minute = "0" + minute

        return hour + ":" + minute + ampm
    }

    function combineTimeToSeconds(hours, minutes, seconds){
        return (hours * 3600) + (minutes * 60) + seconds
    }

    function getPercentOf(value, ref){
        return Math.round((value / ref) * 100)
    }

    function strfTemperature(corf, temperature, decimal){
        const dec = decimal || 0
        return corf ? temperature.toFixed(dec) + " °F" : temperature.toFixed(dec) + " °C"
    }

    function toFixedFloat(value, fixedTarget){
        const helperNumber = Math.pow(10, fixedTarget)
        return Math.round(value * helperNumber) / helperNumber
    }

    function interpolation(a, b, x1, y1, x2, y2){
        return a - ((x2 - x1) / (y2 - y1) * (b - y1))
    }

    function urlToPath(urlString) {
        var s
        if (urlString.startsWith("file:///")) {
            var k = urlString.charAt(9) === ":" ? 8 : 7
            s = urlString.substring(k)
        } else {
            s = urlString
        }
        return s
    }

    function getMpsFromFpm(fpm){
        return Math.round(fpm * 0.508)/100
    }
    function getFpmFromMps(mps){
        return Math.round(mps * 196.85)
    }

    function strfVelocityByUnit(meaUnit, value){
        if(meaUnit) return value.toFixed() + " fpm"
        else return value.toFixed(2) + " m/s"
    }

    function fixStrLength(dataStr, validLength, val, preappend) {
        const diffLength = dataStr.length - validLength;

        if(diffLength < 0) {
            for(let i=0; i<Math.abs(diffLength); i++){
                if (preappend === 1){
                    dataStr = val + dataStr
                }
                else {
                    dataStr = dataStr + val
                }
            }
        }

        else if(diffLength > 0) {
            for(let i=0; i<Math.abs(diffLength); i++){
                if (preappend === 1){
                    dataStr = dataStr.slice(1)
                }
                else {
                    dataStr = dataStr.slice(0,-1)
                }
            }
        }

        return dataStr
    }

    function celciusToFahrenheit(value){
        return Math.round((value * 9/5) + 32)
    }

    function fahrenheitToCelcius(value){
        return Math.round((value - 32) * 5/9)
    }

    function map(x,in_min, in_max, out_min, out_max){
        return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    }

    function getFanDucyStrf(ducy){
        return Number(ducy/10).toFixed(1)
    }
}
