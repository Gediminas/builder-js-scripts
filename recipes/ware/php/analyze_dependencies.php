<?php

function check($fname, $files_list)
{
	return stripos($files_list, $fname) >= 1;
}

function analyze_dependencies($dep_list_path, $preserves, $type, $silent) // 1-remove list; 2-keep list
{
	$preserves     = " ".$preserves; // comparing specific

	$dep_list = file("$dep_list_path");

	//parsing
	$files_dep = array();
	$stage = 0;
	$current = "";

	foreach ($dep_list as $line)
	{
        if (stripos($line, "ump of file ")>=1)
		{
			$leng = strlen($line);
			$start = strripos($line,'\\');
			$start2 = strripos($line,'/');
			if ($start2 > $start) $start = $start2;
			$fname = substr($line, $start+1, $leng-$start-3); // parsing file names
			$files_dep[$fname] = "";
			$current = $fname;
		}

		if (strlen($line) <4) $stage--;
		if (stripos($line, "\r\n") ==1) $stage = 0;

		if (stripos($line, "Image has the following dependencies")>=1)
		{
			$stage = 2;
		}
		else if (($stage > 0) && (strlen($line) >4)) // parsing stage and not empty line
		{
			$dep_fname = substr($line, 4, strripos($line,'dll')-1);		// put dependent dlls` names to array
			@$files_dep[$current] = $dep_fname.";".$files_dep[$current];
		}
    }
	// end of data parsing

	// calculating file dependencies
	// iterating until there were unused files
	$changed = true;
	$remove_list = "";

	while ($changed)
	{
		$changed = false;

		$files_list = ";".implode($files_dep);
		$require_list = $files_list;

		foreach (array_keys($files_dep) as $file)
		{
			 // remove $file from $require_list.
			$require_list = str_ireplace($file,"", $require_list);
			if ((check($file, $files_list) != 1) && (check($file, $preserves) != 1))
			{
				//if ($silent != 1) echo "unused file:\t$file\n";
				$changed = true;
				$remove_list = $file.";".$remove_list;
				unset($files_dep[$file]);
			}
			else
			{
				//if (@$debug) echo "keeping file:\t$file\n";
			}
		}

		//if (isset($debug) && ($changed) && (@$silent != 1)) echo "----\n";

	}

	// parsing missing files:
	$require = explode(';', chop($require_list));
	$missing = "";
	foreach ($require as $file)
	{
		$file = chop($file);
		if ((!stripos(" ".$missing, $file) >= 1) && (strlen($file) > 4) && (!stripos(" "._system_dll(), $file) >= 1) )
		{
			//if (@$debug || ($type ==3)) echo "missing file: \t$file\n";
			$missing = $missing.$file." ";
		}
	}
	// end of missing

	$keep_list = "";
	foreach (array_keys($files_dep) as $file)
	{
		$keep_list = $file.";".$keep_list;
	}

	//if (@$debug) echo "keeping: ".$keep_list."\n";

	if ($type == 1)	return $remove_list;
	if ($type == 2)	return chop($keep_list);
	if ($type == 3)	return chop($missing);
	return "ERROR";
}

$dep_data_path = $argv[1];
$preserves = $argv[2];
$type = $argv[3]; // 1-remove list; 2-keep list
$silent = isset($argv[4]) ? $argv[4] : 0;
$list = analyze_dependencies($dep_data_path, $preserves, $type, $silent);
echo "$list";

?>
