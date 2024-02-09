
<center>
<div id="clockdiv">		
<table>
<tr>
<td></table><img src="http://bestanimations.com/Holidays/Christmas/santa/santa-claus-animated-gif-6.gif" width="50"></td>
<td<b>Mancano <span class="days"></span> giorni <span class="hours"></span> ore <span class="minutes"></span> minuti <span class="seconds"></span> secondi a Natale</b></td>
<td><img src="http://bestanimations.com/Holidays/Christmas/santa/santa-claus-animated-gif-6.gif" width="50"></td>
</tr>
</div>
</center>

<script>

function getTimeRemaining(endtime) {
  var t = Date.parse(endtime) - Date.parse(new Date());
  var seconds = Math.floor((t / 1000) % 60);
  var minutes = Math.floor((t / 1000 / 60) % 60);
  var hours = Math.floor((t / (1000 * 60 * 60)) % 24);
  var days = Math.floor(t / (1000 * 60 * 60 * 24));
  return {
    'total': t,
    'days': days,
    'hours': hours,
    'minutes': minutes,
    'seconds': seconds
  };
}

function initializeClock(id, endtime) {
  var clock = document.getElementById(id);
  var daysSpan = clock.querySelector('.days');
  var hoursSpan = clock.querySelector('.hours');
  var minutesSpan = clock.querySelector('.minutes');
  var secondsSpan = clock.querySelector('.seconds');

  function updateClock() {
    var t = getTimeRemaining(endtime);

    daysSpan.innerHTML = t.days;
    hoursSpan.innerHTML = ('0' + t.hours).slice(-2);
    minutesSpan.innerHTML = ('0' + t.minutes).slice(-2);
    secondsSpan.innerHTML = ('0' + t.seconds).slice(-2);

    if (t.total <= 0) {
      clearInterval(timeinterval);
    }
  }

  updateClock();
  var timeinterval = setInterval(updateClock, 1000);
}

var deadline =  new Date("December 25, 2018 00:01:00")
initializeClock('clockdiv', deadline);
</script>