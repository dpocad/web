/* jshint devel:true */
(function($){
  'use strict';
  $(function(){

    $('.button-collapse').sideNav();
    $('.parallax').parallax();

    // open initial modals
    $('.modal.initial-open').each(function() {
      $(this).openModal();
    });

  }); // end of document ready
})(jQuery); // end of jQuery name space