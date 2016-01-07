(function( poller, $, undefined ) {
    poller.poll = function() {
      setTimeout(this.updateIncidents, 10000);
    },

    poller.updateIncidents = function() {
      $.ajax({
        url: $('#incidents').data('url'),
        beforeSend: function() {
          $('.loader').show();
        }
      })
        .done(function( data ) {
          $('.loader').hide();
          poller.poll();
        });
    }

}( window.poller = window.poller || {}, jQuery ));

poller.poll()
