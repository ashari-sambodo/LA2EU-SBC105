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
            "classStr": "CLASS II A2",
            "modelStr": "LA2 EU",
            "width": {
                "meter": 0.9144 /*meter = 3 Feet*/,
                "feet": 3
            },
            "sashWindow": 8,
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 1800,
                "constant": {
                    "a1": 1.4900,
                    "a2": 0.4430,
                    "a3": 0.00000009445,
                    "a4": 1.035
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
                                "volume": 99,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.187,
                            },
                            "imp": {
                                "volume": 210,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 2.00,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 76,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.187,
                            },
                            "imp": {
                                "volume": 160,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 2.00,
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
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 21,
                            "columns": 7,
                        }
                    }
                }
            }
        },
        ///// 4 Feet
        {"name": "LA2-4|EU", "profilelId": "be1ad076-f688-11eb-9a03-0242ac130003",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2 EU",
            "width": {
                "meter": 1.2192 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 8,
            "fan": {
                "horsePower": 0.75,
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
                                "volume": 132,
                                "velocity": 0.45,
                                "velocityTol": 0.01,
                                "velocityTolLow": 0.44,
                                "velocityTolHigh": 0.46,
                                "openingArea": 0.244,
                            },
                            "imp": {
                                "volume": 280,
                                "velocity": 90,
                                "velocityTol": 2,
                                "velocityTolLow": 88,
                                "velocityTolHigh": 92,
                                "openingArea": 2.625,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 101,
                                "velocity": 0.40,
                                "velocityTol": 0.01,
                                "velocityTolLow": 0.39,
                                "velocityTolHigh": 0.41,
                                "openingArea": 0.244,
                            },
                            "imp": {
                                "volume": 213,
                                "velocity": 80,
                                "velocityTol": 2,
                                "velocityTolLow": 78,
                                "velocityTolHigh": 82,
                                "openingArea": 2.625,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "metric": {
                                "volume": 61,
                                "velocity": 1,
                                "velocityTol": 0.01,
                                "velocityTolLow": 0.99,
                                "velocityTolHigh": 1.01,
                                "openingArea": 0.061,
                            },
                            "imp": {
                                "volume": 129,
                                "velocity": 197,
                                "velocityTol": 2,
                                "velocityTolLow": 195,
                                "velocityTolHigh": 199,
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
                                "velocityTol": 0.01,
                                "velocityTolLow": 0.44,
                                "velocityTolHigh": 0.46,
                            },
                            "imp": {
                                "velocity": 90,
                                "velocityTol": 2,
                                "velocityTolLow": 88,
                                "velocityTolHigh": 92,
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
                    }
                }
            }
        },
        ///// 5 Feet
        {"name": "LA2-5|EU", "profilelId": "cbf59b36-f688-11eb-9a03-0242ac130003",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2 EU",
            "width": {
                "meter": 1.524 /*meter = 5 Feet*/,
                "feet": 5
            },
            "sashWindow": 8,
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2500,
                "constant": {
                    "a1": 1.5882,
                    "a2": 0.5882,
                    "a3": 0.00000002311,
                    "a4": 1.098
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
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.311,
                            },
                            "imp": {
                                "volume": 350,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 3.333,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 126,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.311,
                            },
                            "imp": {
                                "volume": 267,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 3.333,
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
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 27,
                            "columns": 9,
                        }
                    }
                }
            }
        },
        ///// 6 Feet
        {"name": "LA2-6|EU", "profilelId": "df81b63a-f688-11eb-9a03-0242ac130003",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2 EU",
            "width": {
                "meter": 1.8288 /*meter = 6 Feet*/,
                "feet": 6
            },
            "sashWindow": 8,
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2500,
                "constant": {
                    "a1": 1.5882,
                    "a2": 0.5882,
                    "a3": 0.00000002311,
                    "a4": 1.098
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
                                "volume": 198,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.371,
                            },
                            "imp": {
                                "volume": 420,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 4.00,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 151,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.371,
                            },
                            "imp": {
                                "volume": 320,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 4.00,
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
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "grid": {
                            "count": 33,
                            "columns": 11,
                        }
                    }
                }
            }
        },

        //        ///// SASH 10 Inch
        //        ///// 3 Feet
        //        {"name": "AC2-3|NSF|Sash-10-Inch", "profilelId": "9e296b1c-f690-11eb-9a03-0242ac130003",
        //            "modelBase": 1,
        //            "classStr": "CLASS II A2",
        //            "modelStr": "AC2",
        //            "width": {
        //                "meter": 0.9144 /*meter = 3 Feet*/,
        //                "feet": 3
        //            },
        //            "sashWindow": 10,
        //            "fan": {
        //                "horsePower": 0.75,
        //                "direction": 1,
        //                "highSpeedLimit": 1292,
        //                "maxAirVolume": 1800,
        //                "constant": {
        //                    "a1": 1.4900,
        //                    "a2": 0.4430,
        //                    "a3": 0.00000009445,
        //                    "a4": 1.035
        //                }
        //            },
        //            "envTempLimit": {
        //                "highest": 35,
        //                "lowest": 13,
        //            },
        //            "airflow": {
        //                "ifa": {
        //                    "dim": {
        //                        "gridCount": 5,
        //                        "nominal": {
        //                            "fanDutyCycle": 39,
        //                            "metric": {
        //                                "volume": 124,
        //                                "velocity": 0.53,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.505,
        //                                "velocityTolHigh": 0.555,
        //                                "openingArea": 0.234,
        //                            },
        //                            "imp": {
        //                                "volume": 263,
        //                                "velocity": 105,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 100,
        //                                "velocityTolHigh": 110,
        //                                "openingArea": 2.50,
        //                            },
        //                        },
        //                        "minimum": {
        //                            "fanDutyCycle": 29,
        //                            "metric": {
        //                                "volume": 94,
        //                                "velocity": 0.40,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.375,
        //                                "velocityTolHigh": 0.425,
        //                                "openingArea": 0.234,
        //                            },
        //                            "imp": {
        //                                "volume": 126,
        //                                "velocity": 80,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 75,
        //                                "velocityTolHigh": 85,
        //                                "openingArea": 2.50,
        //                            },
        //                        },
        //                        "stb": {
        //                            "fanDutyCycle": 10,
        //                            "metric": {
        //                                "volume": 46,
        //                                "velocity": 1,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.975,
        //                                "velocityTolHigh": 1.025,
        //                                "openingArea": 0.046,
        //                            },
        //                            "imp": {
        //                                "volume": 97,
        //                                "velocity": 197,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 192,
        //                                "velocityTolHigh": 202,
        //                                "openingArea": 0.492,
        //                            },
        //                        }
        //                    },
        //                    "sec": {
        //                        "nominal": {
        //                            "fanDutyCycle": 39,
        //                            "correctionFactor": 0.477,
        //                            "gridCount": 6, // 2 times from cabinet width
        //                            "metric": {
        //                                "velocity": 0.53,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.505,
        //                                "velocityTolHigh": 0.555,
        //                            },
        //                            "imp": {
        //                                "velocity": 105,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 100,
        //                                "velocityTolHigh": 110,
        //                            },
        //                        }
        //                    }
        //                },
        //                "dfa": {
        //                    "nominal": {
        //                        "fanDutyCycle": 39,
        //                        "metric": {
        //                            "velocity": 0.30,
        //                            "velocityTol": 0.025,
        //                            "velocityTolLow": 0.275,
        //                            "velocityTolHigh": 0.325,
        //                        },
        //                        "imp": {
        //                            "velocity": 60,
        //                            "velocityTol": 5,
        //                            "velocityTolLow": 55,
        //                            "velocityTolHigh": 65,
        //                        },
        //                        "velDevp": 20, /*%*/
        //                        "grid": {
        //                            "count": 21,
        //                            "columns": 7,
        //                        }
        //                    }
        //                }
        //            }
        //        },
        //        ///// 4 Feet
        //        {"name": "AC2-4|NSF|Sash-10-Inch", "profilelId": "acc6c070-f690-11eb-9a03-0242ac130003",
        //            "modelBase": 1,
        //            "classStr": "CLASS II A2",
        //            "modelStr": "AC2",
        //            "width": {
        //                "meter": 1.2192 /*meter = 4 Feet*/,
        //                "feet": 4
        //            },
        //            "sashWindow": 10,
        //            "fan": {
        //                "horsePower": 0.75,
        //                "direction": 1,
        //                "highSpeedLimit": 1292,
        //                "maxAirVolume": 2000,
        //                "constant": {
        //                    "a1": 1.5059,
        //                    "a2": 0.3294,
        //                    "a3": 0.000004763,
        //                    "a4": 0.6431
        //                }
        //            },
        //            "envTempLimit": {
        //                "highest": 35,
        //                "lowest": 13,
        //            },
        //            "airflow": {
        //                "ifa": {
        //                    "dim": {
        //                        "gridCount": 5,
        //                        "nominal": {
        //                            "fanDutyCycle": 39,
        //                            "metric": {
        //                                "volume": 165,
        //                                "velocity": 0.53,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.505,
        //                                "velocityTolHigh": 0.555,
        //                                "openingArea": 0.310,
        //                            },
        //                            "imp": {
        //                                "volume": 350,
        //                                "velocity": 105,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 100,
        //                                "velocityTolHigh": 110,
        //                                "openingArea": 3.333,
        //                            },
        //                        },
        //                        "minimum": {
        //                            "fanDutyCycle": 29,
        //                            "metric": {
        //                                "volume": 126,
        //                                "velocity": 0.40,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.375,
        //                                "velocityTolHigh": 0.425,
        //                                "openingArea": 0.310,
        //                            },
        //                            "imp": {
        //                                "volume": 267,
        //                                "velocity": 80,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 75,
        //                                "velocityTolHigh": 85,
        //                                "openingArea": 3.333,
        //                            },
        //                        },
        //                        "stb": {
        //                            "fanDutyCycle": 10,
        //                            "metric": {
        //                                "volume": 61,
        //                                "velocity": 1,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.975,
        //                                "velocityTolHigh": 1.025,
        //                                "openingArea": 0.061,
        //                            },
        //                            "imp": {
        //                                "volume": 129,
        //                                "velocity": 197,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 192,
        //                                "velocityTolHigh": 202,
        //                                "openingArea": 0.656,
        //                            },
        //                        }
        //                    },
        //                    "sec": {
        //                        "nominal": {
        //                            "fanDutyCycle": 39,
        //                            "correctionFactor": 0.410,
        //                            "gridCount": 8, // 2 times from cabinet width
        //                            "metric": {
        //                                "velocity": 0.53,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.505,
        //                                "velocityTolHigh": 0.555,
        //                            },
        //                            "imp": {
        //                                "velocity": 105,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 100,
        //                                "velocityTolHigh": 110,
        //                            },
        //                        }
        //                    }
        //                },
        //                "dfa": {
        //                    "nominal": {
        //                        "fanDutyCycle": 39,
        //                        "metric": {
        //                            "velocity": 0.30,
        //                            "velocityTol": 0.025,
        //                            "velocityTolLow": 0.275,
        //                            "velocityTolHigh": 0.325,
        //                        },
        //                        "imp": {
        //                            "velocity": 60,
        //                            "velocityTol": 5,
        //                            "velocityTolLow": 55,
        //                            "velocityTolHigh": 65,
        //                        },
        //                        "velDevp": 20, /*%*/
        //                        "grid": {
        //                            "count": 21,
        //                            "columns": 7,
        //                        }
        //                    }
        //                }
        //            }
        //        },
        //        ///// 5 Feet
        //        {"name": "AC2-5|NSF|Sash-10-Inch", "profilelId": "be9de558-f690-11eb-9a03-0242ac130003",
        //            "modelBase": 1,
        //            "classStr": "CLASS II A2",
        //            "modelStr": "AC2",
        //            "width": {
        //                "meter": 1.524 /*meter = 5 Feet*/,
        //                "feet": 5
        //            },
        //            "sashWindow": 10,
        //            "fan": {
        //                "horsePower": 0.75,
        //                "direction": 1,
        //                "highSpeedLimit": 1292,
        //                "maxAirVolume": 2500,
        //                "constant": {
        //                    "a1": 1.5882,
        //                    "a2": 0.5882,
        //                    "a3": 0.00000002311,
        //                    "a4": 1.098
        //                }
        //            },
        //            "envTempLimit": {
        //                "highest": 35,
        //                "lowest": 13,
        //            },
        //            "airflow": {
        //                "ifa": {
        //                    "dim": {
        //                        "gridCount": 5,
        //                        "nominal": {
        //                            "fanDutyCycle": 39,
        //                            "metric": {
        //                                "volume": 207,
        //                                "velocity": 0.53,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.505,
        //                                "velocityTolHigh": 0.555,
        //                                "openingArea": 0.389,
        //                            },
        //                            "imp": {
        //                                "volume": 438,
        //                                "velocity": 105,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 100,
        //                                "velocityTolHigh": 110,
        //                                "openingArea": 4.167,
        //                            },
        //                        },
        //                        "minimum": {
        //                            "fanDutyCycle": 29,
        //                            "metric": {
        //                                "volume": 157,
        //                                "velocity": 0.40,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.375,
        //                                "velocityTolHigh": 0.425,
        //                                "openingArea": 0.389,
        //                            },
        //                            "imp": {
        //                                "volume": 333,
        //                                "velocity": 80,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 75,
        //                                "velocityTolHigh": 85,
        //                                "openingArea": 4.167,
        //                            },
        //                        },
        //                        "stb": {
        //                            "fanDutyCycle": 10,
        //                            "metric": {
        //                                "volume": 77,
        //                                "velocity": 1,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.975,
        //                                "velocityTolHigh": 1.025,
        //                                "openingArea": 0.077,
        //                            },
        //                            "imp": {
        //                                "volume": 162,
        //                                "velocity": 197,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 192,
        //                                "velocityTolHigh": 202,
        //                                "openingArea": 0.82,

        //                            },
        //                        }
        //                    },
        //                    "sec": {
        //                        "nominal": {
        //                            "fanDutyCycle": 39,
        //                            "correctionFactor": 0.367,
        //                            "gridCount": 10, // 2 times from cabinet width
        //                            "metric": {
        //                                "velocity": 0.53,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.505,
        //                                "velocityTolHigh": 0.555,
        //                            },
        //                            "imp": {
        //                                "velocity": 105,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 100,
        //                                "velocityTolHigh": 110,
        //                            },
        //                        }
        //                    }
        //                },
        //                "dfa": {
        //                    "nominal": {
        //                        "fanDutyCycle": 39,
        //                        "metric": {
        //                            "velocity": 0.30,
        //                            "velocityTol": 0.025,
        //                            "velocityTolLow": 0.275,
        //                            "velocityTolHigh": 0.325,
        //                        },
        //                        "imp": {
        //                            "velocity": 60,
        //                            "velocityTol": 5,
        //                            "velocityTolLow": 55,
        //                            "velocityTolHigh": 65,
        //                        },
        //                        "velDevp": 20, /*%*/
        //                        "grid": {
        //                            "count": 27,
        //                            "columns": 9,
        //                        }
        //                    }
        //                }
        //            }
        //        },
        //        ///// 6 Feet
        //        {"name": "AC2-6|NSF|Sash-10-Inch", "profilelId": "cadec2ba-f690-11eb-9a03-0242ac130003",
        //            "modelBase": 1,
        //            "classStr": "CLASS II A2",
        //            "modelStr": "AC2",
        //            "width": {
        //                "meter": 1.8288 /*meter = 6 Feet*/,
        //                "feet": 6
        //            },
        //            "sashWindow": 10,
        //            "fan": {
        //                "horsePower": 0.75,
        //                "direction": 1,
        //                "highSpeedLimit": 1292,
        //                "maxAirVolume": 2500,
        //                "constant": {
        //                    "a1": 1.5882,
        //                    "a2": 0.5882,
        //                    "a3": 0.00000002311,
        //                    "a4": 1.098
        //                }
        //            },
        //            "envTempLimit": {
        //                "highest": 35,
        //                "lowest": 13,
        //            },
        //            "airflow": {
        //                "ifa": {
        //                    "dim": {
        //                        "gridCount": 5,
        //                        "nominal": {
        //                            "fanDutyCycle": 39,
        //                            "metric": {
        //                                "volume": 248,
        //                                "velocity": 0.53,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.505,
        //                                "velocityTolHigh": 0.555,
        //                                "openingArea": 0.465,
        //                            },
        //                            "imp": {
        //                                "volume": 525,
        //                                "velocity": 105,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 100,
        //                                "velocityTolHigh": 110,
        //                                "openingArea": 5.00,
        //                            },
        //                        },
        //                        "minimum": {
        //                            "fanDutyCycle": 29,
        //                            "metric": {
        //                                "volume": 189,
        //                                "velocity": 0.40,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.375,
        //                                "velocityTolHigh": 0.425,
        //                                "openingArea": 0.465,
        //                            },
        //                            "imp": {
        //                                "volume": 400,
        //                                "velocity": 80,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 75,
        //                                "velocityTolHigh": 85,
        //                                "openingArea": 5.00,
        //                            },
        //                        },
        //                        "stb": {
        //                            "fanDutyCycle": 10,
        //                            "metric": {
        //                                "volume": 92,
        //                                "velocity": 1,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.975,
        //                                "velocityTolHigh": 1.025,
        //                                "openingArea": 0.092,
        //                            },
        //                            "imp": {
        //                                "volume": 194,
        //                                "velocity": 197,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 192,
        //                                "velocityTolHigh": 202,
        //                                "openingArea": 0.984,
        //                            },
        //                        }
        //                    },
        //                    "sec": {
        //                        "nominal": {
        //                            "fanDutyCycle": 39,
        //                            "correctionFactor": 0.427,
        //                            "gridCount": 12, // 2 times from cabinet width
        //                            "metric": {
        //                                "velocity": 0.53,
        //                                "velocityTol": 0.025,
        //                                "velocityTolLow": 0.505,
        //                                "velocityTolHigh": 0.555,
        //                            },
        //                            "imp": {
        //                                "velocity": 105,
        //                                "velocityTol": 5,
        //                                "velocityTolLow": 100,
        //                                "velocityTolHigh": 110,
        //                            },
        //                        }
        //                    }
        //                },
        //                "dfa": {
        //                    "nominal": {
        //                        "fanDutyCycle": 39,
        //                        "metric": {
        //                            "velocity": 0.30,
        //                            "velocityTol": 0.025,
        //                            "velocityTolLow": 0.275,
        //                            "velocityTolHigh": 0.325,
        //                        },
        //                        "imp": {
        //                            "velocity": 60,
        //                            "velocityTol": 5,
        //                            "velocityTolLow": 55,
        //                            "velocityTolHigh": 65,
        //                        },
        //                        "velDevp": 20, /*%*/
        //                        "grid": {
        //                            "count": 33,
        //                            "columns": 11,
        //                        }
        //                    }
        //                }
        //            }
        //        },
    ]
}
