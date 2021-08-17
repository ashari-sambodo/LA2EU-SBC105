#pragma once

#define BLOWER_USB_SERIAL_VID      4292
#define BLOWER_USB_SERIAL_PID      60000

#define PARTICLE_COUNTER_UART_VID  1027
#define PARTICLE_COUNTER_UART_PID  24577

/// TEI = TIMER EVENT INTERVAL
#ifdef __arm__
#define TEI_FOR_BOARD_IO   100 // ms
#else
#define TEI_FOR_BOARD_IO   1500 // ms
#endif

/// TEI = TIMER EVENT INTERVAL
#ifdef __arm__
#define TEI_FOR_BLOWER_RBMDSI   130 // ms
#else
#define TEI_FOR_BLOWER_RBMDSI   1500 // ms
#endif

#define LEDpca9633_CHANNEL_BL   0
#define LEDpca9633_CHANNEL_WDG  1

#define LCD_DIMM_LEVEL  5

#define ALARMEVENTLOG_MAX_ROW     94608000   // 94,608,000 rows /// if 1 second / 1 event, about 3 years
//#define ALARMEVENTLOG_MAX_ROW     20          ///DEMO
//#define DATALOG_MAX_ROW           5256000     // if 1 log / 1 miniute, for 10 years (5,2jt rows) in Windows for 100.000 rows = 8192KB (8MB) (dbeaver), so for 5jt is about 400MB
#define DATALOG_MAX_ROW             2256000     // if 1 minute / 1 log // for 5 years
//#define DATALOG_MAX_ROW           25          ///DEMO

#define SDEF_UV_MAXIMUM_TIME_LIFE       120000  //minutes or 2000 hours
#define SDEF_FILTER_MAXIMUM_TIME_LIFE   600000  //minutes or 10000 hours

#define SDEY_ENV_TEMP_HIGHEST       15 /// Celcius, this value based on esco airflow sensor
#define SDEY_ENV_TEMP_LOWEST        35 /// Celcius,

//WATCHDOG
#define SDEF_WATCHDOG_PERIOD        60 // seconds
#define SDEF_GPIO_WATCHDOG_GATE     26
#define TIMER_INTERVAL_30_SECOND    30000//ms == 0.5 minute

#define SDEF_FULL_MAC_ADDRESS   "00:00:00:00:00:00#00:00:00:00:00:00#"
#define SDEF_SBC_SERIAL_NUMBER   "0000000000000001"
#define SDEF_SBC_SYS_INFO       "sysInfo"

////////////////////////////////////

#define SKEY_LCD_DELAY_TO_DIMM      "lcdToDimm"
#define SKEY_LCD_BL                 "lcdBl"

#define SKEY_LIGHT_INTENSITY        "lightInt"
#define SKEY_LIGHT_INTENSITY_MIN    "lightIntMinVolt"

#define SKEY_LANGUAGE               "lang"
#define SKEY_TZ                     "tz"
#define SKEY_CLOCK_PERIOD           "clkPrd"

#define SKEY_MEASUREMENT_UNIT       "meaUni"
#define SKEY_CAB_DISPLAY_NAME       "cabDisNam"

#define SKEY_MACH_PROFILE           "machProName"

#define SKEY_SBC_SYS_INFO         "sbcSysInfo"
#define SKEY_SBC_SERIAL_NUMBER         "sbcSN"
///////////////AIRFLOW
//CALIB PHASE; NONE, FACTORY, or FIELD
#define SKEY_AF_CALIB_PHASE             "afCalibPhase"
//FAN
#define SKEY_FAN_PRI_NOM_DCY_FACTORY    "fanPriNomDcyFac"
#define SKEY_FAN_PRI_NOM_RPM_FACTORY    "fanPriNomRpmFac"
//
#define SKEY_FAN_PRI_MIN_DCY_FACTORY    "fanPriMinDcyFac"
#define SKEY_FAN_PRI_MIN_RPM_FACTORY    "fanPriMinRpmFac"
//
#define SKEY_FAN_PRI_STB_DCY_FACTORY    "fanPriStbDcyFac"
#define SKEY_FAN_PRI_STB_RPM_FACTORY    "fanPriStbRpmFac"
//
#define SKEY_FAN_PRI_NOM_DCY_FIELD      "fanPriNomDcyFie"
#define SKEY_FAN_PRI_NOM_RPM_FIELD      "fanPriNomRpmFie"
//
#define SKEY_FAN_PRI_MIN_DCY_FIELD      "fanPriMinDcyFie"
#define SKEY_FAN_PRI_MIN_RPM_FIELD      "fanPriMinRpmFie"
//
#define SKEY_FAN_PRI_STB_DCY_FIELD      "fanPriStbDcyFie"
#define SKEY_FAN_PRI_STB_RPM_FIELD      "fanPriStbRpmFie"
//
//IFA
#define SKEY_IFA_SENSOR_CONST           "ifaSenCon"
#define SKEY_IFA_CAL_VEL_LOW_LIMIT      "ifaLowLim"
#define SKEY_IFA_CAL_TEMP               "ifaCalTem"
#define SKEY_IFA_CAL_TEMP_ADC           "ifaCalTemAdc"
//
#define SKEY_IFA_CAL_ADC_FACTORY        "ifaCalAdcFac"
#define SKEY_IFA_CAL_VEL_FACTORY        "ifaCalVelFac"
//
#define SKEY_IFA_CAL_ADC_FIELD          "ifaCalAdcFie"
#define SKEY_IFA_CAL_VEL_FIELD          "ifaCalVelFie"


//// FULL_CALIBRATION
#define SKEY_IFA_CAL_GRID_NOM           "ifaCalGridNom"
#define SKEY_IFA_CAL_GRID_NOM_VOL       "ifaCalGridNomVol"
#define SKEY_IFA_CAL_GRID_NOM_VEL       "ifaCalGridNomVel"
#define SKEY_IFA_CAL_GRID_NOM_TOT       "ifaCalGridNomTot"
#define SKEY_IFA_CAL_GRID_NOM_AVG       "ifaCalGridNomAvg"
#define SKEY_IFA_CAL_GRID_NOM_DCY       "ifaCalGridNomDcy"
#define SKEY_IFA_CAL_GRID_NOM_RPM       "ifaCalGridNomRpm"
#define SKEY_IFA_CAL_GRID_NOM_VOL_IMP   "ifaCalGridNomVolImp"
#define SKEY_IFA_CAL_GRID_NOM_VEL_IMP   "ifaCalGridNomVelImp"
#define SKEY_IFA_CAL_GRID_NOM_TOT_IMP   "ifaCalGridNomTotImp"
#define SKEY_IFA_CAL_GRID_NOM_AVG_IMP   "ifaCalGridNomAvgImp"
#define SKEY_IFA_CAL_GRID_NOM_DCY_IMP   "ifaCalGridNomDcyImp"
#define SKEY_IFA_CAL_GRID_NOM_RPM_IMP   "ifaCalGridNomRpmImp"

//// FIELD_CALIBRATION
#define SKEY_IFA_CAL_GRID_NOM_FIL       "ifaCalGridNomFil"
#define SKEY_IFA_CAL_GRID_NOM_VOL_FIL   "ifaCalGridNomVolFil"
#define SKEY_IFA_CAL_GRID_NOM_VEL_FIL   "ifaCalGridNomVelFil"
#define SKEY_IFA_CAL_GRID_NOM_TOT_FIL   "ifaCalGridNomTotFil"
#define SKEY_IFA_CAL_GRID_NOM_AVG_FIL   "ifaCalGridNomAvgFil"
#define SKEY_IFA_CAL_GRID_NOM_DCY_FIL   "ifaCalGridNomDcyFil"
#define SKEY_IFA_CAL_GRID_NOM_RPM_FIL   "ifaCalGridNomRpmFil"
#define SKEY_IFA_CAL_GRID_NOM_VOL_FIL_IMP   "ifaCalGridNomVolFilImp"
#define SKEY_IFA_CAL_GRID_NOM_VEL_FIL_IMP   "ifaCalGridNomVelFilImp"
#define SKEY_IFA_CAL_GRID_NOM_TOT_FIL_IMP   "ifaCalGridNomTotFilImp"
#define SKEY_IFA_CAL_GRID_NOM_AVG_FIL_IMP   "ifaCalGridNomAvgFilImp"
#define SKEY_IFA_CAL_GRID_NOM_DCY_FIL_IMP   "ifaCalGridNomDcyFilImp"
#define SKEY_IFA_CAL_GRID_NOM_RPM_FIL_IMP   "ifaCalGridNomRpmFilImp"

//
#define SKEY_IFA_CAL_GRID_MIN           "ifaCalGridMin"
#define SKEY_IFA_CAL_GRID_MIN_VOL       "ifaCalGridMinVol"
#define SKEY_IFA_CAL_GRID_MIN_VEL       "ifaCalGridMinVel"
#define SKEY_IFA_CAL_GRID_MIN_TOT       "ifaCalGridMinTot"
#define SKEY_IFA_CAL_GRID_MIN_AVG       "ifaCalGridMinAvg"
#define SKEY_IFA_CAL_GRID_MIN_DCY       "ifaCalGridMinDcy"
#define SKEY_IFA_CAL_GRID_MIN_RPM       "ifaCalGridMinRpm"
#define SKEY_IFA_CAL_GRID_MIN_VOL_IMP       "ifaCalGridMinVolImp"
#define SKEY_IFA_CAL_GRID_MIN_VEL_IMP       "ifaCalGridMinVelImp"
#define SKEY_IFA_CAL_GRID_MIN_TOT_IMP       "ifaCalGridMinTotImp"
#define SKEY_IFA_CAL_GRID_MIN_AVG_IMP       "ifaCalGridMinAvgImp"
#define SKEY_IFA_CAL_GRID_MIN_DCY_IMP       "ifaCalGridMinDcyImp"
#define SKEY_IFA_CAL_GRID_MIN_RPM_IMP       "ifaCalGridMinRpmImp"
//
#define SKEY_IFA_CAL_GRID_STB           "ifaCalGridStb"
#define SKEY_IFA_CAL_GRID_STB_VOL       "ifaCalGridStbVol"
#define SKEY_IFA_CAL_GRID_STB_VEL       "ifaCalGridStbVel"
#define SKEY_IFA_CAL_GRID_STB_TOT       "ifaCalGridStbTot"
#define SKEY_IFA_CAL_GRID_STB_AVG       "ifaCalGridStbAvg"
#define SKEY_IFA_CAL_GRID_STB_DCY       "ifaCalGridStbDcy"
#define SKEY_IFA_CAL_GRID_STB_RPM       "ifaCalGridStbRpm"
#define SKEY_IFA_CAL_GRID_STB_VOL_IMP       "ifaCalGridStbVolImp"
#define SKEY_IFA_CAL_GRID_STB_VEL_IMP       "ifaCalGridStbVelImp"
#define SKEY_IFA_CAL_GRID_STB_TOT_IMP       "ifaCalGridStbTotImp"
#define SKEY_IFA_CAL_GRID_STB_AVG_IMP       "ifaCalGridStbAvgImp"
#define SKEY_IFA_CAL_GRID_STB_DCY_IMP       "ifaCalGridStbDcyImp"
#define SKEY_IFA_CAL_GRID_STB_RPM_IMP       "ifaCalGridStbRpmImp"
//
#define SKEY_IFA_CAL_GRID_NOM_SEC_FIL       "ifaCalGridNomSecFil"
#define SKEY_IFA_CAL_GRID_NOM_SEC_TOT_FIL   "ifaCalGridNomTotSecFil"
#define SKEY_IFA_CAL_GRID_NOM_SEC_AVG_FIL   "ifaCalGridNomAvgSecFil"
#define SKEY_IFA_CAL_GRID_NOM_SEC_VEL_FIL   "ifaCalGridNomVelSecFil"
#define SKEY_IFA_CAL_GRID_NOM_SEC_DCY_FIL   "ifaCalGridNomDcySecFil"
#define SKEY_IFA_CAL_GRID_NOM_SEC_RPM_FIL   "ifaCalGridNomRpmSecFil"
#define SKEY_IFA_CAL_GRID_NOM_SEC_TOT_FIL_IMP   "ifaCalGridNomTotSecFilImp"
#define SKEY_IFA_CAL_GRID_NOM_SEC_AVG_FIL_IMP   "ifaCalGridNomAvgSecFilImp"
#define SKEY_IFA_CAL_GRID_NOM_SEC_VEL_FIL_IMP   "ifaCalGridNomVelSecFilImp"
#define SKEY_IFA_CAL_GRID_NOM_SEC_DCY_FIL_IMP   "ifaCalGridNomDcySecFilImp"
#define SKEY_IFA_CAL_GRID_NOM_SEC_RPM_FIL_IMP   "ifaCalGridNomRpmSecFilImp"
//DFA
//#define SKEY_DFA_SENSOR_CONST           "dfaSenCon"
//#define SKEY_DFA_VEL_LOWEST_LIMIT       "dfaLowLim"
//
//#define SKEY_DFA_CAL_ADC_FACTORY        "dfaCalAdcFac"
#define SKEY_DFA_CAL_VEL_FACTORY        "dfaCalVelFac"
//#define SKEY_DFA_CAL_TEMP_FACTORY       "dfaCalTemFac"
//#define SKEY_DFA_CAL_TEMP_ADC_FACTORY   "dfaCalTemAdcFac"
//
//#define SKEY_DFA_CAL_ADC_FIELD          "dfaCalAdcFie"
#define SKEY_DFA_CAL_VEL_FIELD          "dfaCalVelFie"
//#define SKEY_DFA_CAL_TEMP_FIELD         "dfaCalTemFie"
//#define SKEY_DFA_CAL_TEMP_ADC_FIELD     "dfaCalTemAdcFie"


//// FULL CALIBRATION
#define SKEY_DFA_CAL_GRID_NOM           "dfaCalGridNom"
#define SKEY_DFA_CAL_GRID_NOM_VEL       "dfaCalGridNomVel"
#define SKEY_DFA_CAL_GRID_NOM_VEL_TOT   "dfaCalGridNomVelTot"
#define SKEY_DFA_CAL_GRID_NOM_VEL_LOW   "dfaCalGridNomVelLow"
#define SKEY_DFA_CAL_GRID_NOM_VEL_HIGH  "dfaCalGridNomVelHigh"
#define SKEY_DFA_CAL_GRID_NOM_VEL_DEV   "dfaCalGridNomVelDev"
#define SKEY_DFA_CAL_GRID_NOM_VEL_DEVP  "dfaCalGridNomVelDevp"

#define SKEY_DFA_CAL_GRID_NOM_VEL_IMP     "dfaCalGridNomVelImp"
#define SKEY_DFA_CAL_GRID_NOM_VEL_TOT_IMP   "dfaCalGridNomVelTotImp"
#define SKEY_DFA_CAL_GRID_NOM_VEL_LOW_IMP   "dfaCalGridNomVelLowImp"
#define SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_IMP  "dfaCalGridNomVelHighImp"
#define SKEY_DFA_CAL_GRID_NOM_VEL_DEV_IMP   "dfaCalGridNomVelDevImp"
#define SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_IMP  "dfaCalGridNomVelDevpImp"

//// FIELD CALIBRATION
#define SKEY_DFA_CAL_GRID_NOM_FIL           "dfaCalGridNomFil"
#define SKEY_DFA_CAL_GRID_NOM_VEL_FIL       "dfaCalGridNomVelFil"
#define SKEY_DFA_CAL_GRID_NOM_VEL_TOT_FIL   "dfaCalGridNomVelTotFil"
#define SKEY_DFA_CAL_GRID_NOM_VEL_LOW_FIL   "dfaCalGridNomVelLowFil"
#define SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_FIL  "dfaCalGridNomVelHighFil"
#define SKEY_DFA_CAL_GRID_NOM_VEL_DEV_FIL   "dfaCalGridNomVelDevFil"
#define SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_FIL  "dfaCalGridNomVelDevpFil"
#define SKEY_DFA_CAL_GRID_NOM_VEL_FIL_IMP       "dfaCalGridNomVelFilImp"
#define SKEY_DFA_CAL_GRID_NOM_VEL_TOT_FIL_IMP   "dfaCalGridNomVelTotFilImp"
#define SKEY_DFA_CAL_GRID_NOM_VEL_LOW_FIL_IMP   "dfaCalGridNomVelLowFilImp"
#define SKEY_DFA_CAL_GRID_NOM_VEL_HIGH_FIL_IMP  "dfaCalGridNomVelHighFilImp"
#define SKEY_DFA_CAL_GRID_NOM_VEL_DEV_FIL_IMP   "dfaCalGridNomVelDevFilImp"
#define SKEY_DFA_CAL_GRID_NOM_VEL_DEVP_FIL_IMP  "dfaCalGridNomVelDevpFilImp"

//DATALOG
#define SKEY_DATALOG_ENABLE             "dtLogEn"
#define SKEY_DATALOG_PERIOD             "dtLogPer"

#define SKEY_GAS_INSTALLED              "gasIns"
#define SKEY_SOCKET_INSTALLED           "sokIns"
#define SKEY_UV_INSTALLED               "uvIns"
#define SKEY_SASH_MOTOR_INSTALLED       "smIns"

#define SKEY_OPERATION_MODE             "opMod"

#define SKEY_FAN_PIN                    "fanPin"

#define SKEY_SECURITY_ACCESS_MODE       "saMod"

#define SKEY_ELS_ENABLE                 "elsEn"

#define SKEY_CALENDER_REMAINDER_MODE    "crMod"

#define SKEY_WARMUP_TIME                "wuTm"

#define SKEY_POSTPURGE_TIME             "ppTm"

#define SKEY_UV_TIME                    "uvTm"
#define SKEY_UV_METER                   "uvMet"

#define SKEY_SASH_CYCLE_METER           "sasCycMet"

#define SKEY_FILTER_METER               "flMet"
#define SKEY_FAN_METER                  "fanMet"

#define SKEY_POWER_OUTAGE               "pwOa"
#define SKEY_POWER_OUTAGE_TIME          "pwOat"
#define SKEY_POWER_OUTAGE_RTIME         "pwOatr"

#define SKEY_POWER_OUTAGE_FAN           "pwlFan"
#define SKEY_POWER_OUTAGE_LIGHT         "pwlLig"
#define SKEY_POWER_OUTAGE_UV            "pwlUV"

#define SKEY_SEAS_BOARD_FLAP_INSTALLED  "epmFlapAv"

#define SKEY_SEAS_INSTALLED             "epmAv"
#define SKEY_SEAS_FAIL_POINT_PA         "epmFail"
#define SKEY_SEAS_NOM_POINT_PA          "epmNom"
#define SKEY_SEAS_OFFSET_PA             "epmOffset"

#define SKEY_MUTE_ALARM_TIME            "mutAlt"
#define SKEY_SERIAL_NUMMBER             "serNum"

#define SKEY_MODBUS_SLAVE_ID            "modSlvID"
#define SKEY_MODBUS_ALLOW_IP            "modAlwIp"
#define SKEY_MODBUS_RW_FAN              "modRwFan"
#define SKEY_MODBUS_RW_LAMP             "modRwLamp"
#define SKEY_MODBUS_RW_LAMP_DIMM        "modRwLampDimm"
#define SKEY_MODBUS_RW_SOCKET           "modRwSock"
#define SKEY_MODBUS_RW_GAS              "modRwGas"
#define SKEY_MODBUS_RW_UV               "modRwUv"

#define SKEY_SCHEO_UV_ENABLE            "scoUvEn"
#define SKEY_SCHEO_UV_TIME              "scoUvTime"
#define SKEY_SCHEO_UV_REPEAT            "scoUvRep"
#define SKEY_SCHEO_UV_REPEAT_DAY        "scoUvRepd"

#define SKEY_SCHEO_FAN_ENABLE           "scoFanEn"
#define SKEY_SCHEO_FAN_TIME             "scoFanTime"
#define SKEY_SCHEO_FAN_REPEAT           "scoFanRep"
#define SKEY_SCHEO_FAN_REPEAT_DAY       "scoFanRepd"

#define SKEY_ENV_TEMP_HIGH_LIMIT        "envHig"
#define SKEY_ENV_TEMP_LOW_LIMIT         "envLow"

#define SKEY_PARTICLE_COUNTER_INST      "paCoIn"
#define SKEY_SHIPPING_MOD_ENABLE        "shiMod"

#define SKEY_AF_MONITOR_ENABLE          "afMonEn"
