function EventService() { 
        this.index = function(cb) { 
            fetch('/events.json')
                .then(function(response) {
                    return response.json()
                }).then(function(json) {
                    cb(json)
                }).catch(function(ex) {
                    console.log('parsing failed', ex)
                })
        }
    
}