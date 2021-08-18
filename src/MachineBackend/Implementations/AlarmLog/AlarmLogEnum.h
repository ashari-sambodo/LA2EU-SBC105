#pragma once

enum ALARM_LOG_CODE {
    ALC_SASH_WINDOW_OK = 100,
    ALC_SASH_WINDOW_UNSAFE,
    ALC_SASH_WINDOW_FULLY_OPEN,
    ALC_SASH_WINDOW_ERROR,
    ALC_INFLOW_ALARM_OK = 200,
    ALC_INFLOW_ALARM_LOW,
    ALC_SEAS_OK = 300,
    ALC_SEAS_HIGH,
    ALC_SEAS_FLAP_OK,
    ALC_SEAS_FLAP_LOW,
    ALC_ENV_TEMP_OK = 400,
    ALC_ENV_TEMP_LOW,
    ALC_ENV_TEMP_HIGH,
};