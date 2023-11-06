var options;
$(document).ready(function() {
 options = {
        beforeSend : function() {
                $("#progressbox").show();
                // clear everything
                $("#progressbar").width('0%');
                $("#message").empty();
                $("#percent").html("0%");
        },
        uploadProgress : function(event, position, total, percentComplete) {
                $("#progressbar").width(percentComplete + '%');
                $("#percent").html(percentComplete + '%');

                // change message text to red after 50%
                if (percentComplete > 50) {
                $("#message").html("<font color='red'>File Upload is in progress</font>");
                }
        },
        success : function() {
                $("#progressbar").width('100%');
                $("#percent").html('100%');
        },
        complete : function(response) {
        $("#message").html("<font color='blue'>Your file has been uploaded!</font>");
        },
        error : function() {
        $("#message").html("<font color='red'> ERROR: unable to upload files</font>");
        }
};

});