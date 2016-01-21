(function( poller, $, undefined ) {
    poller.poll = function() {
      setTimeout(this.updateIncidents, 30000);
    },

    poller.updateIncidents = function() {
      $.ajax({
        url: $('#incidents').data('url'),
        beforeSend: function() {
          $('.loader').show();
        }
      })
        .done(function( data ) {
          setTimeout(function() {$('.loader').hide();}, 3000);
          $('#incidents').html(data['html']);
          poller.poll();
        });
    }

}( window.poller = window.poller || {}, jQuery ));

poller.poll()
