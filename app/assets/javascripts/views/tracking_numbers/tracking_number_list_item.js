Tracking.Views.TrackingNumberListItem = Backbone.View.extend({

  template: JST['tracking_numbers/list_item'],

  tagName: 'li',
  className: function() {
    return this.model.get('carrier').toLowerCase();
  },

  events: {
    'click': 'show',
    'click div.button.red': 'destroy'
  },

  render: function() {
    $(this.el).html(this.template({
      tracking_number: this.model
    }));
    return this;
  },

  show: function() {
    if (this.model.get('carrier') === 'UPS' || this.model.get('carrier') === 'FedEx' || this.model.get('carrier') === 'USPS') {
      Backbone.history.navigate('tracking_numbers/' + this.model.id, { trigger: true });
    }
  },

  destroy: function(event) {
    event.preventDefault();

    var self = this;
    var item = this.model;
    if (window.confirm("Delete this tracking number?")) {
      item.destroy({
        success: function() {
          $(self.el).slideUp().remove();
          self.undelegateEvents();
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
    return false;
  }

});
