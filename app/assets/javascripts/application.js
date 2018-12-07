// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

$( document ).ready(function() {
    $('#generate-code-btn').click(function(event){
      event.preventDefault();
      user_role = $('#role-selected').val();

      Rails.ajax({
        type: "POST", 
        url: "/generate_code",
        data: "type=" + user_role,
        dataType: "JSON",
        success: function(response){
          var listdiv = $('<li class="list-group-item d-flex justify-content-between align-items-center"></li>');
          var spandiv = $('<span class="badge badge-primary badge-pill">' + $('#role-selected').val() + '</span><div>' + response + '</div>');
          listdiv.html(spandiv);
          $('#code-result').append(listdiv);
          $('#code-title').show();
        }
      })
    });

});




