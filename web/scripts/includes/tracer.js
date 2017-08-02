var Tracer = {
    writeTrace : function(error, callback) {
        StackTrace.fromError(error, {offline: true}).then(function(frames, error) {
            callback(new Tracer.Container(frames));
        }).catch(function(stuff){
            console.log(stuff);
        });
    },

    Container : function(payload) {
        this.payload = payload;
    }
}