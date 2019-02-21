function xObserveable() {
    this.observableEvents = {}

    this.trigger = function(eventName, data) {
        if(this.observableEvents[eventName]) { 
            for(let item of this.observableEvents[eventName]) {
                item(data)
            }
        }
    }

    this.listen = function(eventName, cb) {
        this.observableEvents[eventName] = this.observableEvents[eventName] || []
        this.observableEvents[eventName].push(cb)
    }
}