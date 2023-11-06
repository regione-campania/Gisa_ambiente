
$(function(){

	  $('.tablesorter').tablesorter({
	    theme: 'green',
	    widthFixed : true,
	    showProcessing: true,
	    headerTemplate : '{content} {icon}',
	    widgets: [ 'uitheme', 'zebra', 'filter', 'scroller' ],
	    widgetOptions : {
	      scroller_height : 300,
	      scroller_upAfterSort: true,
	      scroller_jumpToHeader: true,
	      // In tablesorter v2.19.0 the scroll bar width is auto-detected
	      // add a value here to override the auto-detected setting
	      scroller_barWidth : null
	      // scroll_idPrefix was removed in v2.18.0
	      // scroller_idPrefix : 's_'
	    }
	  });

	});