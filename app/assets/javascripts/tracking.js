// $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
//   options.url = 'http://localhost:3000' + options.url;
// });

window.Tracking = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    new Tracking.Routers.TrackingNumbers();
    Backbone.history.start({
      pushState: true
    });
  }
};

$(document).ready(function(){
  Tracking.initialize();
});
