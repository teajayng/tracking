Tracking.Views.TrackingNumbersIndex = Backbone.View.extend({

  el: '.page',

  template: JST['tracking_numbers/index'],

  events: {
    'submit #new_number': 'createTrackingNumber'
  },

  initialize: function() {
    // this.collection.on('sync', this.render, this);
    // this.collection.on('add', this.appendTrackingNumber, this);

    this.listenTo(this.collection, 'reset', this.render);
    this.listenTo(this.collection, 'add', this.appendTrackingNumber);
  },

  render: function() {
    var self = this;

    this.collection.fetch({
      success: function() {
        self.$el.html(self.template());
        self.collection.each(self.appendTrackingNumber);
      },
      error: function(collection, response, options) {
        debugger;
      }
    });

    return this;
  },

  appendTrackingNumber: function(tracking_number) {
    var view = new Tracking.Views.TrackingNumberListItem({
      model: tracking_number
    });
    this.$('.tracking-numbers').append(view.render().el);
  },

  createTrackingNumber: function(event) {
    event.preventDefault();

    $('#notice').hide().html('');

    attributes = {
      name: $('#new_tracking_name').val(),
      number: $('#new_tracking_number').val()
    }

    this.collection.create(attributes, {
      wait: true,
      success: function() {
        $('#new_number')[0].reset();
        $('#new_number')[1].reset();
      },
      error: function(error, response) {
        if (response.status === 422) {
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

});
