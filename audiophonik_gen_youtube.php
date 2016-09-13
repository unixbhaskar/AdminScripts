<?php

$youtube_boilerplate = <<<HTML
<!--
You are free to copy and use this sample in accordance with the terms of the
Apache license (http://www.apache.org/licenses/LICENSE-2.0.html)
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>YouTube Player API Sample</title>
    <style type="text/css">
      #videoContainer {
	position:absolute;
	top: -1000px;
	left: -1000px;
	}
      #videoDiv {
        margin-right: 3px;
      }
      #videoInfo {
        margin-left: 3px;
      }
    </style>
    <script src="http://www.google.com/jsapi" type="text/javascript"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">
      google.load("swfobject", "2.1");
    </script>
    <script type="text/javascript">
      /*
       * Chromeless player has no controls.
       */
	var video_ids = [];

      // Update a particular HTML element with a new value
      function updateHTML(elmId, value) {
        document.getElementById(elmId).innerHTML = value;
      }

      // This function is called when an error is thrown by the player
      function onPlayerError(errorCode) {
        alert("An error occured of type:" + errorCode);
      }

      // This function is called when the player changes state
      function onPlayerStateChange(newState) {
        updateHTML("playerState", newState);
	$('#videoTitle').html('');

	// Pull an AJAX query
	if (ytplayer && newState == 1) {
		var current_video_id = ytplayer.getPlaylistIndex();
		current_video_id = video_ids[current_video_id];
		$.ajax({
			url: "http://gdata.youtube.com/feeds/api/videos/" + current_video_id + "?v=2&alt=json",
	                dataType: "jsonp",
        	        success: function (data) { parseresults(data); }
	        });
	
	      }
	}

	function parseresults(data) {
		$('#videoTitle').html(data.entry.title.\$t);
	}

      // Display information about the current state of the player
      function updatePlayerInfo() {
        // Also check that at least one function exists since when IE unloads the
        // page, it will destroy the SWF before clearing the interval.
        if(ytplayer && ytplayer.getDuration) {
          updateHTML("videoDuration", ytplayer.getDuration());
          updateHTML("videoCurrentTime", ytplayer.getCurrentTime());
          updateHTML("bytesTotal", ytplayer.getVideoBytesTotal());
          updateHTML("startBytes", ytplayer.getVideoStartBytes());
          updateHTML("bytesLoaded", ytplayer.getVideoBytesLoaded());
          updateHTML("volume", ytplayer.getVolume());
        }
      }

      // Allow the user to set the volume from 0-100
      function setVideoVolume() {
        var volume = parseInt(document.getElementById("volumeSetting").value);
        if(isNaN(volume) || volume < 0 || volume > 100) {
          alert("Please enter a valid volume between 0 and 100.");
        }
        else if(ytplayer){
          ytplayer.setVolume(volume);
        }
      }

      function playVideo() {
        if (ytplayer) {
          ytplayer.playVideo();
        }
      }

      function pauseVideo() {
        if (ytplayer) {
          ytplayer.pauseVideo();
        }
      }

      function muteVideo() {
        if(ytplayer) {
          ytplayer.mute();
        }
      }

      function unMuteVideo() {
        if(ytplayer) {
          ytplayer.unMute();
        }
      }


      // This function is automatically called by the player once it loads
      function onYouTubePlayerReady(playerId) {
        ytplayer = document.getElementById("ytPlayer");
        // This causes the updatePlayerInfo function to be called every 250ms to
        // get fresh data from the player
        setInterval(updatePlayerInfo, 250);
        updatePlayerInfo();
        ytplayer.addEventListener("onStateChange", "onPlayerStateChange");
        ytplayer.addEventListener("onError", "onPlayerError");
	ytplayer.setPlaybackQuality("hd720");
        //Load an initial video into the player
        // ytplayer.cueVideoById("ylLzyHk54Z0");

	// <REPLACE_WITH_VIDEO_IDS>
      }

      	function prevVideo() {
		if (ytplayer) {
			ytplayer.previousVideo();
		}
	}

	function nextVideo() {
		if (ytplayer) {
			ytplayer.nextVideo();
		}
	}

      // The "main method" of this sample. Called when someone clicks "Run".
      function loadPlayer() {
        // Lets Flash from another domain call JavaScript
        var params = { allowScriptAccess: "always" };
        // The element id of the Flash embed
        var atts = { id: "ytPlayer", modestbranding: 1 };
        // All of the magic handled by SWFObject (http://code.google.com/p/swfobject/)
        swfobject.embedSWF("http://www.youtube.com/apiplayer?" +
                           "version=3&enablejsapi=1&playerapiid=player1",
                           "videoDiv", "480", "360", "9", null, null, params, atts);
      }
      function _run() {
        loadPlayer();
      }
      google.setOnLoadCallback(_run);
    </script>
  </head>
  <body style="font-family: Arial;border: 0 none;">
    <table>
    <tr>
    <td id="videoTd"><div id="videoContainer"><div id="videoDiv" style="display: none">Loading...</div></div></td>
    <td valign="top">
      <div id="videoInfo">
        <p>Player state: <span id="playerState">--</span></p>
        <p>Current Time: <span id="videoCurrentTime">--:--</span> | Duration: <span id="videoDuration">--:--</span></p>
        <p>Bytes Total: <span id="bytesTotal">--</span> | Start Bytes: <span id="startBytes">--</span> | Bytes Loaded: <span id="bytesLoaded">--</span></p>
        <p>Controls: <a href="javascript:void(0);" onclick="playVideo();">Play</a> | <a href="javascript:void(0);" onclick="pauseVideo();">Pause</a> | <a href="javascript:void(0);" onclick="muteVideo();">Mute</a> | <a href="javascript:void(0);" onclick="unMuteVideo();">Unmute</a></p>
        <p><input id="volumeSetting" type="text" size="3" />&nbsp;<a href="javascript:void(0)" onclick="setVideoVolume();">&lt;- Set Volume</a> | Volume: <span id="volume">--</span></p>
	<p><a href="javascript:void(0)" onclick="nextVideo();">Next</a> | <a href="javascript:void(0)" onclick="prevVideo();">Previous</a></p>
	<div id="videoTitle"></div>
      </div>
    </td></tr>
    </table>
  </body>
</html>
HTML;

function get_html($url) {
	$content = file_get_contents($url);
	$next_pg = preg_match('/<a class=\"next\" href=\"([^\"]*)\"/', $content, $next_pg_matches);
	if (!$next_pg) {
        	$next_pg_matches[1] = "";
	}
	return array($content, $next_pg_matches[1]);
}

$content = "";
$next_pg = TRUE;
$current_pg = 1;
$base_url = "http://audiophonik.tumblr.com";
$prev_video_ids = explode("\n", file_get_contents("videoid.txt"));
$cached_video_ids = FALSE;

$video_ids = array();
$youtube_pattern = '/http:\/\/www.youtube.com\/embed\/(.*)\?/';

$url = $base_url;
while ($next_pg) {
	echo "Now retrieving HTML from $url<br />";
	$result = get_html($url);

    // Parse result and add to array
    preg_match_all($youtube_pattern, $result[0], $matches);
    $test_ids = array_unique($matches[1]);

    $video_ids = array_merge($video_ids, $test_ids);
    $video_ids = array_unique($video_ids);

    if ($current_pg == 1 and ($test_ids[0] == $prev_video_ids[0])) {
        // No reason to parse all the other Tumblr pages; just use the previous list
        $cached_video_ids = TRUE;
        $video_ids = $prev_video_ids;
        $next_pg = FALSE;
    } 

    // If there is no "next page" link, merge the arrays.
    // Also merge the arrays if the last video ID we'd stored is detected.
	if (!$result[1] or $next_pg == FALSE) {
		echo "Ending search and now compiling page.<br />";
		$next_pg = FALSE;
	}
	$url = $base_url . $result[1];
    $current_pg++;
}

$str = "video_ids = [";

foreach ($video_ids as $id => $video_id) {
	$str .= "'$video_id',";
}
// remove last comma
$str = substr($str, 0, -1);
$str .= "];\n";
$str .= "\tytplayer.loadPlaylist(video_ids);\n";

$output = str_replace("// <REPLACE_WITH_VIDEO_IDS>", $str, $youtube_boilerplate);

echo $output;

if (!$cached_video_ids) {
    file_put_contents("videoid.txt", implode("\n", $video_ids));
}

