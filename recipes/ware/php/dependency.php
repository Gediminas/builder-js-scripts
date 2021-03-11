<?php

require_once("../conf/conf_fnc.php");
require_once("../tools/run_process.php");


//-------------------
function checkDependList($command_log, $dir, $preserves)
{
	_log_to($command_log, "Cheking preserve list");
	
	$files = explode(' ',$preserves); // comparing specific
	$rez = "";
	foreach ($files as $file)
	{
		$fname = "$dir/$file";
		_log_to($command_log, " Checking file [$fname]");
		
		if (!file_exists($fname)) {
			_log_to($command_log, " FAIL");
			_log_to($command_log, "\n WARNING: [$fname] file not found");
			$rez = $rez.";".$file;
		}
	
	}
	
	_log("done");
	return $rez;
}	

?>
