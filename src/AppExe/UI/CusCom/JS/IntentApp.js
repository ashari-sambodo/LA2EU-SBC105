.pragma library

function create(uri, extradata) {
    return {"uri": uri, "extradata": extradata}
}

function getExtraData(intent) {
    return intent["extradata"]
}
