<?php

// $_system_dll = 'KERNEL32.dll MSVCRT.dll comdlg32.dll ole32.dll COMCTL32.dll SHELL32.dll '.
// 			   'OLEAUT32.dll ADVAPI32.dll USER32.dll GDI32.dll MFC42.DLL MSVCP60.dll '.
// 			   'WINSPOOL.DRV WS2_32.dll oledlg.dll ODBC32.dll WINMM.dll RPCRT4.dll '.
// 			   'CRPE32.dll SHLWAPI.dll MSIMG32.dll WSOCK32.dll GDIPLUS.dll ATL.DLL '.
// 			   'MSCOREE.DLL UXTHEME.DLL';

function check($fname, $files_list)
{
	return stripos($files_list, $fname) >= 1;
}

function load_dependencies($path) {
	$bin2dep = Array();
	$root = "";
	$lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
	foreach ($lines as $line) {
		$line = trim($line);
        if (stripos($line, "Dump of file ") === 0) {
			$fname = basename($line);
			$root = $fname;
			$bin2dep[$root] = Array();
			continue;
		}
		if (!$root ||
			$line === "Image has the following dependencies:" ||
			$line === "\f" ||
		    stripos($line, "File Type: ") === 0) {
			continue;
		}
        if ($line === "Summary") {
			break;
		}
		$bin2dep[$root][] = $line;
    }
	// print_r($bin2dep);
	return $bin2dep;
}

function analyze_dependencies($dependencies_path, $preserves, $type) // 1-remove list; 2-keep list
{
	$bin2deps = load_dependencies($dependencies_path);
	$tocheckbins = explode(';', $preserves);

	$exist = Array();
	while (count($tocheckbins)) {
		$tocheckbin = $tocheckbins[0];
		echo "! $tocheckbin\n";

		$deps = $bin2deps[$tocheckbin];
		if ($deps) {
			// $tocheckbins = array_merge($tocheckbins, $deps);
			foreach ($deps as $dep) {
				echo "$dep ";
			}
		}
		echo "\n";

		// if ($exist[$tocheckbin]) {
			array_shift($tocheckbins);
			// continue;
		// }
	}

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
$list = analyze_dependencies($dep_data_path, $preserves, $type);
echo "$list";

?>
