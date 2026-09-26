class SQC_Menu
{
    idd = 7800;
    movingEnable = 0;
    enableSimulation = 1;
    enableDisplay = 1;
    onLoad = "uiNamespace setVariable ['SQC_Menu', _this select 0]; [] call SQC_fnc_uiRefreshMenu;";
    onUnload = "uiNamespace setVariable ['SQC_Menu', displayNull];";

    class ControlsBackground
    {
        class Veil : SQC_RscText
        {
            idc = -1;
            x = safeZoneX;
            y = safeZoneY;
            w = safeZoneW;
            h = safeZoneH;
            colorBackground[] = {0.01,0.012,0.015,0.82};
        };

        class HeaderBar : SQC_RscText
        {
            idc = -1;
            x = safeZoneX;
            y = safeZoneY + (0.075 * safeZoneH);
            w = safeZoneW;
            h = 0.004 * safeZoneH;
            colorBackground[] = {0.95,0.34,0.035,0.95};
        };

        class LeftRail : SQC_RscText
        {
            idc = -1;
            x = safeZoneX + (0.055 * safeZoneW);
            y = safeZoneY + (0.175 * safeZoneH);
            w = 0.265 * safeZoneW;
            h = 0.610 * safeZoneH;
            colorBackground[] = {0.025,0.030,0.035,0.76};
        };

        class DetailRail : SQC_RscText
        {
            idc = -1;
            x = safeZoneX + (0.345 * safeZoneW);
            y = safeZoneY + (0.175 * safeZoneH);
            w = 0.600 * safeZoneW;
            h = 0.610 * safeZoneH;
            colorBackground[] = {0.025,0.030,0.035,0.58};
        };
    };

    class Controls
    {
        class Title : SQC_RscText
        {
            idc = -1;
            text = "MULTIPLAYER";
            font = "PuristaSemibold";
            sizeEx = 0.055 * safeZoneH;
            x = safeZoneX + (0.055 * safeZoneW);
            y = safeZoneY + (0.090 * safeZoneH);
            w = 0.330 * safeZoneW;
            h = 0.065 * safeZoneH;
        };

        class Mode : SQC_RscText
        {
            idc = -1;
            text = "TEAM DEATHMATCH  //  AGIA MARINA";
            font = "PuristaMedium";
            sizeEx = 0.022 * safeZoneH;
            x = safeZoneX + (0.345 * safeZoneW);
            y = safeZoneY + (0.112 * safeZoneH);
            w = 0.450 * safeZoneW;
            h = 0.032 * safeZoneH;
            colorText[] = {0.62,0.65,0.68,1};
        };

        class CreateClassLabel : SQC_RscText
        {
            idc = -1;
            text = "CREATE A CLASS";
            font = "PuristaSemibold";
            sizeEx = 0.024 * safeZoneH;
            x = safeZoneX + (0.070 * safeZoneW);
            y = safeZoneY + (0.195 * safeZoneH);
            w = 0.220 * safeZoneW;
            h = 0.035 * safeZoneH;
            colorText[] = {0.95,0.34,0.035,1};
        };

        class Assault : SQC_RscButton
        {
            idc = 7810;
            text = "ASSAULT";
            x = safeZoneX + (0.070 * safeZoneW);
            y = safeZoneY + (0.245 * safeZoneH);
            w = 0.225 * safeZoneW;
            h = 0.055 * safeZoneH;
            onButtonClick = "['ASSAULT'] call SQC_fnc_uiSelectClass;";
        };

        class SMG : Assault
        {
            idc = 7811;
            text = "SMG";
            y = safeZoneY + (0.305 * safeZoneH);
            onButtonClick = "['SMG'] call SQC_fnc_uiSelectClass;";
        };

        class LMG : Assault
        {
            idc = 7812;
            text = "LMG";
            y = safeZoneY + (0.365 * safeZoneH);
            onButtonClick = "['LMG'] call SQC_fnc_uiSelectClass;";
        };

        class Marksman : Assault
        {
            idc = 7813;
            text = "MARKSMAN";
            y = safeZoneY + (0.425 * safeZoneH);
            onButtonClick = "['MARKSMAN'] call SQC_fnc_uiSelectClass;";
        };

        class Shotgun : Assault
        {
            idc = 7814;
            text = "SHOTGUN";
            y = safeZoneY + (0.485 * safeZoneH);
            onButtonClick = "['SHOTGUN'] call SQC_fnc_uiSelectClass;";
        };

        class Deploy : SQC_RscButton
        {
            idc = 7820;
            text = "DEPLOY";
            x = safeZoneX + (0.070 * safeZoneW);
            y = safeZoneY + (0.675 * safeZoneH);
            w = 0.225 * safeZoneW;
            h = 0.060 * safeZoneH;
            colorBackground[] = {0.95,0.34,0.035,0.94};
            colorBackgroundActive[] = {1.00,0.45,0.08,1};
            colorFocused[] = {1.00,0.45,0.08,1};
            onButtonClick = "[] call SQC_fnc_loadoutDeploySelected; closeDialog 0;";
        };

        class ClassHeader : SQC_RscText
        {
            idc = 7830;
            text = "ASSAULT";
            font = "PuristaSemibold";
            sizeEx = 0.050 * safeZoneH;
            x = safeZoneX + (0.375 * safeZoneW);
            y = safeZoneY + (0.205 * safeZoneH);
            w = 0.350 * safeZoneW;
            h = 0.060 * safeZoneH;
        };

        class ClassSub : SQC_RscText
        {
            idc = 7831;
            text = "BALANCED MID-RANGE";
            font = "PuristaMedium";
            sizeEx = 0.022 * safeZoneH;
            x = safeZoneX + (0.378 * safeZoneW);
            y = safeZoneY + (0.267 * safeZoneH);
            w = 0.330 * safeZoneW;
            h = 0.032 * safeZoneH;
            colorText[] = {0.95,0.34,0.035,1};
        };

        class PrimaryLabel : SQC_RscText
        {
            idc = -1;
            text = "PRIMARY";
            font = "PuristaSemibold";
            sizeEx = 0.021 * safeZoneH;
            x = safeZoneX + (0.378 * safeZoneW);
            y = safeZoneY + (0.340 * safeZoneH);
            w = 0.130 * safeZoneW;
            h = 0.030 * safeZoneH;
            colorText[] = {0.55,0.58,0.61,1};
        };

        class PrimaryValue : SQC_RscText
        {
            idc = 7832;
            text = "MX 6.5 MM";
            font = "PuristaSemibold";
            sizeEx = 0.034 * safeZoneH;
            x = safeZoneX + (0.378 * safeZoneW);
            y = safeZoneY + (0.372 * safeZoneH);
            w = 0.350 * safeZoneW;
            h = 0.045 * safeZoneH;
        };

        class RoleLabel : SQC_RscText
        {
            idc = -1;
            text = "ROLE";
            font = "PuristaSemibold";
            sizeEx = 0.021 * safeZoneH;
            x = safeZoneX + (0.378 * safeZoneW);
            y = safeZoneY + (0.455 * safeZoneH);
            w = 0.130 * safeZoneW;
            h = 0.030 * safeZoneH;
            colorText[] = {0.55,0.58,0.61,1};
        };

        class RoleValue : SQC_RscStructuredText
        {
            idc = 7833;
            text = "";
            x = safeZoneX + (0.378 * safeZoneW);
            y = safeZoneY + (0.490 * safeZoneH);
            w = 0.500 * safeZoneW;
            h = 0.135 * safeZoneH;
            size = 0.026 * safeZoneH;
        };

        class Tip : SQC_RscText
        {
            idc = -1;
            text = "SELECT A CLASS  //  DEPLOY TO RETURN TO THE FIGHT";
            font = "PuristaMedium";
            sizeEx = 0.019 * safeZoneH;
            x = safeZoneX + (0.055 * safeZoneW);
            y = safeZoneY + (0.815 * safeZoneH);
            w = 0.600 * safeZoneW;
            h = 0.030 * safeZoneH;
            colorText[] = {0.48,0.50,0.52,1};
        };
    };
};
