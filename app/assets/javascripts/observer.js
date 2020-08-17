function xObserveable() {
    this.observableEvents = {}

    this.trigger = function(eventName, data) {
        if(this.observableEvents[eventName]) { 
            for(let index in this.observableEvents[eventName]) {
                this.observableEvents[eventName][index]['cb'](data)
            }
        }
    }

    this.listen = function(eventName, location, cb) {
        let found = false;

        console.log(eventName, location)

        this.observableEvents[eventName] = this.observableEvents[eventName] || []

        // Replace the callback if it's in the same spot. Prevent dupes basically
        this.observableEvents[eventName].forEach( function(item) { 
            if(item.location == location) {
                item.cb = cb
                found = true
            }
        })
        console.log("found: " , found)


        if(!found) this.observableEvents[eventName].push({location: location, cb: cb})
    }
}