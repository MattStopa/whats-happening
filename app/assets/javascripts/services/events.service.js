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
            let str = ''
            if(data.byDate) {
                str = `byDate: "${data.byDate}"`
            } else { 
                str = `sort: "${data.sortKey}", direction: "${data.direction}", filClosed: "${data.filters.finished}", filOpen: "${data.filters.open}"`
            }

            let query = `
                query {
                    event(id: "${id}", ${str}) {
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

            console.log(query)
            graphQl(query, function(results) { 
                if(results.data) { 
                    cb(results.data.event)
                } else { 
                    cb(results)
                }
            })
        }

        this.createEvent = function(data, cb) { 
            let idQuery = data.id ? `id:"${data.id}",`: ''

            fields = ["title", "taskSize", "status", "description", "dateFinished", 
                        "estimateHour", "estimateMinute", "timeTookHour", 
                        "timeTookMinute", "active", "clockStart", "minutesTaken"]

                        

            strings = ''
            fields.forEach( (item) => { 
                if(data[item]) {
                    if(typeof data[item] === 'string') {
                        strings += `${item}: "${data[item]}",
                        `
                    } else {
                        strings += `${item}: ${data[item]},
                        `
                    }
                    
                }
            } )

            if(data['jsonDescription']) {
               strings += `jsonDescription: "${encodeURIComponent(JSON.stringify(data.jsonDescription))}",
               `
            }

            let query = `
              mutation {
                createEvent(
                  input:{
                    ${idQuery}
                    userID:"${me.id}",
                    ${strings}
                  }   
                ) {
                  title
                  id
                }
              }
            `
            console.log(query)
            graphQl(query, cb)
          }


        // this.forBucketByDate = function(id, cb) { 
        //     fetch(`/events/buckets/${id}.json?byDate=true`)
        //         .then(function(response) {
        //             return response.json()
        //         }).then(function(json) {
        //             cb(json)
        //         }).catch(function(ex) {
        //             console.log('parsing failed', ex)
        //         })
        // }

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