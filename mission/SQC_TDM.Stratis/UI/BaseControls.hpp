class SQC_RscText
{
    access = 0;
    type = 0;
    idc = -1;
    style = 0;
    linespacing = 1;
    colorBackground[] = {0,0,0,0};
    colorText[] = {0.92,0.94,0.96,1};
    text = "";
    shadow = 1;
    font = "PuristaMedium";
    sizeEx = 0.03;
    fixedWidth = 0;
};

class SQC_RscStructuredText
{
    access = 0;
    type = 13;
    idc = -1;
    style = 0;
    colorText[] = {0.92,0.94,0.96,1};
    colorBackground[] = {0,0,0,0};
    text = "";
    size = 0.03;
    shadow = 1;

    class Attributes
    {
        font = "PuristaMedium";
        color = "#EBEFF4";
        align = "left";
        valign = "middle";
        shadow = 1;
        shadowColor = "#000000";
        size = "1";
    };
};

class SQC_RscButton
{
    access = 0;
    type = 1;
    idc = -1;
    style = 0;
    text = "";
    font = "PuristaSemibold";
    sizeEx = 0.035;
    colorText[] = {0.92,0.94,0.96,1};
    colorDisabled[] = {0.45,0.45,0.45,1};
    colorBackground[] = {0.055,0.065,0.075,0.88};
    colorBackgroundDisabled[] = {0.04,0.04,0.04,0.65};
    colorBackgroundActive[] = {0.95,0.34,0.035,0.96};
    colorFocused[] = {0.95,0.34,0.035,0.96};
    colorShadow[] = {0,0,0,0.7};
    colorBorder[] = {0,0,0,0};
    borderSize = 0;
    shadow = 1;
    offsetX = 0;
    offsetY = 0;
    offsetPressedX = 0;
    offsetPressedY = 0;
    soundEnter[] = {"",0.08,1};
    soundPush[] = {"",0.08,1};
    soundClick[] = {"",0.08,1};
    soundEscape[] = {"",0.08,1};
};

class SQC_RscPicture
{
    access = 0;
    type = 0;
    idc = -1;
    style = 48;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    font = "PuristaMedium";
    sizeEx = 0;
    lineSpacing = 0;
    text = "";
    fixedWidth = 0;
    shadow = 0;
};
