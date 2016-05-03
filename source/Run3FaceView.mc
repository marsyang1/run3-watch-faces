using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

class Run3FaceView extends Ui.WatchFace {

    var font;
    var width;
    var height;
    var xCenter;
    var vCenter;
    var startX;
    var startY;
    var cubeSize;
	var cubeStartX;
    var cubeStartY;
    var cubeCenterX;
    var cubeCenterY;
	var outerCircleRadius;
    var innerCircleRadius;

    hidden var EmptyBattery;
    hidden var AlmostEmpty;
    hidden var TwentyFivePercentBattery;
    hidden var FiftyPercentBattery;
    hidden var SeventyFivePercentBattery;
    hidden var AlmostFull;
    hidden var FullBattery;
    
    hidden var bg;

    function initialize() {
        WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        //Load bitmap
        EmptyBattery = Ui.loadResource(Rez.Drawables.EmptyBattery);
        AlmostEmpty = Ui.loadResource(Rez.Drawables.AlmostEmpty);
        TwentyFivePercentBattery = Ui.loadResource(Rez.Drawables.TwentyFivePercentBattery);
        FiftyPercentBattery = Ui.loadResource(Rez.Drawables.FiftyPercentBattery);
        SeventyFivePercentBattery = Ui.loadResource(Rez.Drawables.SeventyFivePercentBattery);
        AlmostFull = Ui.loadResource(Rez.Drawables.AlmostFull);
        FullBattery = Ui.loadResource(Rez.Drawables.FullBattery);
        FullBattery = Ui.loadResource(Rez.Drawables.FullBattery);
        
        bg = Ui.loadResource(Rez.Drawables.Logo);
        
        width = dc.getWidth();
    	height = dc.getHeight();
    	xCenter = width/2;
    	vCenter = height/2;
    	font = Ui.loadResource(Rez.Fonts.id_font_black_diamond);
    	calAxis(dc);
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        drawBackground(dc);
    
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (App.getApp().getProperty("UseMiflitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel");
        view.setColor(App.getApp().getProperty("ForegroundColor"));
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        
        drawBattery(dc,width,height);   
        
        var info = Calendar.info(Time.now(), Time.FORMAT_LONG);
        var timeStr = Lang.format("$1$:$2$", [info.hour, info.min]);
        var dateStr = Lang.format("$1$ $2$", [info.month, info.day]);
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xCenter,vCenter+10, Gfx.FONT_SMALL, timeStr, Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(xCenter,vCenter-10, Gfx.FONT_LARGE, dateStr, Gfx.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xCenter,0,font,"12",Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width,vCenter,font,"3", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(xCenter,height-30,font,"6", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(0,vCenter,font,"9",Gfx.TEXT_JUSTIFY_LEFT);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    
    }
    
    function drawBackground(dc){
      dc.drawBitmap(Ui.LAYOUT_HALIGN_CENTER , vCenter-50, bg);
    }
    
    function drawBattery(dc,width,height){
    	var systemStats = Sys.getSystemStats();
        var batteryLevel = systemStats.battery;
		
		if (batteryLevel >= 1.0 and batteryLevel < 5.0) {
			dc.drawBitmap(width/2-30, height/2-10, EmptyBattery);
		} else if(batteryLevel >= 5.0 and batteryLevel < 14.0) {
			dc.drawBitmap(width/2-30, height/2-10, AlmostEmpty);
		} else if (batteryLevel >= 14.0 and batteryLevel < 28.0) {
			dc.drawBitmap(width/2-30, height/2-10, TwentyFivePercentBattery);
		} else if (batteryLevel >= 28.0 and batteryLevel < 42.0) {
			dc.drawBitmap(width/2-30, height/2-10, TwentyFivePercentBattery);
		} else if (batteryLevel >= 42.0 and batteryLevel < 56.0) {
			dc.drawBitmap(width/2-30, height/2-10, FiftyPercentBattery);
		} else if (batteryLevel >= 56.0 and batteryLevel < 70.0) {
			dc.drawBitmap(width/2-30, height/2-10, FiftyPercentBattery);
		} else if (batteryLevel >= 70.0 and batteryLevel < 84.0) {
			dc.drawBitmap(width/2-30, height/2-10, SeventyFivePercentBattery);
		} else if (batteryLevel >= 84.0 and batteryLevel < 98.0) {
			dc.drawBitmap(width/2-30, height/2-10, AlmostFull);
		} else if(batteryLevel >= 98.0) {
			dc.drawBitmap(width/2-30, height/2-10, FullBattery);
		}
    }
    
    function calAxis(dc){
            width = dc.getWidth();
	        height = dc.getHeight();
	
	        // center the cube as much as possible, with a 3% buffer around the edges
	        if (width < height) {
	        	startX = 0;
	        	startY = (height - width) / 2;
	        	cubeSize = width * 0.94;
	        } else {
	        	startX = (width - height) / 2;
	        	startY = 0;
	        	cubeSize = height * 0.94;
	        }
	        
	        cubeStartX = startX + (0.03 * cubeSize);
	        cubeStartY = startY + (0.03 * cubeSize);
	        
	        cubeCenterX = cubeStartX + (0.5 * cubeSize);
	        cubeCenterY = cubeStartY + (0.5 * cubeSize);
	
			outerCircleRadius = 0.375 * cubeSize;
	        innerCircleRadius = 0.40 * outerCircleRadius;
    }
}
