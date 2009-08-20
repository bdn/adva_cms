$(document).ready(function() {
  $('div.tabs li a').click(function() {
    div = $(this).closest('div');
    $('div.active, li.active', div).removeClass('active')
    // activate selected tab and tab content
    $(this).closest('li').addClass('active');
    selected = '#tab_' + $(this).attr('href').replace('#', '');
    $(selected).addClass('active');
  });

  $('.published').hover(
	function() {
	  $(this).prepend($("<span title='published' class='status_title'>&nbsp;</span>"));
    },
	function() {
	  $(this).find($("span.status_title").remove());
    }
  );

  $('.pending').hover(
	function() {
	  $(this).prepend($("<span title='pending' class='status_title'>&nbsp;</span>"));
    },
	function() {
	  $(this).find($("span.status_title").remove());
    }
  );
});