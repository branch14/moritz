/*

	global style definitions for standard components
	
*/

import mx.styles.CSSStyleDeclaration;


// shortcut declarations for following blocks
var s = _global.style;

/*
themeColor
The default highlight color
*/
s.setStyle("themeColor", 0xAABBBB);

/*
Data grid styles
*/
var p = _global.styles.ComboBox = new CSSStyleDeclaration ();
p.setStyle ("alternatingRowColors", [0xFFFFFF, 0xEEEEEE]);
p.setStyle ("hGridLines", false);
p.setStyle ("hGridLineColor", 0xCCCCCC);
p.setStyle ("vGridLineColor", 0xCCCCCC);
dg.setStyle("textSelectedColor", 0x000000);

/*
backgroundColor
The background of a component. This is the only color style that doesn’t inherit its value. The default value is transparent.
*/
s.setStyle ("backgroundColor", 0xFFFFFF);
/*
borderColor
The black section of a three-dimensional border or the color section of a two-dimensional border. The  default value is 0x000000 (black).
*/
//s.setStyle("borderColor", 0x666666);
/*
borderStyle
The component border: either "none", "inset", "outset", or "solid". This style does not inherit its value. The default value is "solid".
*/
s.setStyle ("borderStyle", "outset");
/*
buttonColor
The face of a button and a section of the three-dimensional border. The default value is 0xEFEEEF (light gray).
*/
//s.setStyle("buttonColor", 0xFFFFFF);
/*
color
The text of a component label. The default value is 0x000000 (black).
*/
s.setStyle ("color", 0x222222);
/*
disabledColor
The disabled color for text. The default color is 0x848384 (dark gray).
*/
s.setStyle ("disabledColor", 0x777777);
/*
fontFamily
The font name for text. The default value is _sans.
*/
s.setStyle ("fontFamily", "Tahoma");
s.setStyle ("textFont", "Tahoma");

/*
fontSize
The point size for the font. The default value is 10.
*/
s.setStyle ("fontSize", 11);
/*
fontStyle
The font style: either "normal" or "italic". The default value is "normal".
*/
s.setStyle ("fontStyle", "normal");
/*
fontWeight
The font weight: either "normal" or "bold". The default value is "normal".
*/
s.setStyle ("fontWeight", "normal");
/*
highlightColor
A section of the three-dimensional border. The default value is 0xFFFFFF (white).
*/
//s.setStyle("highlightColor", 0xCCCCCC);
/*
marginLeft
A number indicating the left margin for text. The default value is 0.
*/
s.setStyle ("marginLeft", 0);
/*
marginRight
A number indicating the right margin for text. The default value is 0.
*/
s.setStyle ("marginRight", 0);
/*
scrollTrackColor
The scroll track for a scroll bar. The default value is 0xEFEEEF (light gray).
*/
//s.setStyle("scrollTrackColor", 0xFFFFFF);
/*
shadowColor
A section of the three-dimensional border. The default value is 0x848384 (dark gray).
*/
//s.setStyle("shadowColor", 0x999999);
/*
symbolBackgroundColor
The background color of check boxes and radio buttons. The default value is 0xFFFFFF (white).
*/
//s.setStyle ("symbolBackgroundColor", 0xFFFFFF);
/*
symbolBackgroundDisabledColor
The background color of check boxes and radio buttons when disabled. The default value is 0xEFEEEF (light gray).
*/
//s.setStyle ("symbolBackgroundDisabledColor", 0xEFEEEF);
/*
symbolBackgroundPressedColor
The background color of check boxes and radio 0xEFEEEF when pressed. The default value is 0xFFFFFF (white).
*/
//s.setStyle ("symbolBackgroundPressedColor", 0xFFFFFF);
/*
symbolColor
The check mark of a check box or the dot of a radio button. The default value is 0x000000 (black).
*/
//s.setStyle ("symbolColor", 0x000000);
/*
symbolDisabledColor
The disabled check mark or radio button dot color. The default value is 0x848384 (dark gray).
*/
//s.setStyle ("symbolDisabledColor", 0x848384);
/*
textAlign
The text alignment: either "left", "right", or "center". The default value is "left".
*/
s.setStyle ("textAlign", "left");
/*
textDecoration
The text decoration: either "none" or "underline". The default value is "none".
*/
s.setStyle ("textDecoration", "none");
/*
textIndent
A number indicating the text indent. The default value is 0.
*/
s.setStyle ("textIndent", 0);
s.applyChanges ();
