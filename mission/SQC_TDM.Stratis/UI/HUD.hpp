class SQC_HUD
{
    idd = 7700;
    movingEnable = 0;
    enableSimulation = 1;
    duration = 1e+10;
    fadeIn = 0;
    fadeOut = 0;
    onLoad = "uiNamespace setVariable ['SQC_HUD', _this select 0];";
    onUnload = "uiNamespace setVariable ['SQC_HUD', displayNull];";

    class Controls
    {
        class MinimapShadow : SQC_RscText
        {
            idc = 7701;
            x = safeZoneX + (0.018 * safeZoneW);
            y = safeZoneY + (0.025 * safeZoneH);
            w = 0.188 * safeZoneW;
            h = 0.245 * safeZoneH;
            colorBackground[] = {0.01,0.015,0.02,0.70};
        };

        class MinimapAccent : SQC_RscText
        {
            idc = 7702;
            x = safeZoneX + (0.018 * safeZoneW);
            y = safeZoneY + (0.025 * safeZoneH);
            w = 0.004 * safeZoneW;
            h = 0.245 * safeZoneH;
            colorBackground[] = {0.95,0.34,0.035,0.90};
        };

        class Minimap : RscMapControl
        {
            idc = 7703;
            x = safeZoneX + (0.024 * safeZoneW);
            y = safeZoneY + (0.033 * safeZoneH);
            w = 0.176 * safeZoneW;
            h = 0.200 * safeZoneH;
            colorBackground[] = {0.04,0.05,0.055,0.96};
            colorOutside[] = {0.01,0.01,0.01,1};
            maxSatelliteAlpha = 0;
            alphaFadeStartScale = 0;
            alphaFadeEndScale = 0;
            onDraw = "_this call SQC_fnc_uiMapDraw;";
        };

        class Compass : SQC_RscText
        {
            idc = 7704;
            text = "W              N              E";
            font = "PuristaSemibold";
            sizeEx = 0.025 * safeZoneH;
            x = safeZoneX + (0.026 * safeZoneW);
            y = safeZoneY + (0.236 * safeZoneH);
            w = 0.170 * safeZoneW;
            h = 0.025 * safeZoneH;
            colorText[] = {0.70,0.72,0.74,0.95};
        };

        class Feed : SQC_RscStructuredText
        {
            idc = 7710;
            x = safeZoneX + (0.020 * safeZoneW);
            y = safeZoneY + (0.555 * safeZoneH);
            w = 0.355 * safeZoneW;
            h = 0.150 * safeZoneH;
            size = 0.027 * safeZoneH;
        };

        class MatchBack : SQC_RscText
        {
            idc = 7720;
            x = safeZoneX + (0.018 * safeZoneW);
            y = safeZoneY + (0.795 * safeZoneH);
            w = 0.225 * safeZoneW;
            h = 0.165 * safeZoneH;
            colorBackground[] = {0.01,0.015,0.02,0.70};
        };

        class MatchAccent : SQC_RscText
        {
            idc = 7721;
            x = safeZoneX + (0.018 * safeZoneW);
            y = safeZoneY + (0.795 * safeZoneH);
            w = 0.004 * safeZoneW;
            h = 0.165 * safeZoneH;
            colorBackground[] = {0.95,0.34,0.035,0.90};
        };

        class Time : SQC_RscText
        {
            idc = 7722;
            text = "10:00";
            font = "PuristaSemibold";
            sizeEx = 0.030 * safeZoneH;
            x = safeZoneX + (0.030 * safeZoneW);
            y = safeZoneY + (0.802 * safeZoneH);
            w = 0.072 * safeZoneW;
            h = 0.035 * safeZoneH;
        };

        class MatchState : SQC_RscText
        {
            idc = 7723;
            text = "TIED";
            font = "PuristaSemibold";
            sizeEx = 0.023 * safeZoneH;
            x = safeZoneX + (0.105 * safeZoneW);
            y = safeZoneY + (0.806 * safeZoneH);
            w = 0.095 * safeZoneW;
            h = 0.030 * safeZoneH;
            colorText[] = {0.75,0.78,0.80,1};
        };

        class TeamGlyph : SQC_RscText
        {
            idc = 7724;
            text = "V";
            font = "PuristaSemibold";
            style = 2;
            sizeEx = 0.060 * safeZoneH;
            x = safeZoneX + (0.027 * safeZoneW);
            y = safeZoneY + (0.844 * safeZoneH);
            w = 0.060 * safeZoneW;
            h = 0.070 * safeZoneH;
            colorText[] = {0.25,0.80,0.95,0.95};
        };

        class FriendlyScore : SQC_RscText
        {
            idc = 7725;
            text = "0";
            font = "PuristaSemibold";
            style = 2;
            sizeEx = 0.052 * safeZoneH;
            x = safeZoneX + (0.088 * safeZoneW);
            y = safeZoneY + (0.838 * safeZoneH);
            w = 0.055 * safeZoneW;
            h = 0.060 * safeZoneH;
        };

        class EnemyScore : SQC_RscText
        {
            idc = 7726;
            text = "0";
            font = "PuristaSemibold";
            style = 2;
            sizeEx = 0.035 * safeZoneH;
            x = safeZoneX + (0.148 * safeZoneW);
            y = safeZoneY + (0.847 * safeZoneH);
            w = 0.045 * safeZoneW;
            h = 0.050 * safeZoneH;
            colorText[] = {0.72,0.72,0.72,1};
        };

        class ScoreLimit : SQC_RscText
        {
            idc = 7727;
            text = "75 POINTS TO WIN";
            font = "PuristaMedium";
            sizeEx = 0.019 * safeZoneH;
            x = safeZoneX + (0.030 * safeZoneW);
            y = safeZoneY + (0.923 * safeZoneH);
            w = 0.170 * safeZoneW;
            h = 0.025 * safeZoneH;
            colorText[] = {0.60,0.62,0.64,1};
        };

        class Streak1 : SQC_RscText
        {
            idc = 7730;
            text = "UAV";
            font = "PuristaSemibold";
            style = 2;
            sizeEx = 0.021 * safeZoneH;
            x = safeZoneX + (0.932 * safeZoneW);
            y = safeZoneY + (0.530 * safeZoneH);
            w = 0.050 * safeZoneW;
            h = 0.050 * safeZoneH;
            colorBackground[] = {0.03,0.035,0.04,0.68};
            colorText[] = {0.55,0.57,0.59,1};
        };

        class Streak2 : Streak1
        {
            idc = 7731;
            text = "CUAV";
            y = safeZoneY + (0.585 * safeZoneH);
        };

        class Streak3 : Streak1
        {
            idc = 7732;
            text = "SUP";
            y = safeZoneY + (0.640 * safeZoneH);
        };

        class WeaponBack : SQC_RscText
        {
            idc = 7740;
            x = safeZoneX + (0.785 * safeZoneW);
            y = safeZoneY + (0.835 * safeZoneH);
            w = 0.197 * safeZoneW;
            h = 0.125 * safeZoneH;
            colorBackground[] = {0.01,0.015,0.02,0.60};
        };

        class WeaponAccent : SQC_RscText
        {
            idc = 7741;
            x = safeZoneX + (0.978 * safeZoneW);
            y = safeZoneY + (0.835 * safeZoneH);
            w = 0.004 * safeZoneW;
            h = 0.125 * safeZoneH;
            colorBackground[] = {0.95,0.34,0.035,0.90};
        };

        class WeaponName : SQC_RscText
        {
            idc = 7742;
            text = "PRIMARY";
            font = "PuristaSemibold";
            sizeEx = 0.023 * safeZoneH;
            x = safeZoneX + (0.797 * safeZoneW);
            y = safeZoneY + (0.840 * safeZoneH);
            w = 0.130 * safeZoneW;
            h = 0.030 * safeZoneH;
        };

        class FireMode : SQC_RscText
        {
            idc = 7743;
            text = "FULL-AUTO";
            font = "PuristaMedium";
            style = 1;
            sizeEx = 0.018 * safeZoneH;
            x = safeZoneX + (0.905 * safeZoneW);
            y = safeZoneY + (0.843 * safeZoneH);
            w = 0.060 * safeZoneW;
            h = 0.025 * safeZoneH;
            colorText[] = {0.60,0.62,0.64,1};
        };

        class LoadedAmmo : SQC_RscText
        {
            idc = 7744;
            text = "30";
            font = "PuristaSemibold";
            style = 1;
            sizeEx = 0.052 * safeZoneH;
            x = safeZoneX + (0.830 * safeZoneW);
            y = safeZoneY + (0.875 * safeZoneH);
            w = 0.075 * safeZoneW;
            h = 0.060 * safeZoneH;
        };

        class AmmoSlash : SQC_RscText
        {
            idc = 7745;
            text = "/";
            font = "PuristaSemibold";
            style = 2;
            sizeEx = 0.036 * safeZoneH;
            x = safeZoneX + (0.906 * safeZoneW);
            y = safeZoneY + (0.885 * safeZoneH);
            w = 0.020 * safeZoneW;
            h = 0.045 * safeZoneH;
            colorText[] = {0.70,0.72,0.74,1};
        };

        class ReserveAmmo : SQC_RscText
        {
            idc = 7746;
            text = "90";
            font = "PuristaSemibold";
            sizeEx = 0.036 * safeZoneH;
            x = safeZoneX + (0.929 * safeZoneW);
            y = safeZoneY + (0.885 * safeZoneH);
            w = 0.050 * safeZoneW;
            h = 0.045 * safeZoneH;
            colorText[] = {0.80,0.82,0.84,1};
        };

        class Equipment : SQC_RscText
        {
            idc = 7747;
            text = "LETHAL 1     TACTICAL 1";
            font = "PuristaMedium";
            style = 1;
            sizeEx = 0.017 * safeZoneH;
            x = safeZoneX + (0.820 * safeZoneW);
            y = safeZoneY + (0.932 * safeZoneH);
            w = 0.150 * safeZoneW;
            h = 0.022 * safeZoneH;
            colorText[] = {0.55,0.57,0.59,1};
        };
    };
};
