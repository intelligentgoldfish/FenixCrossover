using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.ActivityMonitor;
using Toybox.Time.Gregorian;
using Toybox.Math;


class FenixCrossoverView extends WatchUi.WatchFace {

    const CX = 88;
    const CY = 88;

    const RING_RADIUS = 26;

    const STEPS_X = CX - 30;
    const STEPS_Y = CY - 52;

    const BAT_X = CX - 60;
    const BAT_Y = CY;

    const SOLAR_X = CX - 30;
    const SOLAR_Y = CY + 52;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
    }

    function onUpdate(dc) {

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_BLACK
        );

        dc.clear();

        var now = System.getClockTime();

        drawSteps(dc);
        drawBattery(dc);
        drawSolar(dc);

        drawSunEvent(dc);
        drawTime(dc, now);
        drawDate(dc);

    }

    function drawSteps(dc) {

        var info = ActivityMonitor.getInfo();

        var steps = info.steps;

        var goal = 8260;

        var progress = steps.toFloat() / goal;

        if (progress > 1.0) {
            progress = 1.0;
        }

        drawRing(
            dc,
            STEPS_X,
            STEPS_Y,
            progress
        );

        drawStepsIcon(dc, STEPS_X, STEPS_Y - 8);

//        dc.drawText(
//            STEPS_X,
//            STEPS_Y + 6,
//            Graphics.FONT_XTINY,
//            steps.toString(),
//            Graphics.TEXT_JUSTIFY_CENTER
//        );
    }

    function drawBattery(dc) {

        var battery = System.getSystemStats().battery;

        var progress = battery.toFloat() / 100;

        drawRing(
            dc,
            BAT_X,
            BAT_Y,
            progress
        );

        drawBatteryIcon(dc, BAT_X, BAT_Y - 8);

        dc.drawText(
            BAT_X,
            BAT_Y + 6,
            Graphics.FONT_XTINY,
            battery.toString(),
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function drawSolar(dc) {

        // Placeholder until exact solar API identified

        var solar = 75;

        drawRing(
            dc,
            SOLAR_X,
            SOLAR_Y,
            solar / 100.0
        );

        drawSolarIcon(dc, SOLAR_X, SOLAR_Y - 8);

        dc.drawText(
            SOLAR_X,
            SOLAR_Y + 6,
            Graphics.FONT_XTINY,
            solar.toString(),
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function drawTime(dc, now) {

        var hh = now.hour.format("%02d");
        var mm = now.min.format("%02d");

        var txt = hh + ":" + mm;

        dc.drawText(
            CX + 34,
            CY - 6,
            Graphics.FONT_NUMBER_MEDIUM,
            txt,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function drawDate(dc) {

        var m = Gregorian.info(
            Time.now(),
            Time.FORMAT_SHORT
        );

        var months = [
            "JAN","FEB","MAR",
            "APR","MAY","JUN",
            "JUL","AUG","SEP",
            "OCT","NOV","DEC"
        ];

        var txt =
            months[m.month - 1] +
            " " +
            m.day.toString();

        dc.drawText(
            CX + 34,
            CY + 24,
            Graphics.FONT_SMALL,
            txt,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function drawSunEvent(dc) {

        drawSunIcon(
            dc,
            CX + 10,
            CY - 48
        );

        dc.drawText(
            CX + 40,
            CY - 48,
            Graphics.FONT_SMALL,
            "20:52",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function drawRing(dc, x, y, progress) {

        dc.drawCircle(
            x,
            y,
            RING_RADIUS
        );

        var segments = 24;

        var active =
            (segments * progress).toNumber();

        for (var i = 0; i < active; i++) {

            var angle =
                (2.0 * Math.PI * i)
                / segments;

            var px =
                x +
                ((RING_RADIUS - 2)
                * Math.sin(angle));

            var py =
                y -
                ((RING_RADIUS - 2)
                * Math.cos(angle));

            dc.fillCircle(
                px,
                py,
                2
            );
        }
    }

    function drawStepsIcon(dc, x, y) {

        dc.fillCircle(x - 3, y, 1);
        dc.fillCircle(x + 2, y + 2, 1);

        dc.drawLine(
            x - 3,
            y + 1,
            x - 1,
            y + 4
        );

        dc.drawLine(
            x + 2,
            y + 3,
            x + 4,
            y + 6
        );
    }

    function drawBatteryIcon(dc, x, y) {

        dc.drawRectangle(
            x - 5,
            y,
            10,
            5
        );

        dc.fillRectangle(
            x + 5,
            y + 1,
            1,
            3
        );
    }

    function drawSolarIcon(dc, x, y) {

        dc.drawCircle(
            x,
            y + 2,
            2
        );

        dc.drawLine(x, y - 3, x, y - 1);
        dc.drawLine(x, y + 5, x, y + 7);

        dc.drawLine(x - 5, y + 2, x - 3, y + 2);
        dc.drawLine(x + 3, y + 2, x + 5, y + 2);
    }

    function drawSunIcon(dc, x, y) {

        dc.drawCircle(
            x,
            y,
            3
        );

        dc.drawLine(x, y - 6, x, y - 4);
        dc.drawLine(x, y + 4, x, y + 6);

        dc.drawLine(x - 6, y, x - 4, y);
        dc.drawLine(x + 4, y, x + 6, y);
    }
}