// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.controls {	

	import fl.controls.BaseButton;
	import fl.controls.LabelButton;
	import fl.controls.ScrollBarDirection;
	import fl.core.UIComponent;
	import fl.core.InvalidationType;
	import fl.events.ComponentEvent;
	import fl.events.ScrollEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import fl.controls.TextInput;
	

    //--------------------------------------
    //  Events
    //--------------------------------------
	/**
     * Dispatched when the ScrollBar instance's <code>scrollPosition</code> property changes. 
	 *
     * @eventType fl.events.ScrollEvent.SCROLL
     *
     * @see #scrollPosition
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 *  
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	[Event(name="scroll", type="fl.events.ScrollEvent") ]
	

    //--------------------------------------
    //  Styles
    //--------------------------------------	
	/**
     * Name of the class to use as the skin for the down arrow button of the scroll bar 
     * when it is disabled. If you change the skin, either graphically or programmatically, 
     * you should ensure that the new skin is the same height (for horizontal scroll bars)
     * or width (for vertical scroll bars) as the track.
     *
     * @default ScrollArrowDown_disabledSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="downArrowDisabledSkin", type="Class")]

    /**
     * Name of the class to use as the skin for the down arrow button of the scroll bar 
     * when you click the arrow button. If you change the skin, either graphically or 
     * programmatically, you should ensure that the new skin is the same height (for 
     * horizontal scroll bars) or width (for vertical scroll bars) as the track.
     *
     * @default ScrollArrowDown_downSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="downArrowDownSkin", type="Class")]

    /**
     * Name of the class to use as the skin for the down arrow button of the scroll bar 
     * when the mouse pointer is over the arrow button. If you change the skin, either 
     * graphically or programmatically, you should ensure that the new skin is the same 
     * height (for horizontal scroll bars) or width (for vertical scroll bars) as the track.
     *
     * @default ScrollArrowDown_overSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="downArrowOverSkin", type="Class")]

    /**
     * Name of the class to use as the skin for the down arrow button of the scroll bar. 
     * If you change the skin, either graphically or programmatically, you should ensure 
     * that the new skin is the same height (for horizontal scroll bars) or width (for 
     * vertical scroll bars) as the track.
     *
     * @default ScrollArrowDown_upSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="downArrowUpSkin", type="Class")]

    /**
     * The skin that is used to indicate the disabled state of the thumb.
     *
     * @default ScrollThumb_disabledSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="thumbDisabledSkin", type="Class")]

    /**
     * Name of the class to use as the skin for the thumb of the scroll bar when you 
     * click the thumb.
     *
     * @default ScrollThumb_downSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="thumbDownSkin", type="Class")]

    /**
     * Name of the class to use as the skin for the thumb of the scroll bar when the 
     * mouse pointer is over the thumb.
     *
     * @default ScrollThumb_overSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="thumbOverSkin", type="Class")]

    /**
     * Name of the class to use as the skin used for the thumb of the scroll
	 * bar.
     *
     * @default ScrollThumb_upSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="thumbUpSkin", type="Class")]

    /**
     * The skin that is used to indicate a disabled track.
     *
     * @default ScrollTrack_Skin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="trackDisabledSkin", type="Class")]

    /**
     * The skin that is used to indicate the down state of a disabled skin.
     *
     * @default ScrollTrack_Skin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="trackDownSkin", type="Class")]

    /**
     * The skin that is used to indicate the mouseover state for the scroll track.
     *
     * @default ScrollTrack_Skin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="trackOverSkin", type="Class")]

    /**
     * The skin used to indicate the mouse up state for the scroll track.
     *
     * @default ScrollTrack_Skin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="trackUpSkin", type="Class")]

    /**
     * Name of the class to use as the skin for the up arrow button of the scroll bar 
     * when it is disabled. If you change the skin, either graphically or programmatically, 
     * you should ensure that the new skin is the same height (for horizontal scroll bars) 
     * or width (for vertical scroll bars) as the track.
     *
     * @default ScrollArrowUp_disabledSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="upArrowDisabledSkin", type="Class")]

    /**
     * Name of the class to use as the skin for the up arrow button of the scroll bar when 
     * you click the arrow button. If you change the skin, either graphically or programmatically, 
     * you should ensure that the new skin is the same height (for horizontal scroll bars) or width 
     * (for vertical scroll bars) as the track.
     *
     * @default ScrollArrowUp_downSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="upArrowDownSkin", type="Class")]

    /**
     * Name of the class to use as the skin for the up arrow button of the scroll bar when the 
     * mouse pointer is over the arrow button. If you change the skin, either graphically or 
     * programmatically, you should ensure that the new skin is the same height (for horizontal 
     * scroll bars) or width (for vertical scroll bars) as the track.
     *
     * @default ScrollArrowUp_overSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="upArrowOverSkin", type="Class")]

    /**
     * Name of the class to use as the skin for the up arrow button of the scroll bar. If you 
     * change the skin, either graphically or programmatically, you should ensure that the new 
     * skin is the same height (for horizontal scroll bars) or width (for vertical scroll bars) 
     * as the track.
     *
     * @default ScrollArrowUp_upSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="upArrowUpSkin", type="Class")]

    /**
     * Name of the class to use as the icon for the thumb of the scroll bar.
     *
     * @default ScrollBar_thumbIcon
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="thumbIcon", type="Class")]

    /**
     * @copy fl.controls.BaseButton#style:repeatDelay
	 * 
     * @default 500
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="repeatDelay", type="Number", format="Time")]

    /**
     * @copy fl.controls.BaseButton#style:repeatInterval
	 * 
     * @default 35
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0
     *  @productversion Flash CS3
     */
    [Style(name="repeatInterval", type="Number", format="Time")]
	

    //--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The ScrollBar component provides the end user with a way to control the 
	 * portion of data that is displayed when there is too much data to 
	 * fit in the display area. The scroll bar consists of four parts: 
	 * two arrow buttons, a track, and a thumb. The position of the 
	 * thumb and display of the buttons depends on the current state of 
	 * the scroll bar. The scroll bar uses four parameters to calculate 
	 * its display state: a minimum range value; a maximum range value; 
	 * a current position that must be within the range values; and a 
	 * viewport size that must be equal to or less than the range and 
	 * represents the number of items in the range that can be 
     * displayed at the same time.
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 *  
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	public class ScrollBar extends UIComponent {
        /**
         * @private (internal)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public static const WIDTH:Number = 15;
	
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _pageSize:Number = 10;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _pageScrollSize:Number = 0;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _lineScrollSize:Number = 1;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _minScrollPosition:Number = 0;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _maxScrollPosition:Number = 0;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _scrollPosition:Number = 0;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var _direction:String = ScrollBarDirection.VERTICAL;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var thumbScrollOffset:Number;
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var inDrag:Boolean = false;
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var upArrow:BaseButton;
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var downArrow:BaseButton;
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var thumb:LabelButton;
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var track:BaseButton;
		
        // Note that there is currently no disabled state for thumb, 
		// and track only has one state.

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static var defaultStyles:Object = {downArrowDisabledSkin:"ScrollArrowDown_disabledSkin",downArrowDownSkin:"ScrollArrowDown_downSkin",downArrowOverSkin:"ScrollArrowDown_overSkin",downArrowUpSkin:"ScrollArrowDown_upSkin",
													 thumbDisabledSkin:"ScrollThumb_upSkin",thumbDownSkin:"ScrollThumb_downSkin",thumbOverSkin:"ScrollThumb_overSkin",thumbUpSkin:"ScrollThumb_upSkin",
													 trackDisabledSkin:"ScrollTrack_skin",trackDownSkin:"ScrollTrack_skin",trackOverSkin:"ScrollTrack_skin",trackUpSkin:"ScrollTrack_skin",
													 upArrowDisabledSkin:"ScrollArrowUp_disabledSkin",upArrowDownSkin:"ScrollArrowUp_downSkin",upArrowOverSkin:"ScrollArrowUp_overSkin",upArrowUpSkin:"ScrollArrowUp_upSkin",
													 thumbIcon:"ScrollBar_thumbIcon",
													 repeatDelay:500,repeatInterval:35};
        /**
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
         * @see fl.core.UIComponent#getStyle()
         * @see fl.core.UIComponent#setStyle()
         * @see fl.managers.StyleManager
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         *  
         *  @playerversion AIR 1.0
         *  @productversion Flash CS3
         */
		public static function getStyleDefinition():Object { 
			return defaultStyles;
		}
		
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected static const DOWN_ARROW_STYLES:Object = {
												disabledSkin:"downArrowDisabledSkin",
												downSkin:"downArrowDownSkin",
												overSkin:"downArrowOverSkin",
												upSkin:"downArrowUpSkin",
												repeatDelay:"repeatDelay",
												repeatInterval:"repeatInterval"
												};
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected static const THUMB_STYLES:Object = {
												disabledSkin:"thumbDisabledSkin",
												downSkin:"thumbDownSkin",
												overSkin:"thumbOverSkin",
												upSkin:"thumbUpSkin",
												icon:"thumbIcon",
												textPadding: 0
												};
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected static const TRACK_STYLES:Object = {
												disabledSkin:"trackDisabledSkin",
												downSkin:"trackDownSkin",
												overSkin:"trackOverSkin",
												upSkin:"trackUpSkin",
												repeatDelay:"repeatDelay",
												repeatInterval:"repeatInterval"
												};
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected static const UP_ARROW_STYLES:Object = {
												disabledSkin:"upArrowDisabledSkin",
												downSkin:"upArrowDownSkin",
												overSkin:"upArrowOverSkin",
												upSkin:"upArrowUpSkin",
												repeatDelay:"repeatDelay",
												repeatInterval:"repeatInterval"
												};
		
		
		/**
         * Creates a new ScrollBar component instance.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function ScrollBar() {
			super();
			setStyles();
			focusEnabled = false;
		}
		
		/**
         * @copy fl.core.UIComponent#setSize()
         *
         * @see #height
         * @see #width
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		override public function setSize(width:Number, height:Number):void {
			if (_direction == ScrollBarDirection.HORIZONTAL) {
				super.setSize(height,width);
			} else {
				super.setSize(width,height);
			}
		}
		
		/**
         * @copy fl.core.UIComponent#width
         *
         * @see #height
         * @see #setSize()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		override public function get width():Number {
			return (_direction == ScrollBarDirection.HORIZONTAL) ? super.height : super.width;
		}
		
		/**
         * @copy fl.core.UIComponent#height
         *
         * @see #setSize()
         * @see #width
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		override public function get height():Number {
			return (_direction == ScrollBarDirection.HORIZONTAL) ? super.width : super.height;
		}
		
		/**
         * Gets or sets a Boolean value that indicates whether the scroll bar is enabled.
		 * A value of <code>true</code> indicates that the scroll bar is enabled; a value of
		 * <code>false</code> indicates that it is not. 
         *
         * @default true
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		override public function get enabled():Boolean {
			return super.enabled;
		}
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function set enabled(value:Boolean):void {
			super.enabled = value;
			downArrow.enabled = track.enabled = thumb.enabled = upArrow.enabled = (enabled && _maxScrollPosition > _minScrollPosition);
			updateThumb();
		}
		
		/**
         * Sets the range and viewport size of the ScrollBar component. The ScrollBar 
         * component updates the state of the arrow buttons and size of the scroll 
         * thumb accordingly. All of the scroll properties are relative to the
		 * scale of the <code>minScrollPosition</code> and the <code>maxScrollPosition</code>.
		 * Each number between the maximum and minumum values represents one scroll position.
		 *
		 * @param pageSize Size of one page. Determines the size of the thumb, and the increment by which the scroll bar moves when the arrows are clicked.
 		 * @param minScrollPosition Bottom of the scrolling range.
		 * @param maxScrollPosition Top of the scrolling range.
		 * @param pageScrollSize Increment to move when a track is pressed, in pixels.
		 *
         * @see #maxScrollPosition
         * @see #minScrollPosition
         * @see #pageScrollSize
         * @see #pageSize
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function setScrollProperties(pageSize:Number,minScrollPosition:Number,maxScrollPosition:Number,pageScrollSize:Number=0):void {
			this.pageSize = pageSize;
			_minScrollPosition = minScrollPosition;
			_maxScrollPosition = maxScrollPosition;
			if (pageScrollSize >= 0) { _pageScrollSize = pageScrollSize; }
			enabled = (_maxScrollPosition > _minScrollPosition);
			// ensure our scroll position is still in range:
			setScrollPosition(_scrollPosition, false);
			updateThumb();
		}
		
		/**
		 * Gets or sets the current scroll position and updates the position 
         * of the thumb. The <code>scrollPosition</code> value represents a relative position between
		 * the <code>minScrollPosition</code> and <code>maxScrollPosition</code> values.
         *
         * @default 0
         *
         * @see #setScrollProperties()
         * @see #minScrollPosition
		 * @see #maxScrollPosition
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get scrollPosition():Number { return _scrollPosition; }
		
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set scrollPosition(newScrollPosition:Number):void {
			setScrollPosition(newScrollPosition, true);
		}
		
		/**
		 * Gets or sets a number that represents the minimum scroll position.  The 
		 * <code>scrollPosition</code> value represents a relative position between the
		 * <code>minScrollPosition</code> and the <code>maxScrollPosition</code> values.
		 * This property is set by the component that contains the scroll bar,
		 * and is usually zero.
         *
         * @default 0
         *
         * @see #setScrollProperties()
		 * @see #maxScrollPosition
		 * @see #scrollPosition
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get minScrollPosition():Number {
			return _minScrollPosition;
		}		
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set minScrollPosition(value:Number):void {
			// This uses setScrollProperties because it needs to update thumb and enabled.
			setScrollProperties(_pageSize,value,_maxScrollPosition);
		}
		
		/**
		 * Gets or sets a number that represents the maximum scroll position. The
		 * <code>scrollPosition</code> value represents a relative position between the
		 * <code>minScrollPosition</code> and the <code>maxScrollPosition</code> values.
		 * This property is set by the component that contains the scroll bar,
		 * and is the maximum value. Usually this property describes the number
		 * of pixels between the bottom of the component and the bottom of
		 * the content, but this property is often set to a different value to change the
		 * behavior of the scrolling.  For example, the TextArea component sets this
		 * property to the <code>maxScrollH</code> value of the text field, so that the 
		 * scroll bar scrolls appropriately by line of text.
         *
         * @default 0
         *
         * @see #setScrollProperties()
		 * @see #minScrollPosition
		 * @see #scrollPosition
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get maxScrollPosition():Number {
			return _maxScrollPosition;
		}		
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set maxScrollPosition(value:Number):void {
			// This uses setScrollProperties because it needs to update thumb and enabled.
			setScrollProperties(_pageSize,_minScrollPosition,value);
		}
		
		/**
		 * Gets or sets the number of lines that a page contains. The <code>lineScrollSize</code>
		 * is measured in increments between the <code>minScrollPosition</code> and 
		 * the <code>maxScrollPosition</code>. If this property is 0, the scroll bar 
		 * will not scroll.
         *
         * @default 10
         *
		 * @see #maxScrollPosition
		 * @see #minScrollPosition
         * @see #setScrollProperties()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get pageSize():Number {
			return _pageSize;
		}
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set pageSize(value:Number):void {
			if (value > 0) {
				_pageSize = value;
			}
		}
		/**
		 * Gets or sets a value that represents the increment by which the page is scrolled
		 * when the scroll bar track is pressed. The <code>pageScrollSize</code> value is 
		 * measured in increments between the <code>minScrollPosition</code> and the 
		 * <code>maxScrollPosition</code> values. If this value is set to 0, the value of the
		 * <code>pageSize</code> property is used.
         *
         * @default 0
		 *
		 * @see #maxScrollPosition
		 * @see #minScrollPosition
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get pageScrollSize():Number {
			return (_pageScrollSize == 0) ? _pageSize : _pageScrollSize;
		}
		
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set pageScrollSize(value:Number):void {
			if (value>=0) { _pageScrollSize = value; }
		}
		
		/**
		 * Gets or sets a value that represents the increment by which to scroll the page
		 * when the scroll bar track is pressed. The <code>pageScrollSize</code> is measured 
		 * in increments between the <code>minScrollPosition</code> and the <code>maxScrollPosition</code> 
         * values. If this value is set to 0, the value of the <code>pageSize</code> property is used.
         *
         * @default 0
		 *
		 * @see #maxScrollPosition
		 * @see #minScrollPosition
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get lineScrollSize():Number {
			return _lineScrollSize;
		}		
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set lineScrollSize(value:Number):void {
			if (value>0) {_lineScrollSize = value; }
		}
		
		/**
		 * Gets or sets a value that indicates whether the scroll bar scrolls horizontally or vertically.
         * Valid values are <code>ScrollBarDirection.HORIZONTAL</code> and 
         * <code>ScrollBarDirection.VERTICAL</code>.
         *
         * @default ScrollBarDirection.VERTICAL
         *
         * @see fl.controls.ScrollBarDirection ScrollBarDirection
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0
		 *  @productversion Flash CS3
		 */
		public function get direction():String {
			return _direction;
		}
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set direction(value:String):void {
			if (_direction == value) { return; }
			_direction = value;
			if (isLivePreview) { return; } // Rotation and scaling happens automatically in LivePreview.
			//
			setScaleY(1);			
			
			var horizontal:Boolean = _direction == ScrollBarDirection.HORIZONTAL;
			if (horizontal && componentInspectorSetting) {
				if (rotation == 90 ) { return; }
				setScaleX(-1);
				rotation = -90;
			}
			
			if (!componentInspectorSetting) {
				if (horizontal && rotation == 0) {
					rotation = -90;
					setScaleX(-1);
				} else if (!horizontal && rotation == -90 ) {
					rotation = 0;
					setScaleX(1);
				}
			}
			invalidate(InvalidationType.SIZE);
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */		
		override protected function configUI():void {
			super.configUI();
			
			track = new BaseButton();
			track.move(0,14);
			track.useHandCursor = false;
			track.autoRepeat = true;
			track.focusEnabled = false;
			addChild(track);
			
			thumb = new LabelButton();
			thumb.label = "";
			thumb.setSize(WIDTH,15);
			thumb.move(0,15);
			thumb.focusEnabled = false;
			addChild(thumb);
			
			downArrow = new BaseButton();
			downArrow.setSize(WIDTH,14);
			downArrow.autoRepeat = true;
			downArrow.focusEnabled = false;
			addChild(downArrow);
			
			upArrow = new BaseButton();
			upArrow.setSize(WIDTH,14);
			upArrow.move(0,0);
			upArrow.autoRepeat = true;
			upArrow.focusEnabled = false;
			addChild(upArrow);
			
			upArrow.addEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler,false,0,true);
			downArrow.addEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler,false,0,true);
			track.addEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler,false,0,true);
			thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbPressHandler,false,0,true);
			
			enabled = false;
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function draw():void {	
			if (isInvalid(InvalidationType.SIZE)) {
				var h:Number = super.height;
				downArrow.move(0,  Math.max(upArrow.height, h-downArrow.height));
				track.setSize(WIDTH, Math.max(0, h-(downArrow.height + upArrow.height)));
				updateThumb();
			}
			if (isInvalid(InvalidationType.STYLES,InvalidationType.STATE)) {
				setStyles();
			}
			// Call drawNow on nested components to get around problems with nested render events:
			downArrow.drawNow();
			upArrow.drawNow();
			track.drawNow();
			thumb.drawNow();
			validate();
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function scrollPressHandler(event:ComponentEvent):void {
			event.stopImmediatePropagation();
			if (event.currentTarget == upArrow) {
				setScrollPosition(_scrollPosition-_lineScrollSize); 
			} else if (event.currentTarget == downArrow) {
				setScrollPosition(_scrollPosition+_lineScrollSize);
			} else {
				var mousePosition:Number = (track.mouseY)/track.height * (_maxScrollPosition-_minScrollPosition) + _minScrollPosition;
				var pgScroll:Number = (pageScrollSize == 0)?pageSize:pageScrollSize;
				if (_scrollPosition < mousePosition) {
					setScrollPosition(Math.min(mousePosition,_scrollPosition+pgScroll));
				} else if (_scrollPosition > mousePosition) {
					setScrollPosition(Math.max(mousePosition,_scrollPosition-pgScroll));
				}
			}
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function thumbPressHandler(event:MouseEvent):void {
			inDrag = true;
			thumbScrollOffset = mouseY-thumb.y;
			thumb.mouseStateLocked = true;
			mouseChildren = false; // Should be able to do stage.mouseChildren, but doesn't seem to work.
			stage.addEventListener(MouseEvent.MOUSE_MOVE,handleThumbDrag,true,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,thumbReleaseHandler,true,0,true);
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function handleThumbDrag(event:MouseEvent):void {
			var pos:Number = Math.max(0, Math.min(track.height-thumb.height, mouseY-track.y-thumbScrollOffset));
			setScrollPosition(pos/(track.height-thumb.height) * (_maxScrollPosition-_minScrollPosition) + _minScrollPosition);
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function thumbReleaseHandler(event:MouseEvent):void {
			inDrag = false;
			mouseChildren = true;
			thumb.mouseStateLocked = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleThumbDrag,true);
			stage.removeEventListener(MouseEvent.MOUSE_UP,thumbReleaseHandler,true);
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function setScrollPosition(newScrollPosition:Number, fireEvent:Boolean=true):void {
			var oldPosition:Number = scrollPosition;
			_scrollPosition = Math.max(_minScrollPosition,Math.min(_maxScrollPosition, newScrollPosition));
			if (oldPosition == _scrollPosition) { return; }
			if (fireEvent) { dispatchEvent(new ScrollEvent(_direction, scrollPosition-oldPosition, scrollPosition)); }
			updateThumb();
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function setStyles():void {
			copyStylesToChild(downArrow,DOWN_ARROW_STYLES);
			copyStylesToChild(thumb,THUMB_STYLES);
			copyStylesToChild(track,TRACK_STYLES);
			copyStylesToChild(upArrow,UP_ARROW_STYLES);
		}
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function updateThumb():void {
			var per:Number = _maxScrollPosition - _minScrollPosition + _pageSize;
			if (track.height <= 12 || _maxScrollPosition <= _minScrollPosition || (per == 0 || isNaN(per))) {
				thumb.height = 12;
				thumb.visible = false;
			} else {
				thumb.height = Math.max(13,_pageSize / per * track.height);
				thumb.y = track.y+(track.height-thumb.height)*((_scrollPosition-_minScrollPosition)/(_maxScrollPosition-_minScrollPosition));
				thumb.visible = enabled;
			}
		}
	}
}
