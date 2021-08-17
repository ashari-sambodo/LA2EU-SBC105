WorkerScript.onMessage = function(msg) {

    //    //console.debug(msg.action === "calculate")

    if (msg.action === "calculate") {

        WorkerScript.sendMessage(
                    {"action": "calculate", "status": "started"}
                    );

        let decimals = msg.decimals

        let gridItems = msg.grid

        let valueBased = 0.0;
        let valueFormatBased = 0.0;
        let valueBasedImp = 0.0;
        let valueFormatBasedImp = 0.0;

        let acceptedCount = 0;
        let acceptedAll = 0;

        let gridValue = []

        let measureUnit = decimals > 0 ? 0 : 1 // 0 as metric

        let i=0;
        for(i; i<gridItems.length; i++) {
            valueBased = gridItems[i]["val"]
            valueFormatBased = Number(valueBased).toFixed(2)

            valueBasedImp = gridItems[i]["valImp"]
            valueFormatBasedImp = Number(valueBasedImp).toFixed(0)
            //            //console.debug(valueBased)
            if(measureUnit)//imperial
                gridValue.push(valueBasedImp)
            else
                gridValue.push(valueBased)

            gridItems[i]["valSf"] = valueFormatBased
            gridItems[i]["valImpSf"] = valueFormatBasedImp

            ///check eccepted field
            if (gridItems[i]["acc"] === 1) {
                acceptedCount = acceptedCount + 1
            }
        }

        ///are all field was acc
        acceptedAll = acceptedCount === gridItems.length ? 1 : 0
        ////
        let dataVal = gridValue
        let minVal  = Math.min.apply(Math, dataVal)
        let maxVal  = Math.max.apply(Math, dataVal)
        let sumVal  = Math.round(dataVal.reduce(function(a,b){return a + b}, 0) * 100) / 100
        let avgVal  = Math.round((sumVal / dataVal.length) * 100) / 100
        let maxDeviationVal = Math.round((Math.max(maxVal-avgVal, avgVal-minVal) * 100)) / 100
        let maxDeviationPrecent = Math.round(((maxDeviationVal / avgVal) * 100.0) * 10) / 10
        maxDeviationPrecent = isNaN(maxDeviationPrecent) ? 0 : maxDeviationPrecent

        //        console.debug("minVal: " + minVal)
        //        console.debug("maxVal: " + maxVal)
        //        console.debug("sumVal: " + sumVal)
        //        //console.debug("avgVal: " + avgVal)
        //        //console.debug("maxDeviationVal: " + maxDeviationVal)
        //        //console.debug("maxDeviationPrecent: " + maxDeviationPrecent)
        ////

        let gridStringify = JSON.stringify(gridItems)
        //        console.debug("Downflow Helper calculate")
        //        console.debug(gridStringify)

        WorkerScript.sendMessage(
                    {"action": "calculate",
                        "status": "finished",
                        "grid": gridItems,
                        "gridStringify": gridStringify,
                        "minVal": minVal,
                        "maxVal": maxVal,
                        "sumVal": sumVal,
                        "avgVal": avgVal,
                        "maxDeviationVal": maxDeviationVal,
                        "maxDeviationPrecent": maxDeviationPrecent,
                        "acceptedCount": acceptedCount,
                        "acceptedAll": acceptedAll}
                    );
    }//
    else if (msg.action === "init") {

        WorkerScript.sendMessage(
                    {"action": "init", "status": "started"}
                    );

        let decimals = msg.decimals
        let count = msg.count

        let gridItems = []

        if (msg.grid !== undefined) {
            gridItems = msg.grid
        }
        else{
            try {
                gridItems = JSON.parse(msg.gridStringify)
            }
            catch (e) {
                //            //console.debug("JSON.parse failed: " + e)
            }
        }
        //        let measureUnit = decimals ? 0 : 1 // 0 as metric

        /// ensure the grids items from parse result is equal with requirement
        /// if lesser than it, adding
        /// if more than it, substract
        let validateCountNeed = count - gridItems.length
        if(validateCountNeed > 0) {
            let valueBased = 0.0;
            let valueFormatBased = Number(valueBased).toFixed(2)
            let valueBasedImp = 0.0;
            let valueFormatBasedImp = Number(valueBasedImp).toFixed(0)

            let i=0;
            for(i; i<validateCountNeed; i++) {
                gridItems.push({"val": valueBased, "valSf": valueFormatBased, "valImp": valueBasedImp, "valImpSf": valueFormatBasedImp, "acc": 0})
            }
        }
        else if(validateCountNeed < 0) {
            let loop = Math.abs(validateCountNeed)
            let i=0;
            for(i; i<validateCountNeed; i++) {
                gridItems.pop()
            }
        }

        let gridStringify = JSON.stringify(gridItems)
        //        console.debug("Downflow Helper Init")
        //        console.debug(gridStringify)

        WorkerScript.sendMessage(
                    {"action": "init", "status": "finished", "grid": gridItems, "gridStringify": gridStringify}
                    );
    }//
    else if (msg.action === "generate") {

        WorkerScript.sendMessage(
                    {"action": "generate", "status": "started"}
                    );

        let decimals = msg.decimals
        let count = msg.count

        let gridItems = []

        //        let valueBased = 0.30;
        let valueBased = 0.0;
        let valueFormatBased = Number(valueBased).toFixed(2)
        let valueBasedImp = 0.0;
        let valueFormatBasedImp = Number(valueBased).toFixed(0)

        let i=0;
        for(i; i<count; i++) {
            //            gridItems.push({"val": valueBased, "valSf": valueFormatBased, "acc": 0})
            gridItems.push({"val": valueBased, "valSf": valueFormatBased, "valImp": valueBasedImp, "valImpSf": valueFormatBasedImp, "acc": 0})
        }

        let gridStringify = JSON.stringify(gridItems)
        //        console.debug("Downflow Helper generate")
        //        console.debug(gridStringify)

        WorkerScript.sendMessage(
                    {"action": "generate", "status": "finished", "grid": gridItems, "gridStringify": gridStringify}
                    );
    }//
}//
