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

        this.forBucket = function(id, cb) { 
            fetch(`/events/buckets/${id}.json`)
                .then(function(response) {
                    return response.json()
                }).then(function(json) {
                    cb(json)
                }).catch(function(ex) {
                    console.log('parsing failed', ex)
                })
        }

        this.forBucketSorted = function(id, sortKey, direction, cb) { 
            fetch(`/events/buckets/${id}.json?sort=${sortKey}&direction=${direction}`)
                .then(function(response) {
                    return response.json()
                }).then(function(json) {
                    cb(json)
                }).catch(function(ex) {
                    console.log('parsing failed', ex)
                })
        }

        this.forBucketByDate = function(id, cb) { 
            fetch(`/events/buckets/${id}.json?byDate=true`)
                .then(function(response) {
                    return response.json()
                }).then(function(json) {
                    cb(json)
                }).catch(function(ex) {
                    console.log('parsing failed', ex)
                })
        }

        this.byTag = function(tag, cb) { 
            fetch('/events/by_tag.json?tag='+tag)
                .then(function(response) {
                    return response.json()
                }).then(function(json) {
                    cb(json)
                }).catch(function(ex) {
                    console.log('parsing failed', ex)
                })
        }
}