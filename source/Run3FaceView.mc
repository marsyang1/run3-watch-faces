using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

class Run3FaceView extends Ui.WatchFace {

    var font;
    var digiFont;
    var width;
    var height;
    var xCenter;
    var yCenter;
    
    var deviceSetting;

    hidden var EmptyBattery;
    hidden var AlmostEmpty;
    hidden var TwentyFivePercentBattery;
    hidden var FiftyPercentBattery;
    hidden var SeventyFivePercentBattery;
    hidden var AlmostFull;
    hidden var FullBattery;
    
    var bg;
    var blueTooth;

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
        
        bg = Ui.loadResource(Rez.Drawables.Logo);
        blueTooth = Ui.loadResource(Rez.Drawables.BlueTooth);
    	
    	font = Ui.loadResource(Rez.Fonts.id_font_black_diamond);
    	digiFont = Ui.loadResource(Rez.Fonts.id_font_open_sans);
    	calAxis(dc);
    }
    
    function calAxis(dc){
            width = dc.getWidth();
	        height = dc.getHeight();
	        xCenter = width/2;
    		yCenter = height/2;
	
	        Sys.println("width = " + width);
            Sys.println("height = " + height);
            Sys.println("xCenter = " + xCenter);
            Sys.println("yCenter = " + yCenter);
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        
        drawBackground(dc);
        drawBlueTooth(dc);
        drawBattery(dc,width,height);

        var info = Calendar.info(Time.now(), Time.FORMAT_LONG);
        drawCalendar(dc,info);     
        drawTime(dc,info);
        //drawPoint(dc);
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
      var bgWidth = bg.getWidth();
      //Sys.println("bgWidth =" + bgWidth);
      dc.drawBitmap(xCenter - (bgWidth/2)+5 , yCenter-80, bg);
    }
    
    function drawBlueTooth(dc){
      deviceSetting = Sys.getDeviceSettings();
      if( deviceSetting.phoneConnected == true) {
          dc.drawBitmap(xCenter+50, yCenter+40, blueTooth);
      } 
    }
    
    function drawBattery(dc,width,height){
    	var systemStats = Sys.getSystemStats();
        var batteryLevel = systemStats.battery;
        var batteryLocX = xCenter-65;
        var batteryLocY = yCenter+43;
		
		if (batteryLevel >= 1.0 and batteryLevel < 5.0) {
			dc.drawBitmap(batteryLocX, batteryLocY, EmptyBattery);
		} else if(batteryLevel >= 5.0 and batteryLevel < 14.0) {
			dc.drawBitmap(batteryLocX, batteryLocY, AlmostEmpty);
		} else if (batteryLevel >= 14.0 and batteryLevel < 28.0) {
			dc.drawBitmap(batteryLocX, batteryLocY, TwentyFivePercentBattery);
		} else if (batteryLevel >= 28.0 and batteryLevel < 42.0) {
			dc.drawBitmap(batteryLocX, batteryLocY, TwentyFivePercentBattery);
		} else if (batteryLevel >= 42.0 and batteryLevel < 56.0) {
			dc.drawBitmap(batteryLocX, batteryLocY, FiftyPercentBattery);
		} else if (batteryLevel >= 56.0 and batteryLevel < 70.0) {
			dc.drawBitmap(batteryLocX, batteryLocY, FiftyPercentBattery);
		} else if (batteryLevel >= 70.0 and batteryLevel < 84.0) {
			dc.drawBitmap(batteryLocX, batteryLocY, SeventyFivePercentBattery);
		} else if (batteryLevel >= 84.0 and batteryLevel < 98.0) {
			dc.drawBitmap(batteryLocX, batteryLocY, AlmostFull);
		} else if(batteryLevel >= 98.0) {
			dc.drawBitmap(batteryLocX, batteryLocY, FullBattery);
		}
    }
    
    function drawTime(dc,info){
        var timeStr = Lang.format("$1$:$2$", [info.hour.format("%02d"), info.min.format("%02d")]);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xCenter,yCenter-50, digiFont , timeStr, Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    function drawCalendar(dc,info){
        var dateStr = Lang.format("$1$ $2$", [info.month, info.day.format("%02d")]);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xCenter,yCenter+35, Gfx.FONT_LARGE , dateStr, Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    function drawPoint(dc){
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xCenter,0,font,"12",Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(width,yCenter,font,"3", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(xCenter,height-30,font,"6", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(0,yCenter,font,"9",Gfx.TEXT_JUSTIFY_LEFT);
    }
    
}
