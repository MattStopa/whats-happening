<bucket-selector>
  <div class="bucket-panel">
    <div class="rounded p-2 bg-green-500 cursor-pointer m-2 mt-1 text-center font-bold" onclick="addBucket()">
      { showBucket ? "Close Bucket" : "Create Bucket"}
    </div>
    <input onkeyup={keyUp} if={showBucket} class="shadow appearance-none border border-gray-400 rounded py-2 px-3 
        text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline mx-2 ">

    <ul>
      <li each="{bucket in opts.buckets}" onclick="{setBucket}" class="mx-2" name="selector">
        <div class="flex justify-between" name="selector">
          <div name="selector">
            <div name="selector">
              <i class="fas fa-fill mt-2 mr-2 ml-2" aria-hidden="true" name="selector"></i>{bucket.name}
            </div>
          </div>
          <div>
            <div class="p-2 py-1 cursor-pointer text-black bg-gray-300 inline-block rounded" onclick={editBucketDetails(bucket)}>
              <i class="fas fa-cog" aria-hidden="true" name="cog"></i>
            </div>
            <div if={bucket.edit}>
              <div class="z-20 rounded bg-gray-100 p-2 absolute border-2 border-grey-800 shadow ml-8 -mt-8">
                <div class="flex justify-between ">
                  <h2 class="mb-2 font-bold">Bucket Details</h2>
                  <i class="fas fa-times-circle mt-1 mr-1" aria-hidden="true" onclick={closeBucketPopup}></i>

                </div>
               <input type="text" class="shadow appearance-none border border-gray-400 rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline" onkeyup={keyUpEdit(bucket)} value={bucket.name}>
                                 <div>
                    <button class="bg-red-500 rounded w-full text-white font-bold" onclick={deleteBucket(bucket)}>Delete</button>

                  </div>
              </div>
            </div>

          </div>
        </div>
      </li>
  </div>

  <script>
    let self = this
    let showBucket = false;
    
    setBucket = function(e) {
      if(e.target.getAttribute("name") != "selector") return
      self.opts.onselected(e)
    }

    deleteBucket = function(e) { 
      text = "Are you sure you want to delete the bucket? The bucket and it's subtasks will be permanently deleted after 30 days"
      return function(v) {
        if(confirm(text )) {
          new BucketService().delete({id: e.id}, res => { 
            xObserve.trigger('bucketsChanged', true)
            new Noty({
                timeout: 3000,
                type: 'success',
                text: `Bucket ${e.name} was successfully deleted`,
            }).show();
           })
        }
      }
    }

    closeBucketPopup = function() { 
      opts.buckets.forEach(function(bucket){ 
        bucket.edit = false
      })
      self.update()
    }

    editBucketDetails = function(e) {
      return function(v) { 
        opts.buckets.forEach(function(bucket){ 
          bucket.edit = false
        })

        e.edit = true
        self.update()
      }
    }

    addBucket = function() { 
      self.showBucket = !self.showBucket
      self.update()
    }

    keyUpEdit = function(e) { 
      return function(v) { 
        if(v.key == "Enter"){ 
          new BucketService().create({ name: v.target.value, id: e.id }, function() {
            self.showBucket = false;
            self.update()
            xObserve.trigger('bucketsChanged', true)
            new Noty({
                  timeout: 3000,
                  type: 'success',
                  text: `Bucket ${v.target.value} name changed`,
              }).show();
          })
        }
      }
    }

    keyUp = function(e) { 
      if(e.key == "Enter"){ 
        new BucketService().create({ name: e.target.value }, function() {
          self.showBucket = false;
          self.update()
          xObserve.trigger('bucketsChanged', true)
          new Noty({
                timeout: 3000,
                type: 'success',
                text: `Bucket ${e.target.value} successfully created`,
            }).show();
        })
      }
    }
  </script>
</bucket-selector>  