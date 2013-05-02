// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.controls {

	import fl.data.DataProvider;
	import fl.containers.BaseScrollPane;
	import fl.controls.BaseButton;
	import fl.controls.List;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import fl.controls.ScrollBar;
	import fl.controls.SelectableList;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	import fl.events.DataChangeEvent;
	import fl.events.DataChangeType;
	import fl.events.ListEvent;
	import fl.managers.IFocusManagerComponent;
	import fl.data.DataProvider;
	import fl.data.SimpleCollectionItem;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

    //--------------------------------------
    //  Events
    //--------------------------------------
    /**
     * Dispatched when the user changes the selection in the ComboBox component or, if 
     * the ComboBox component is editable, each time the user enters a keystroke in the 
     * text field.
     *
     * @eventType flash.events.Event.CHANGE
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Event(name="change", type="flash.events.Event")]

    /**
     * @copy fl.controls.SelectableList#event:itemRollOver
     *
     * @eventType fl.events.ListEvent.ITEM_ROLL_OVER
     *
     * @includeExample examples/ComboBox.itemRollOver.1.as -noswf
     *
     * @see #event:itemRollOut
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Event(name="itemRollOver", type="fl.events.ListEvent")]

    /**
     * @copy fl.controls.SelectableList#event:itemRollOut
     *
     * @eventType fl.events.ListEvent.ITEM_ROLL_OUT
     *
     * @see #event:itemRollOver
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Event(name="itemRollOut", type="fl.events.ListEvent")]

    /**
     * Dispatched when the drop-down list is dismissed for any reason.
     *
     * @eventType flash.events.Event.CLOSE
     *
     * @includeExample examples/ComboBox.close.1.as -noswf
     *
     * @see #close()
     * @see #event:open
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Event(name="close", type="flash.events.Event")]

    /**
     * Dispatched if the <code>editable</code> property is set to <code>true</code> and the user 
     * presses the Enter key while typing in the editable text field.
     *
     * @eventType fl.events.ComponentEvent.ENTER
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Event(name="enter", type="fl.events.ComponentEvent")]

    /**
     * Dispatched when the user clicks the drop-down button to display 
     * the drop-down list. Also dispatched when the user clicks the text
     * field, if the ComboBox component is not editable.
     *
     * @eventType flash.events.Event.OPEN
     *
     * @includeExample examples/ComboBox.open.1.as -noswf
     *
     * @see #event:close
     * @see #open()
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Event(name="open", type="flash.events.Event")]

    /**
     * Dispatched when the user scrolls the drop-down list of the ComboBox component.
     *
     * @eventType fl.events.ScrollEvent.SCROLL
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Event(name="scroll", type="fl.events.ScrollEvent")]


    //--------------------------------------
    //  Styles
    //--------------------------------------
    /**
     * The space that separates the right edge of the component from the
     * text representing the selected item, in pixels. The button is 
     * part of the background skin.
     *
     * @default 24
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Style(name="buttonWidth", type="Number", format="Length")]

    /**
     * The space that separates the border from the text representing the
     * selected item, in pixels.
     *
     * @default 3
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Style(name="textPadding", type="Number", format="Length")]

    /**
     * The name of the class that provides the background of the ComboBox component.
     *
     * @default ComboBox_upSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Style(name="upSkin", type="Class")]

    /**
     * The name of the class that provides the background that appears
     * in the ComboBox component when the mouse is over it.
     *
     * @default ComboBox_overSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Style(name="overSkin", type="Class")]

    /**
     * The name of the class that provides the background that appears
     * in the ComboBox component when the mouse is down.
     *
     * @default ComboBox_downSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Style(name="downSkin", type="Class")]

    /**
     * The name of the class that provides the background that appears  
     * in the ComboBox component when the <code>enabled</code> property of the 
     * component is set to <code>false</code>.
     *
     * @default ComboBox_disabledSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Style(name="disabledSkin", type="Class")]

    /**
     * @copy fl.controls.SelectableList#style:cellRenderer
     *
     * @default fl.controls.listClasses.CellRenderer
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Style(name="cellRenderer", type="Class")]

    /**
     * @copy fl.containers.BaseScrollPane#style:contentPadding
     *
     * @default 3
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Style(name="contentPadding", type="Number", format="Length")]

    /**
     * @copy fl.controls.SelectableList#style:disabledAlpha
     *
     * @default 0.5
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
    [Style(name="disabledAlpha", type="Class")]

    /**
     * @copy fl.controls.ScrollBar#style:downArrowDisabledSkin
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
     * @copy fl.controls.ScrollBar#style:downArrowDownSkin
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
     * @copy fl.controls.ScrollBar#style:downArrowOverSkin
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
     * @copy fl.controls.ScrollBar#style:downArrowUpSkin
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
     * @copy fl.controls.ScrollBar#style:thumbDisabledSkin
     *
     * @default ScrollThumb_upSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
    [Style(name="thumbDisabledSkin", type="Class")]

    /**
     * @copy fl.controls.ScrollBar#style:thumbDownSkin
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
     * @copy fl.controls.ScrollBar#style:thumbOverSkin
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
     * @copy fl.controls.ScrollBar#style:thumbUpSkin
     * 
     * @default ScrollThumb_upSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
    [Style(name="thumbArrowUpSkin", type="Class")]

    /**
     * @copy fl.controls.ScrollBar#style:trackDisabledSkin
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
     * @copy fl.controls.ScrollBar#style:trackDownSkin
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
     * @copy fl.controls.ScrollBar#style:trackOverSkin
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
     * @copy fl.controls.ScrollBar#style:trackUpSkin
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
     * @copy fl.controls.ScrollBar#style:upArrowDisabledSkin
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
     * @copy fl.controls.ScrollBar#style:upArrowDownSkin
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
     * @copy fl.controls.ScrollBar#style:upArrowOverSkin
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
     * @copy fl.controls.ScrollBar#style:upArrowUpSkin
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
     * @copy fl.controls.ScrollBar#style:thumbIcon
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

    /**
     * @copy fl.controls.LabelButton#style:embedFonts
     * 
     * @default false
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	[Style(name="embedFonts", type="Boolean")]

    //--------------------------------------
    //  Class description
    //--------------------------------------
    /**
     * The ComboBox component contains a drop-down list from which the
     * user can select one value. Its functionality is similar to that 
     * of the SELECT form element in HTML. The ComboBox component can be editable, 
     * in which case the user can type entries that are not in the list 
     * into the TextInput portion of the ComboBox component.
     *
     * @includeExample examples/ComboBoxExample.as
     *
     * @see List
     * @see TextInput
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     *  
     *  @playerversion AIR 1.0

     *  @productversion Flash CS3
     */
	public class ComboBox extends UIComponent implements IFocusManagerComponent {
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var inputField:TextInput;
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var background:BaseButton;
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var list:List;
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var _rowCount:uint = 5;
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var _editable:Boolean = false;
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var isOpen:Boolean = false;
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var highlightedCell:int = -1
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var editableValue:String;
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var _prompt:String;
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var isKeyDown:Boolean = false;
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var currentIndex:int;
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var listOverIndex:uint;
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var _dropdownWidth:Number;
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var _labels:Array;
		
		/**
		 * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private var collectionItemImport:SimpleCollectionItem;		
		
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static var defaultStyles:Object = {
				upSkin:"ComboBox_upSkin",
				downSkin:"ComboBox_downSkin",
				overSkin:"ComboBox_overSkin",
				disabledSkin:"ComboBox_disabledSkin",
				focusRectSkin:null, focusRectPadding:null,
				textFormat:null, disabledTextFormat:null, textPadding:3,
				buttonWidth:24,
				disabledAlpha:null, listSkin:null
				};
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected static const LIST_STYLES:Object = {upSkin:"comboListUpSkin",
				overSkin:"comboListOverSkin",
				downSkin:"comobListDownSkin",
				disabledSkin:"comboListDisabledSkin",
				downArrowDisabledSkin:"downArrowDisabledSkin",
				downArrowDownSkin:"downArrowDownSkin",
				downArrowOverSkin:"downArrowOverSkin",
				downArrowUpSkin:"downArrowUpSkin",
				upArrowDisabledSkin: "upArrowDisabledSkin",
				upArrowDownSkin:"upArrowDownSkin",
				upArrowOverSkin:"upArrowOverSkin",
				upArrowUpSkin:"upArrowUpSkin",
				thumbDisabledSkin:"thumbDisabledSkin",
				thumbDownSkin:"thumbDownSkin",
				thumbOverSkin:"thumbOverSkin",
				thumbUpSkin:"thumbUpSkin",
				thumbIcon:"thumbIcon",
				trackDisabledSkin:"trackDisabledSkin",
				trackDownSkin:"trackDownSkin",
				trackOverSkin:"trackOverSkin",
				trackUpSkin:"trackUpSkin",
				repeatDelay:"repeatDelay",
				repeatInterval:"repeatInterval",
				textFormat:"textFormat",
				disabledAlpha:"disabledAlpha",
				skin:"listSkin"
				};
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected static const BACKGROUND_STYLES:Object = {
				overSkin:"overSkin",
				downSkin:"downSkin",
				upSkin:"upSkin",
				disabledSkin:"disabledSkin",
				repeatInterval:"repeatInterval"
				};

        /**
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
		 * @includeExample ../core/examples/UIComponent.getStyleDefinition.1.as -noswf
		 *
         * @see fl.core.UIComponent#getStyle() UIComponent.getStyle()
         * @see fl.core.UIComponent#setStyle() UIComponent.setStyle()
         * @see fl.managers.StyleManager StyleManager
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         *  
         *  @playerversion AIR 1.0

         *  @productversion Flash CS3
         */
		public static function getStyleDefinition():Object {
			return mergeStyles(defaultStyles, List.getStyleDefinition());
		}
		
		/**
         * @private (internal)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public static var createAccessibilityImplementation:Function;

		/**
         * Creates a new ComboBox component instance.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function ComboBox() {
			super();
		}

		
		[Inspectable(defaultValue=false)]
        /**
         * Gets or sets a Boolean value that indicates whether the ComboBox 
         * component is editable or read-only. A value of <code>true</code> indicates 
         * that the ComboBox component is editable; a value of <code>false</code> 
         * indicates that it is not.
         *
         * <p>In an editable ComboBox component, a user can enter values into the text 
         * box that do not appear in the drop-down list. The text box displays the text
		 * of the item in the list. If a ComboBox component is not editable, text cannot 
		 * be entered into the text box. </p>
         *
         * @default false
         *
         * @includeExample examples/ComboBox.editable.1.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         *  
         *  @playerversion AIR 1.0

         *  @productversion Flash CS3
         */
		public function get editable():Boolean {
			return _editable;
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set editable(value:Boolean):void {
			_editable = value;
			drawTextField();
		}

		[Inspectable(defaultValue=5)]
        /**
         * Gets or sets the maximum number of rows that can appear in a drop-down  
         * list that does not have a scroll bar. If the number of items in the 
         * drop-down list exceeds this value, the list is resized and a scroll bar is displayed, 
         * if necessary. If the number of items in the drop-down list is less than this value,
         * the drop-down list is resized to accommodate the number of items that it contains.
         *
         * <p>This behavior differs from that of the List component, which always shows the number
         * of rows specified by its <code>rowCount</code> property, even if this includes empty space.</p>
         *
         * @default 5
         *
         * @includeExample examples/ComboBox.rowCount.1.as -noswf
         *
         * @see #length
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         *  
         *  @playerversion AIR 1.0

         *  @productversion Flash CS3
         */
		public function get rowCount():uint {
			return _rowCount;
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set rowCount(value:uint):void {
			_rowCount = value;
			invalidate(InvalidationType.SIZE);
		}

		[Inspectable(verbose=1)]
        /**
         * Gets or sets the characters that a user can enter in the text field.
         * If the value of the <code>restrict</code> property is 
         * a string of characters, you can enter only characters in the string 
         * into the text field. The string is read from left to right. If 
         * the value of the <code>restrict</code> property is <code>null</code>, you 
         * can enter any character. If the value of the <code>restrict</code> 
         * property is an empty string (""), you cannot enter any character. 
         * You can specify a range by using the hyphen (-) character. This restricts 
         * only user interaction; a script can put any character into the text 
         * field.
         *
         * @default null
         *
         * @includeExample examples/ComboBox.restrict.1.as -noswf
         *
         * @see flash.text.TextField#restrict TextField.restrict
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         *  
         *  @playerversion AIR 1.0

         *  @productversion Flash CS3
         */
		public function get restrict():String {
			return inputField.restrict;
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set restrict(value:String):void {
			if (componentInspectorSetting && value == "") { value = null; }
			if (! _editable) { return; }
			inputField.restrict = value;
		}

        /**
         * @copy fl.controls.SelectableList#selectedIndex
         *
         * @default 0
         *
         * @includeExample examples/ComboBox.selectedIndex.1.as -noswf
         * @includeExample examples/ComboBox.selectedIndex.2.as -noswf
         *
         * @see #selectedItem
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         *  
         *  @playerversion AIR 1.0

         *  @productversion Flash CS3
         */
		public function get selectedIndex():int {
			return list.selectedIndex;
		}

        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set selectedIndex(value:int):void {
			list.selectedIndex = value;
			highlightCell(); // Deselect any highlighted cells / reset index
			invalidate(InvalidationType.SELECTED);
		}

        /**
         * Gets or sets the text that the text box contains in an editable ComboBox component. 
         * For ComboBox components that are not editable, this value is read-only. 
         *
         * @default ""
         *
         * @includeExample examples/ComboBox.text.1.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         *  
         *  @playerversion AIR 1.0

         *  @productversion Flash CS3
         */
		public function get text():String {
			return inputField.text;
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set text(value:String):void {
			if (!editable) { return; }
			inputField.text = value;
		}

		/**
		 * @copy fl.controls.List#labelField
         * 
         * @default "label"
         *
         * @includeExample examples/ComboBox.labelField.1.as -noswf
         *
         * @see #labelFunction
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get labelField():String {
			return list.labelField;
		}

		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set labelField(value:String):void {
			list.labelField = value;
			invalidate(InvalidationType.DATA);
		}

		/**
		 * @copy fl.controls.List#labelFunction
         *
         * @includeExample examples/List.labelFunction.1.as -noswf
         * @includeExample examples/ComboBox.labelFunction.2.as -noswf
         *
         * @see #labelField
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get labelFunction():Function {
			return list.labelFunction;
		}

		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set labelFunction(value:Function):void {
			list.labelFunction = value;
			invalidate(InvalidationType.DATA);
		}
		
		/**
		 * @copy fl.controls.List#itemToLabel()
         *
         * @see #labelField
         * @see #labelFunction
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function itemToLabel(item:Object):String {
			if (item == null) { return ""; }
			return list.itemToLabel(item);	
		}
		
		/**
		 * Gets or sets the value of the item that is selected in the drop-down list.
         * If the user enters text into the text box of an editable ComboBox component, the 
		 * <code>selectedItem</code> property is <code>undefined</code>. This  
		 * property has a value only if the user selects an item 
		 * or if ActionScript is used to select an item from the drop-down list. 
		 * If the ComboBox component is not editable, the value of the <code>selectedItem</code> 
		 * property is always valid. If there are no items in the drop-down list of 
		 * an editable ComboBox component, the value of this property is <code>null</code>.
		 *
         * @default null
         *
         * @includeExample examples/ComboBox.selectedItem.1.as -noswf
         * @includeExample examples/ComboBox.selectedItem.2.as -noswf
         *
         * @see #selectedIndex
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get selectedItem():Object {
			return list.selectedItem;
		}

		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set selectedItem(value:Object):void {
			list.selectedItem = value;
			invalidate(InvalidationType.SELECTED);
		}

		/**
		 * Gets a reference to the List component that the ComboBox component contains. 
		 * The List subcomponent is not instantiated within the ComboBox until it 
		 * must be displayed. However, the list is created when the <code>dropdown</code>
		 * property is accessed.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get dropdown():List {
			return list;
		}

		/**
         * Gets the number of items in the list. This property belongs to
		 * the List component but can be accessed from a ComboBox instance.
		 *
         * @default 0
         *
         * @includeExample examples/ComboBox.length.1.as -noswf
         * @includeExample examples/ComboBox.length.2.as -noswf
         *
         * @see #rowCount
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get length():int {
			return list.length;
		}

		/**
		 * Gets a reference to the TextInput component that the ComboBox 
		 * component contains. Use this property to access and manipulate
		 * the underlying TextInput component. For example, you can use
		 * this property to change the selection of the text box or to 
		 * restrict the set of characters that can be entered into it.
         *
         * @internal includeExample examples/ComboBox.textField.1.as -noswf
         *
         * @includeExample examples/ComboBox.textField.3.as -noswf
         * @includeExample examples/ComboBox.textField.2.as -noswf
         * @includeExample examples/ComboBox.textField.4.as -noswf
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get textField():TextInput {
			return inputField;
		}

		/**
         * Gets the label of an item in an editable ComboBox component. For a ComboBox 
         * component that is not editable, this property gets the data that the item contains.
         *
         * @includeExample examples/ComboBox.value.1.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get value():String {
			if (editableValue != null) {
				return editableValue;
			} else {
				var item:Object = selectedItem;
				if (!_editable && item.data != null) {
					return item.data;
				} else {
					return itemToLabel(item);	
				}
			}
		}	
				
		[Collection(collectionClass="fl.data.DataProvider", identifier="item", collectionItem="fl.data.SimpleCollectionItem")]
		/**
		 * @copy fl.controls.SelectableList#dataProvider
         *
         * @see fl.data.DataProvider DataProvider
         *
		 * @includeExample examples/ComboBox.dataProvider.1.as -noswf
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get dataProvider():DataProvider {
			return list.dataProvider;
		}
		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set dataProvider(value:DataProvider):void {
			value.addEventListener(DataChangeEvent.DATA_CHANGE,handleDataChange,false,0,true);
			list.dataProvider = value;
			invalidate(InvalidationType.DATA);
		}

		/**
		 * Gets or sets the maximum width of the drop-down list, in pixels. 
		 * The default value of this property is the width of the ComboBox 
		 * component (the width of the TextInput instance plus the width of the BaseButton instance).
         *
         * @default 100
         *
         * @includeExample examples/ComboBox.dropdownWidth.1.as -noswf
         * @includeExample examples/ComboBox.dropdownWidth.2.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get dropdownWidth():Number {
			return list.width;
		}

		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set dropdownWidth(value:Number):void {
			_dropdownWidth = value;
			invalidate(InvalidationType.SIZE);
		}
		/**
		 * @copy fl.controls.SelectableList#addItem()
         *
         * @see #addItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function addItem(item:Object):void {
			list.addItem(item);
			invalidate(InvalidationType.DATA);
		}
		
		[Inspectable(defaultValue="")]
		/**
		 * Gets or sets the prompt for the ComboBox component. This prompt is a string 
		 * that is displayed in the TextInput portion of the ComboBox when
         * the <code>selectedIndex</code> is -1. It is usually a string like "Select one...".
         * If a prompt is not set, the ComboBox component sets the <code>selectedIndex</code> property
         * to 0 and displays the first item in the <code>dataProvider</code> property.
         *
         * @default ""
         *
         * @includeExample examples/ComboBox.prompt.1.as -noswf
         * @includeExample examples/ComboBox.prompt.2.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get prompt():String {
			return _prompt;
		}
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set prompt(value:String):void {
			if (value == "") {
				_prompt = null;
			} else {
				_prompt = value;
			}
			invalidate(InvalidationType.STATE);
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		 public function get imeMode():String {
			return inputField.imeMode;
		}		
		/**
		 * @private (protected)
		 */
		public function set imeMode(value:String):void {
			inputField.imeMode = value;
		}

		/**
		 * @copy fl.controls.SelectableList#addItemAt()
         *
         * @see #addItem()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function addItemAt(item:Object,index:uint):void {
			list.addItemAt(item,index);
			invalidate(InvalidationType.DATA);
		}
		/**
         * @copy fl.controls.SelectableList#removeAll()
         *
         * @includeExample examples/ComboBox.removeAll.1.as -noswf
         *
         * @see #removeItem()
         * @see #removeItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function removeAll():void {
			list.removeAll();
			inputField.text = "";
			invalidate(InvalidationType.DATA);
		}
		
		/**
		 * @copy fl.controls.SelectableList#removeItem()
         *
         * @see #removeAll()
         * @see #removeItemAt()
         *
		 * @includeExample examples/ComboBox.removeItem.1.as -noswf
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */		 
		public function removeItem(item:Object):Object {
			return list.removeItem(item);
		}
		
		/**
		 * Removes the item at the specified index position. The index 
         * locations of items whose indices are greater than the specified
		 * index advance in the array by 1.
         *
         * <p>This is a method of the List component that is
		 * available from an instance of the ComboBox component.</p>
		 *
		 * @param index Index of the item to be removed.
         *
         * @throws RangeError The specified index is less than 0 or greater than or 
		 *                    equal to the length of the data provider. 
         *
         * @see #removeAll()
         * @see #removeItem()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function removeItemAt(index:uint):void {
			list.removeItemAt(index);
			invalidate(InvalidationType.DATA);
		}

		/**
         * @copy fl.controls.SelectableList#getItemAt()
         *
         * @includeExample examples/ComboBox.getItemAt.1.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function getItemAt(index:uint):Object {
			return list.getItemAt(index);
		}

		/**
         * @copy fl.controls.SelectableList#replaceItemAt()
         *
         * @includeExample examples/ComboBox.replaceItemAt.1.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function replaceItemAt(item:Object, index:uint):Object {
			return list.replaceItemAt(item, index);
		}

		/**
		 * @copy fl.controls.SelectableList#sortItems()
         *
         * @see Array#sort()
         * @see #sortItemsOn()
         *
		 * @includeExample examples/ComboBox.sortItems.1.as -noswf
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function sortItems(...sortArgs:Array):* {
			return list.sortItems.apply(list, sortArgs);
		}

		/**
         * @copy fl.controls.SelectableList#sortItemsOn()
         *
         * @includeExample examples/ComboBox.sortItemsOn.1.as -noswf
         * @includeExample examples/ComboBox.sortItemsOn.2.as -noswf
         *
         * @see Array#sortOn()
         * @see #sortItems()
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function sortItemsOn(field:String,options:Object=null):* {
			return list.sortItemsOn(field,options);
		}

		/**
         * Opens the drop-down list.
         *
         * <p><strong>Note:</strong> Calling this method causes the <code>open</code> 
		 * event to be dispatched. If the ComboBox component is already open, calling this method has no effect.</p>
         *
         * @see #close()
         * @see #event:open
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function open():void {
			currentIndex = selectedIndex;
			if (isOpen || length == 0) { return; }

			dispatchEvent(new Event(Event.OPEN));
			isOpen = true;

			// Add a listener to the stage to close the combobox when something
			// else is clicked.  We need to wait a frame, otherwise the same click
			// that opens the comboBox will also close it.
			addEventListener(Event.ENTER_FRAME, addCloseListener, false, 0, true);			

			positionList();
			list.scrollToSelected();
			stage.addChild(list);
		}

		/**
         * Closes the drop-down list.
         *
         * <p><strong>Note:</strong> Calling this method causes the <code>close</code> 
         * event to be dispatched. If the ComboBox is already closed, calling this method has no effect.</p>
         *
         * @includeExample examples/ComboBox.close.1.as -noswf
         *
         * @see #open()
         * @see #event:close
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function close():void {
			highlightCell();
			highlightedCell = -1;
			if (! isOpen) { return; }
			
			dispatchEvent(new Event(Event.CLOSE));
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			isOpen = false;
			stage.removeChild(list);
		}
		
		/**
		 * Gets the string that is displayed in the TextInput portion 
		 * of the ComboBox component. This value is calculated from the data by using 
         * the <code>labelField</code> or <code>labelFunction</code> property.
         *
         * @includeExample examples/ComboBox.selectedLabel.1.as -noswf
		 *
		 * @see #labelField
         * @see #labelFunction
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 *  
		 *  @playerversion AIR 1.0

		 *  @productversion Flash CS3
		 */
		public function get selectedLabel():String {
			if (editableValue != null) {
				return editableValue;
			} else if (selectedIndex == -1) {
				return null;
			}
			return itemToLabel(selectedItem);	
		}
		
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function configUI():void {
			super.configUI();

			background = new BaseButton();
			background.focusEnabled = false;
			copyStylesToChild(background, BACKGROUND_STYLES);
			background.addEventListener(MouseEvent.MOUSE_DOWN, onToggleListVisibility, false, 0, true);
			addChild(background);
			
			inputField = new TextInput();
			inputField.focusTarget = this as IFocusManagerComponent;
			inputField.focusEnabled = false;
			inputField.addEventListener(Event.CHANGE, onTextInput, false, 0, true);
			addChild(inputField);

			list = new List();
			list.focusEnabled = false;
			copyStylesToChild(list, LIST_STYLES);			
			list.addEventListener(Event.CHANGE, onListChange, false, 0, true);
			list.addEventListener(ListEvent.ITEM_CLICK, onListChange, false, 0, true);
			list.addEventListener(ListEvent.ITEM_ROLL_OUT, passEvent, false, 0, true);
			list.addEventListener(ListEvent.ITEM_ROLL_OVER, passEvent, false, 0, true);
			list.verticalScrollBar.addEventListener(Event.SCROLL, passEvent, false, 0, true);
			
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function focusInHandler(event:FocusEvent):void {
			super.focusInHandler(event);
			if (editable) {
				stage.focus = inputField.textField;
			}
		}
		
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function focusOutHandler(event:FocusEvent):void {
			isKeyDown = false;
			// If the dropdown is open...
			if (isOpen) {				
				// If focus is moving outside the dropdown...
				if (!event.relatedObject || !list.contains(event.relatedObject)) {
					// Close the dropdown.
					if (highlightedCell != -1 && highlightedCell != selectedIndex) {
						selectedIndex = highlightedCell;
						dispatchEvent(new Event(Event.CHANGE));
					}
					close();
				}
			}
			super.focusOutHandler(event);
		}
		
		/**
		 * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function handleDataChange(event:DataChangeEvent):void {
			invalidate(InvalidationType.DATA);
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function draw():void {
			// Fix the selectedIndex before redraw.
			var _selectedIndex = selectedIndex;
			
			// Check if index is -1, and it is allowed.
			if (_selectedIndex == -1 && (prompt != null || editable || length == 0)) {
				_selectedIndex = Math.max(-1, Math.min(_selectedIndex, length-1));
			} else {
				editableValue = null;
				_selectedIndex = Math.max(0, Math.min(_selectedIndex, length-1));	
			}
			if (list.selectedIndex != _selectedIndex) {
				list.selectedIndex = _selectedIndex;
				invalidate(InvalidationType.SELECTED, false);
			}
			
			if (isInvalid(InvalidationType.STYLES)) {
				setStyles();				
				setEmbedFonts();				
				invalidate(InvalidationType.SIZE, false);
			}
			if (isInvalid(InvalidationType.SIZE, InvalidationType.DATA, InvalidationType.STATE)) {
				drawTextFormat();
				drawLayout();
				invalidate(InvalidationType.DATA);
			}
			if (isInvalid(InvalidationType.DATA)) {
				drawList();
				invalidate(InvalidationType.SELECTED, true);
			}
			if (isInvalid(InvalidationType.SELECTED)) {
				if (_selectedIndex == -1 && editableValue != null) {
					inputField.text = editableValue;
				} else if (_selectedIndex > -1) {
					if (length > 0) {
						inputField.horizontalScrollPosition = 0;
						inputField.text = itemToLabel(list.selectedItem);
					}
				} else if(_selectedIndex == -1 && _prompt != null) {
					showPrompt();
				} else {
					inputField.text = "";	
				}
				
				if (editable && selectedIndex > -1 && stage.focus == inputField.textField) {
					inputField.setSelection(0,inputField.length);
				}
			}			
			drawTextField();
			
			
			super.draw();
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function setEmbedFonts():void {
			var embed:Object = getStyleValue("embedFonts");
			if (embed != null) {
				inputField.textField.embedFonts = embed;
			}	
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function showPrompt():void {
			inputField.text = _prompt;
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function setStyles():void {
			copyStylesToChild(background, BACKGROUND_STYLES);
			copyStylesToChild(list, LIST_STYLES);
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function drawLayout():void {
			var buttonWidth:Number = getStyleValue("buttonWidth") as Number;
			var textPadding:Number = getStyleValue("textPadding") as Number;
			background.setSize(width, height);
			inputField.x = inputField.y = textPadding;
			inputField.setSize(width - buttonWidth - textPadding, height - textPadding); // textPadding*2 cuts off the descenders.
			
			list.width = (isNaN(_dropdownWidth)) ? width : _dropdownWidth;
			
			background.enabled = enabled;
			background.drawNow();
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function drawTextFormat():void {
			var tf:TextFormat = getStyleValue(_enabled?"textFormat":"disabledTextFormat") as TextFormat;
			if (tf == null) { tf = new TextFormat(); }
			inputField.textField.defaultTextFormat = tf;
			inputField.textField.setTextFormat(tf);
			setEmbedFonts();
		}

		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function drawList():void {
			list.rowCount = Math.max(0, Math.min(_rowCount, list.dataProvider.length));
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function positionList():void {
			var p:Point = localToGlobal(new Point(0,0));
			list.x = p.x;
			if (p.y + height + list.height > stage.stageHeight) {
				list.y = p.y - list.height;
			} else {
				list.y = p.y + height;
			}
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function drawTextField():void {
			inputField.setStyle("upSkin", "");
			inputField.setStyle("disabledSkin", "");

			inputField.enabled = enabled;
			inputField.editable = _editable;
			inputField.textField.selectable = enabled && _editable;
			inputField.mouseEnabled = inputField.mouseChildren = enabled && _editable;
			inputField.focusEnabled = false;
			
			if (_editable) {
				inputField.addEventListener(FocusEvent.FOCUS_IN, onInputFieldFocus, false,0,true);
				inputField.addEventListener(FocusEvent.FOCUS_OUT, onInputFieldFocusOut, false,0,true);
			} else {
				inputField.removeEventListener(FocusEvent.FOCUS_IN, onInputFieldFocus);
				inputField.removeEventListener(FocusEvent.FOCUS_OUT, onInputFieldFocusOut);
			}

		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function onInputFieldFocus(event:FocusEvent):void {
			inputField.addEventListener(ComponentEvent.ENTER, onEnter, false, 0, true);
			close();
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function onInputFieldFocusOut(event:FocusEvent):void {
			inputField.removeEventListener(ComponentEvent.ENTER, onEnter);
			selectedIndex = selectedIndex;
		}
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function onEnter(event:ComponentEvent):void {
			event.stopPropagation();
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function onToggleListVisibility(event:MouseEvent):void {
			event.stopPropagation();
			dispatchEvent(event);
			if (isOpen) {
				close()
			} else {
				open();
				// Add a listener to listen for press/drag/release behavior.
				// We will remove it once they release.
				stage.addEventListener(MouseEvent.MOUSE_UP, onListItemUp, false, 0, true);
			}
		}
		
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function onListItemUp(event:MouseEvent):void {
			if(list==null) return;
			if(event.target==null) return;
			if(stage==null) return;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onListItemUp);
			if (!(event.target is ICellRenderer ) || !list.contains(event.target as DisplayObject)) {
				return;
			}
			
			editableValue = null;
			var startIndex = selectedIndex;
			if(event.target.listData==null) return;
			selectedIndex = event.target.listData.index;
			
			if (startIndex != selectedIndex) {
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			close();			
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function onListChange(event:Event):void {
			editableValue = null;
			dispatchEvent(event);
			invalidate(InvalidationType.SELECTED);
			if (isKeyDown) { return; }
			close();
		}
		/**
		 * @private (protected)
		 */
		protected function onStageClick(event:MouseEvent):void {
			if (!isOpen) { return; }
			if (! contains(event.target as DisplayObject) && !list.contains(event.target as DisplayObject)) {
				if (highlightedCell != -1) {
					selectedIndex = highlightedCell;
					dispatchEvent(new Event(Event.CHANGE));
				}
				close();
			}
		}

		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function passEvent(event:Event):void {
			dispatchEvent(event);
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function addCloseListener(event:Event) {
			removeEventListener(Event.ENTER_FRAME, addCloseListener);
			if (!isOpen) { return; }
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick, false, 0, true);
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function onTextInput(event:Event):void {
			// Stop the TextInput CHANGE event
			event.stopPropagation();
			if (!_editable) { return; }
			// If editable, set the editableValue, and dispatch a change event.
			editableValue = inputField.text;
			selectedIndex = -1;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function calculateAvailableHeight():Number {
			var pad:Number = Number(getStyleValue("contentPadding"));
			return list.height-pad*2;
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void {
			isKeyDown = true;
			if (event.ctrlKey) {
				switch (event.keyCode) {
					case Keyboard.UP:
						if (highlightedCell > -1) {
							selectedIndex = highlightedCell;
							dispatchEvent(new Event(Event.CHANGE));
						}
						close();
						// Reset selectedIndex/prompt. Maybe dispatch change.
						break;
					case  Keyboard.DOWN:
						open();
						break;
				}
				return;
			}
			
			event.stopPropagation();
			
			var pageSize:int = Math.max((calculateAvailableHeight() / list.rowHeight)<<0, 1);
			var sel:uint = selectedIndex;
			var lastSel:Number = (highlightedCell == -1) ? selectedIndex : highlightedCell;
			var newSel:int = -1;
			switch (event.keyCode) {
				case Keyboard.SPACE:
					isOpen ? close() : open();
					return;
				case Keyboard.ESCAPE:
					if (isOpen) { 
						if (highlightedCell > -1) {
							selectedIndex = selectedIndex;
						}
						close();
					}
					return;
					
				case Keyboard.UP:
					newSel = Math.max(0, lastSel-1);
					break;
				case Keyboard.DOWN:
					newSel = Math.min(length-1, lastSel+1);
					break;
				case Keyboard.PAGE_UP:
					newSel = Math.max(lastSel - pageSize, 0);
					break;
				case Keyboard.PAGE_DOWN:
					newSel = Math.min(lastSel + pageSize, length - 1);
					break;
				case Keyboard.HOME:
					newSel = 0;
					break;
				case Keyboard.END:
					newSel = length-1;
					break;
					
				case Keyboard.ENTER:
					if (_editable && highlightedCell == -1) {
						editableValue = inputField.text;
						selectedIndex = -1;
					} else if (isOpen && highlightedCell > -1) {
						editableValue = null;
						selectedIndex = highlightedCell;
						dispatchEvent(new Event(Event.CHANGE));
					}
					dispatchEvent(new ComponentEvent(ComponentEvent.ENTER));
					close();
					return;
					
				default:
					if (editable) { break; } // Don't allow letter keys to change focus when editable.
					newSel = list.getNextIndexAtLetter(String.fromCharCode(event.keyCode), lastSel);
					break;
			}
						
			if (newSel > -1) {
				if (isOpen) {
					highlightCell(newSel);
					inputField.text = list.itemToLabel(getItemAt(newSel));
				} else {
					highlightCell();
					selectedIndex = newSel;
					dispatchEvent(new Event(Event.CHANGE));					
				}
			}
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		*/
		protected function highlightCell(index:int=-1):void {
			var renderer:ICellRenderer;
			
			// Turn off the currently highlighted cell
			if (highlightedCell > -1) {
				renderer = list.itemToCellRenderer(getItemAt(highlightedCell));
				if (renderer != null) {
					renderer.setMouseState("up");
				}
			}
			
			if (index == -1) { return; }
						
			// Scroll to the new index, so that the renderer is created
			list.scrollToIndex(index);
			list.drawNow();
			
			// Highlight the cellRenderer at the new index
			renderer = list.itemToCellRenderer(getItemAt(index));
			if (renderer != null) {
				renderer.setMouseState("over");
				highlightedCell = index;
			}
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		*/
		override protected function keyUpHandler(event:KeyboardEvent):void {
			isKeyDown = false;
		}
				
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function initializeAccessibility():void {
			if (ComboBox.createAccessibilityImplementation != null) {
				ComboBox.createAccessibilityImplementation(this);
			}
		}
	}

}