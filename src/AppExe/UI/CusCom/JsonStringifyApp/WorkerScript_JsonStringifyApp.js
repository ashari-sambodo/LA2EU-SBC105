WorkerScript.onMessage = function(msg) {
    const convertMode = msg['conv'] || null
    if (convertMode === "j2s"){

        const jsonObject = msg['data'] || {}
        let j2s = JSON.stringify(jsonObject)

        WorkerScript.sendMessage({"id": msg['id'], "conv": "j2s", "data": j2s});
    }
    else if (convertMode === "s2j"){
        const jsonString = msg['data'] || "\\{\\}"
        let s2j = {}
        try {
            s2j = JSON.parse(jsonString);
        }
        catch(e) {
            console.warn(e)
        }

        WorkerScript.sendMessage({"id": msg['id'], "conv": "s2j", "data": s2j});
    }
}
