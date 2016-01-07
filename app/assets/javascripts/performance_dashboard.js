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
          if (data['status_message']) {
            $('#incidents').html(data['status_message']);
          } else {
            $('#incidents').html(data['html']);
          }
          poller.poll();
        });
    }

}( window.poller = window.poller || {}, jQuery ));

poller.poll()
