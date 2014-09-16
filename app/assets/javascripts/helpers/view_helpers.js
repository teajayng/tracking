_.extend(Backbone.View.prototype, {
  capitaliseFirstLetter: function(string) {
    return string.toLowerCase().charAt(0).toUpperCase() + string.slice(1);
  }
});

String.prototype.capitalize = function() {
  return this.toLowerCase().charAt(0).toUpperCase() + this.slice(1);
}
