Tracking.Views.TrackingNumberShow = Backbone.View.extend({

  el: '.page',

  template: JST['tracking_numbers/show'],

  events: {
    'click .back-btn': 'back'
  },

  render: function(options) {
    var self = this;

    if (options.id) {
      self.tracking_number = new Tracking.Models.TrackingNumber({id: options.id});
      self.tracking_number.fetch({
        success: function(tracking_number) {
          var template = self.template({
            tracking_number: tracking_number
          });
          self.$el.html(template);
        },
        error: function(error, response) {
          if (response.status === 404) {
            errors = response.responseJSON
            for (attribute in errors) {
              messages = errors[attribute];
              for (index in messages) {
                $('#notice').append("<p>Error: " + messages[index] + "</p>").slideDown();
              }
            }
          }
        }
      });
    }
  },

  back: function(event) {
    event.preventDefault();
    Backbone.history.navigate('/', { trigger: true });

  }

});
