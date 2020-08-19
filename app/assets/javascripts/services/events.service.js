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

        // sort=${data.sortKey}&direction=${data.direction}&fil_closed=${data.filters.finished}&fil_open=${data.filters.open}&fil_partial=${data.filters.partial
        this.forBucketSorted = function(id, data, cb) { 
            let query = `
                query {
                    event(id: "${id}", sort: "${data.sortKey}", direction: "${data.direction}", filClosed: "${data.filters.finished}", filOpen: "${data.filters.open}") {
                        id
                        taskNumber
                        color
                        taskSize
                        title
                        status
                        description
                        dateFinished
                        jsonDescription
                        estimateHour
                        estimateMinute
                        timeTookHour
                        timeTookMinute
                        active
                        clockStart
                        minutesTaken
                    }
                }
            `
            graphQl(query, function(results) { 
                if(results.data) { 
                    cb(results.data.event)
                } else { 
                    cb(results)
                }
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

        this.generateChart = function(id, days, type, cb) { 
            fetch(`/events/charts/${id}.json?type=${type}&days=${days}`)
                .then(function(response) {
                    return response.json()
                }).then(function(json) {
                    cb(json)
                }).catch(function(ex) {
                    console.log('parsing failed', ex)
                })
        }
}