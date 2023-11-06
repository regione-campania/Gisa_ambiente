var fieldLat ;
var fieldLong ;
var fieldErr ;


function setPositionField(fieldHiddenLatitudine,fieldHiddenLongitudine,fieldHiddenError,latRequest)
{
	
	if (latRequest== null || latRequest== '')
		{
		
	if (fieldHiddenLatitudine!=null)
	{
		fieldHiddenLatitudine.value = '';
		fieldLat = fieldHiddenLatitudine ;

	}
	if (fieldHiddenLongitudine!=null)
	{
		fieldHiddenLongitudine.value = '';
		fieldLong = fieldHiddenLongitudine ;
	}
	if (fieldHiddenError!=null)
	{
		fieldHiddenError.value = '';
		fieldErr = fieldHiddenError ;
	}
	
	navigator.geolocation.getCurrentPosition(
		    gotPosition,
		    errorGettingPosition,
		    {'enableHighAccuracy':true,'timeout':10000,'maximumAge':0}
		);
		}
	
}
function gotPosition(pos)  {
	    /*var outputStr =
	        "latitude:"+ pos.coords.latitude +"\n"+
	        "longitude:"+ pos.coords.longitude +"\n"+
	        "accuracy:"+ pos.coords.accuracy +"\n"+
	
	        "altitude:"+ pos.coords.altitude +"\n"+
	        "altitudeAccuracy:"+ pos.coords.altitudeAccuracy +"\n"+
	        "heading:"+ pos.coords.heading +"\n"+
	        "speed:"+ pos.coords.speed +"";*/
	    	fieldLat.value = pos.coords.latitude ;
	    
	    	fieldLong.value = pos.coords.longitude ;
	        //alert(outputStr);
	}

function errorGettingPosition(err) {
	
	    if(err.code == 1) {
	    	fieldErr.value='Lutente non ha autorizzato la geolocalizzazione';
	    	
	    } else if(err.code == 2) {
	    	fieldErr.value="Posizione non disponibile";
	    } else if(err.code == 3) {
	    	fieldErr.value="Timeout";
	    } else {
	    	fieldErr.value="ERRORE:" + err.message;
	    }
	}
