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
        ///////////////////////// LA2
        ///// 3 Feet
        {"name": "LA2-3|NSF|Sash-8-Inch", "profilelId": "ec42fbd6-4e7c-11eb-ae93-0242ac130002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 0.914 /*meter = 4 Feet*/,
                "feet": 3
            },
            "sashWindow": 8,
            "fan": {
                "horsePower": 1,
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
                                "volume": 132,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.248,
                            },
                            "imp": {
                                "volume": 280,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 2.669,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 101,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.248,
                            },
                            "imp": {
                                "volume": 213,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 2.669,
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
                                "openingArea": 0.061,
                            },
                            "imp": {
                                "volume": 97,
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
                            "correctionFactor": 0.380,
                            "gridCount": 8, // 2 times from cabinet width
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
        {"name": "LA2-4|NSF|Sash-8-Inch", "profilelId": "73ba4552-4da5-11eb-ae93-0242ac130002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.220 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 8,
            "fan": {
                "horsePower": 1,
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
                                "volume": 132,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.248,
                            },
                            "imp": {
                                "volume": 280,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 2.669,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 101,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.248,
                            },
                            "imp": {
                                "volume": 213,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 2.669,
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
                            "correctionFactor": 0.371,
                            "gridCount": 8, // 2 times from cabinet width
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
        ////
        {"name": "LA2-4|NSF|Sash-10-Inch", "profilelId": "4f4a0b88-4e60-11eb-ae93-0242ac130002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.220 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 10,
            "fan": {
                "horsePower": 1,
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
                            "fanDutyCycle": 43,
                            "metric": {
                                "volume": 165,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.310,
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
                            "fanDutyCycle": 33,
                            "metric": {
                                "volume": 126,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.310,
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
                            "correctionFactor": 0.319,
                            "gridCount": 8, // 2 times from cabinet width
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
                        "fanDutyCycle": 43,
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
        ////
        {"name": "LA2-4|NSF|Sash-12-Inch", "profilelId": "2171343c-4e62-11eb-ae93-0242ac130002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.220 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 12,
            "fan": {
                "horsePower": 1,
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
                            "fanDutyCycle": 48,
                            "metric": {
                                "volume": 198,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.372,
                            },
                            "imp": {
                                "volume": 420,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 4,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 38,
                            "metric": {
                                "volume": 151,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.372,
                            },
                            "imp": {
                                "volume": 320,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 4,
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
                            "correctionFactor": 0.250,
                            "gridCount": 8, // 2 times from cabinet width
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
                        "fanDutyCycle": 48,
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
        ///////////////////////// VA2
        ///// 4 Feet
        {"name": "VA2-4|NSF|Sash-12-Inch", "profilelId": "fde66304-4e64-11eb-ae93-0242ac130002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "VA2",
            "width": {
                "meter": 1.220 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 12,
            "fan": {
                "horsePower": 1,
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
                "highest": 40,
                "lowest": 0,
            },
            "airflow": {
                "ifa": {
                    "dim": {
                        "gridCount": 5,
                        "nominal": {
                            "fanDutyCycle": 48,
                            "metric": {
                                "volume": 198,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.372,
                            },
                            "imp": {
                                "volume": 420,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 4,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 38,
                            "metric": {
                                "volume": 151,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.372,
                            },
                            "imp": {
                                "volume": 320,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 4,
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
                        "fanDutyCycle": 48,
                        "nominal": {
                            "correctionFactor": 0.250,
                            "gridCount": 8, // 2 times from cabinet width
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
                        "fanDutyCycle": 48,
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
    ]
}
