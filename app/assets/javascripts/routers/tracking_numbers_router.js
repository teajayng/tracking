Tracking.Routers.TrackingNumbers = Backbone.Router.extend({

  routes: {
    '': 'index',
    'tracking_numbers/:id': 'show'
  },

  initialize: function() {
    this.collection = new Tracking.Collections.TrackingNumbers();
    this.collection.reset($('.page').data('tracking_numbers'));
  },

  index: function() {
    var view = new Tracking.Views.TrackingNumbersIndex({
      collection: this.collection
    });
    view.render();
  },

  show: function(id) {
    var view = new Tracking.Views.TrackingNumberShow();
    view.render({id: id});
  }

});

