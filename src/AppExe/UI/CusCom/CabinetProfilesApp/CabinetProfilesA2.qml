/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

QtObject {
    //// Version 1 UUID Generator
    //// https://www.uuidgenerator.net/

    readonly property var profiles: [
        {
            "name": "-",
        },
        ///////////////////////// AC2
        ///// SASH 8 Inch
        ///// 3 Feet
        {"name": "LA2-3|EU", "profilelId": "a9c3e3ba-f688-11eb-9a03-0242ac130003",
            "modelBase": 1,
            "classStr": "CLASS II",
            "modelStr": "LA2 EU",
            //"sideGlass": 1,
            "width": {
                "meter": 0.9144 /*meter = 3 Feet*/,
                "feet": 3
            },
            "sashWindow": 7.874,//200 mm
            "fan": {
                /// Get From LA2 3 feet profile
                //                "hoursePower": 0.75,
                //                "direction": 1,
                //                "highSpeedLimit": 1292,
                //                "maxAirVolume": 1800,
                //                "constant": {
                //                    "a1": 1.5176,
                //                    "a2": 0.4353,
                //                    "a3": 0.00000002617,
                //                    "a4": 1.098
                //                }
                /// Get From Om pangihutan
                "hoursePower": 0.5,
                "direction": 0,
                "highSpeedLimit": 1199,
                "maxAirVolume": 1500,
                "constant": {
                    "a1": 2,
                    "a2": 0.5294,
                    "a3": 0.000000003016,
                    "a4": 0.8078
                }
            },
            "envTempLimit": {
                "highest": 35,
                "lowest": 13,
            },
            "airflow": {
                "ifa": {
                    "dim": {
                        "gridCount": 5,
                        "nominal": {
                            "fanDutyCycle": 39,
                            "metric": {
                                "volume": 83,
                                "velocity": 0.45,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.425,
                                "velocityTolHigh": 0.475,
                                "openingArea": 0.183,
                            },
                            "imp": {
                                "volume": 175,
                                "velocity": 90,
                                "velocityTol": 5,
                                "velocityTolLow": 85,
                                "velocityTolHigh": 95,
                                "openingArea": 1.968,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 74,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.183,
                            },
                            "imp": {
                                "volume": 157,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 1.968,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "metric": {
                                "volume": 46,
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                                "openingArea": 0.046,
                            },
                            "imp": {
                                "volume": 97,
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                                "openingArea": 0.492,
                            },
                        }
                    },
                    "sec": {
                        "nominal": {
                            "fanDutyCycle": 39,
                            "correctionFactor": 0.477,
                            "gridCount": 6, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.45,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.425,
                                "velocityTolHigh": 0.475,
                            },
                            "imp": {
                                "velocity": 90,
                                "velocityTol": 5,
                                "velocityTolLow": 85,
                                "velocityTolHigh": 95,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.32,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.31,
                            "velocityTolHigh": 0.33,
                        },
                        "imp": {
                            "velocity": 64,
                            "velocityTol": 2,
                            "velocityTolLow": 62,
                            "velocityTolHigh": 66,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    },
                    "minimum": {
                        "fanDutyCycle": 29,
                        "metric": {
                            "velocity": 0.27,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.26,
                            "velocityTolHigh": 0.28,
                        },
                        "imp": {
                            "velocity": 55,
                            "velocityTol": 2,
                            "velocityTolLow": 53,
                            "velocityTolHigh": 57,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    },
                    "maximum": {
                        "fanDutyCycle": 19,
                        "metric": {
                            "velocity": 0.37,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.36,
                            "velocityTolHigh": 0.38,
                        },
                        "imp": {
                            "velocity": 74,
                            "velocityTol": 2,
                            "velocityTolLow": 72,
                            "velocityTolHigh": 76,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    }//
                }
            }
        },
        ///// 4 Feet
        {"name": "LA2-4|EU", "profilelId": "be1ad076-f688-11eb-9a03-0242ac130003",
            "modelBase": 1,
            "classStr": "CLASS II",
            "modelStr": "LA2 EU",
            //"sideGlass": 1,
            "width": {
                "meter": 1.2192 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 7.874,//200 mm
            "fan": {
                "hoursePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2000,
                "constant": {
                    "a1": 1.5059,
                    "a2": 0.3294,
                    "a3": 0.000004763,
                    "a4": 0.6431
                }
            },
            "envTempLimit": {
                "highest": 35,
                "lowest": 13,
            },
            "airflow": {
                "ifa": {
                    "dim": {
                        "gridCount": 5,
                        "nominal": {
                            "fanDutyCycle": 39,
                            "metric": {
                                "volume": 110,
                                "velocity": 0.45,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.425,
                                "velocityTolHigh": 0.475,
                                "openingArea": 0.244,
                            },
                            "imp": {
                                "volume": 233,
                                "velocity": 90,
                                "velocityTol": 5,
                                "velocityTolLow": 85,
                                "velocityTolHigh": 95,
                                "openingArea": 2.624,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 98,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.244,
                            },
                            "imp": {
                                "volume": 208,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 2.624,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "metric": {
                                "volume": 61,
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                                "openingArea": 0.061,
                            },
                            "imp": {
                                "volume": 129,
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                                "openingArea": 0.656,
                            },
                        }
                    },
                    "sec": {
                        "nominal": {
                            "fanDutyCycle": 39,
                            "correctionFactor": 0.410,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.45,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.425,
                                "velocityTolHigh": 0.475,
                            },
                            "imp": {
                                "velocity": 90,
                                "velocityTol": 5,
                                "velocityTolLow": 85,
                                "velocityTolHigh": 95,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.32,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.31,
                            "velocityTolHigh": 0.33,
                        },
                        "imp": {
                            "velocity": 64,
                            "velocityTol": 2,
                            "velocityTolLow": 62,
                            "velocityTolHigh": 66,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    },
                    "minimum": {
                        "fanDutyCycle": 29,
                        "metric": {
                            "velocity": 0.27,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.26,
                            "velocityTolHigh": 0.28,
                        },
                        "imp": {
                            "velocity": 55,
                            "velocityTol": 2,
                            "velocityTolLow": 53,
                            "velocityTolHigh": 57,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    },
                    "maximum": {
                        "fanDutyCycle": 19,
                        "metric": {
                            "velocity": 0.37,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.36,
                            "velocityTolHigh": 0.38,
                        },
                        "imp": {
                            "velocity": 74,
                            "velocityTol": 2,
                            "velocityTolLow": 72,
                            "velocityTolHigh": 76,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    }//
                }//
            }//
        },
        ///// 5 Feet
        {"name": "LA2-5|EU", "profilelId": "cbf59b36-f688-11eb-9a03-0242ac130003",
            "modelBase": 1,
            "classStr": "CLASS II",
            "modelStr": "LA2 EU",
            //"sideGlass": 1,
            "width": {
                "meter": 1.524 /*meter = 5 Feet*/,
                "feet": 5
            },
            "sashWindow": 7.874,//200 mm
            "fan": {
                "hoursePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2500,
                "constant": {
                    "a1": 1.0314,
                    "a2": 0.1843,
                    "a3": 0.00004836,
                    "a4": 0.949
                }
            },
            "envTempLimit": {
                "highest": 35,
                "lowest": 13,
            },
            "airflow": {
                "ifa": {
                    "dim": {
                        "gridCount": 5,
                        "nominal": {
                            "fanDutyCycle": 39,
                            "metric": {
                                "volume": 138,
                                "velocity": 0.45,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.425,
                                "velocityTolHigh": 0.475,
                                "openingArea": 0.305,
                            },
                            "imp": {
                                "volume": 292,
                                "velocity": 90,
                                "velocityTol": 5,
                                "velocityTolLow": 85,
                                "velocityTolHigh": 95,
                                "openingArea": 3.280,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 122,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.305,
                            },
                            "imp": {
                                "volume": 259,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 3.280,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "metric": {
                                "volume": 77,
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                                "openingArea": 0.077,
                            },
                            "imp": {
                                "volume": 162,
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                                "openingArea": 0.82,

                            },
                        }
                    },
                    "sec": {
                        "nominal": {
                            "fanDutyCycle": 39,
                            "correctionFactor": 0.367,
                            "gridCount": 10, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.45,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.425,
                                "velocityTolHigh": 0.475,
                            },
                            "imp": {
                                "velocity": 90,
                                "velocityTol": 5,
                                "velocityTolLow": 85,
                                "velocityTolHigh": 95,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.32,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.31,
                            "velocityTolHigh": 0.33,
                        },
                        "imp": {
                            "velocity": 64,
                            "velocityTol": 2,
                            "velocityTolLow": 62,
                            "velocityTolHigh": 66,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    },
                    "minimum": {
                        "fanDutyCycle": 29,
                        "metric": {
                            "velocity": 0.27,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.26,
                            "velocityTolHigh": 0.28,
                        },
                        "imp": {
                            "velocity": 55,
                            "velocityTol": 2,
                            "velocityTolLow": 53,
                            "velocityTolHigh": 57,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    },
                    "maximum": {
                        "fanDutyCycle": 19,
                        "metric": {
                            "velocity": 0.37,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.36,
                            "velocityTolHigh": 0.38,
                        },
                        "imp": {
                            "velocity": 74,
                            "velocityTol": 2,
                            "velocityTolLow": 72,
                            "velocityTolHigh": 76,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    }//
                }
            }
        },
        ///// 6 Feet
        {"name": "LA2-6|EU", "profilelId": "df81b63a-f688-11eb-9a03-0242ac130003",
            "modelBase": 1,
            "classStr": "CLASS II",
            "modelStr": "LA2 EU",
            //"sideGlass": 1,
            "width": {
                "meter": 1.8288 /*meter = 6 Feet*/,
                "feet": 6
            },
            "sashWindow": 7.874,//200 mm
            "fan": {
                "hoursePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 3000,
                "constant": {
                    "a1": 1.1137,
                    "a2": 0.5451,
                    "a3": 0.000005337,
                    "a4": 1.0902
                }
            },
            "envTempLimit": {
                "highest": 35,
                "lowest": 13,
            },
            "airflow": {
                "ifa": {
                    "dim": {
                        "gridCount": 5,
                        "nominal": {
                            "fanDutyCycle": 39,
                            "metric": {
                                "volume": 165,
                                "velocity": 0.45,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.425,
                                "velocityTolHigh": 0.475,
                                "openingArea": 0.366,
                            },
                            "imp": {
                                "volume": 350,
                                "velocity": 90,
                                "velocityTol": 5,
                                "velocityTolLow": 85,
                                "velocityTolHigh": 95,
                                "openingArea": 3.936,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 146,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.366,
                            },
                            "imp": {
                                "volume": 309,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 3.936,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "metric": {
                                "volume": 92,
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                                "openingArea": 0.092,
                            },
                            "imp": {
                                "volume": 194,
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                                "openingArea": 0.984,
                            },
                        }
                    },
                    "sec": {
                        "nominal": {
                            "fanDutyCycle": 39,
                            "correctionFactor": 0.427,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.45,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.425,
                                "velocityTolHigh": 0.475,
                            },
                            "imp": {
                                "velocity": 90,
                                "velocityTol": 5,
                                "velocityTolLow": 85,
                                "velocityTolHigh": 95,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.32,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.31,
                            "velocityTolHigh": 0.33,
                        },
                        "imp": {
                            "velocity": 64,
                            "velocityTol": 2,
                            "velocityTolLow": 62,
                            "velocityTolHigh": 66,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    },
                    "minimum": {
                        "fanDutyCycle": 29,
                        "metric": {
                            "velocity": 0.27,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.26,
                            "velocityTolHigh": 0.28,
                        },
                        "imp": {
                            "velocity": 55,
                            "velocityTol": 2,
                            "velocityTolLow": 53,
                            "velocityTolHigh": 57,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    },
                    "maximum": {
                        "fanDutyCycle": 19,
                        "metric": {
                            "velocity": 0.37,
                            "velocityTol": 0.01,
                            "velocityTolLow": 0.36,
                            "velocityTolHigh": 0.38,
                        },
                        "imp": {
                            "velocity": 74,
                            "velocityTol": 2,
                            "velocityTolLow": 72,
                            "velocityTolHigh": 76,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    }//
                }
            }
        },
    ]
}
