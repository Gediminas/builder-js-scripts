<?php

function check($fname, $files_list)
{
	return stripos($files_list, $fname) >= 1;
}

function analyze_dependencies($dependencies_path, $preserves, $type, $silent) // 1-remove list; 2-keep list
{
	$lines = file($dependencies_path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

	$bin2dep = Array();
	$stage = 0;
	$current_bin = "";

	foreach ($lines as $line) {
		$line = trim($line);
        if ($line === "Summary") {
			break;
		}
        if (stripos($line, "Dump of file ") === 0) {
			$fname = basename($line);
			$bin2dep[$fname] = "";
			$current_bin = $fname;
			$bin2dep["$current_bin"] = Array();
			// echo "! Analyzing $current_bin\n";
			continue;
		}
		if (!$current_bin ||
			$line === "Image has the following dependencies:" ||
			$line === "\f" ||
		    stripos($line, "File Type: ") === 0) {
			continue;
		}
		$bin2dep[$current_bin][$line] = 1;
    }
	var_dump($bin2dep);
	return;

	// calculating file dependencies
	$changed = true;
	$remove_list = "";

	while ($changed) {
		$changed = false;

		$files_list = ";".implode($bin2dep);
		$require_list = $files_list;

		foreach (array_keys($bin2dep) as $file) {
			 // remove $file from $require_list.
			$require_list = str_ireplace($file,"", $require_list);
			if ((check($file, $files_list) != 1) && (check($file, $preserves) != 1))
			{
				//if ($silent != 1) echo "unused file:\t$file\n";
				$changed = true;
				$remove_list = $file.";".$remove_list;
				unset($bin2dep[$file]);
			}
			else
			{
				//if (@$debug) echo "keeping file:\t$file\n";
			}
		}

		//if (isset($debug) && ($changed) && (@$silent != 1)) echo "----\n";

	}
	$require_list = rtrim($require_list);

	// parsing missing files:
	$missing = Array();
	$require = explode(';', $require_list);
	foreach ($require as $file) {
		$file = trim($file);
		if ($missing[$file]) {
			continue;
		}
		// if (stripos(_system_dll(), $file) !== false) {
		// 	continue;
		// }
		$missing[$file] = 1;
	}
	print_r($mis);
	// end of missing

	// $keep_list = "";
	// foreach (array_keys($bin2dep) as $file)
	// {
	// 	$keep_list = $file.";".$keep_list;
	// }

	// //if (@$debug) echo "keeping: ".$keep_list."\n";

	// fwrite(STDERR, "hello, world!" . PHP_EOL);

	// if ($type == 1)	return $remove_list;
	// if ($type == 2)	return rtrim($keep_list);
	// if ($type == 3)	return rtrim($missing);
	return "ERROR";
}

$dep_data_path = $argv[1];
$preserves = $argv[2];
$type = $argv[3]; // 1-remove list; 2-keep list
$silent = isset($argv[4]) ? $argv[4] : 0;
$list = analyze_dependencies($dep_data_path, $preserves, $type, $silent);
echo "$list";

?>
